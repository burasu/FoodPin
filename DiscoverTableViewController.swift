//
//  DiscoverTableViewController.swift
//  FoodPin
//
//  Created by Blas Fernandez Segura on 4/4/16.
//  Copyright © 2016 Baenne. All rights reserved.
//

import UIKit
import CloudKit

class DiscoverTableViewController: UITableViewController {

    @IBOutlet var spinner:UIActivityIndicatorView!
    @IBOutlet var table: UITableView!
    
    var restaurants:[CKRecord] = []
    
    var imageCache:NSCache = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configuramos el spinner
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        
        getRecordsFromCloud()
        
        // Control para el Pull Refresh
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.whiteColor()
        refreshControl?.tintColor = UIColor.grayColor()
        refreshControl?.addTarget(self, action: #selector(DiscoverTableViewController.getRecordsFromCloud), forControlEvents: UIControlEvents.ValueChanged)
        
        table.addSubview(refreshControl!)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRecordsFromCloud() {
        
        // Borramos todos los datos antes del refresco
        restaurants.removeAll()
        tableView.reloadData()
        
        // Obtenemos (Fetch) los datos usando la API correcta.
        let cloudContainer = CKContainer.defaultContainer()
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        
        // Componemos la consulta a realizar
        let queryOperation = CKQueryOperation(query: query)
//        queryOperation.desiredKeys = ["name", "image"]
        queryOperation.desiredKeys = ["name"]
        queryOperation.queuePriority = .VeryHigh
        queryOperation.resultsLimit = 50
        queryOperation.recordFetchedBlock = { (record:CKRecord!) -> Void in
        
            if let restaurantRecord = record {
                self.restaurants.append(restaurantRecord)
            }
            
        }
        
        queryOperation.queryCompletionBlock = { (cursor:CKQueryCursor?, error:NSError?) -> Void in
        
            if (error != nil) {
                
                print("Failed to get data from iCloud - \(error!.localizedDescription)")
                return
                
            }
            
            print("Successfully retrieve the data from iCloud")
            self.refreshControl?.endRefreshing()
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                self.spinner.stopAnimating()
                self.tableView.reloadData()
            }
            
        }
        
        // Ejecutamos la query.
        publicDatabase.addOperation(queryOperation)
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        let restaurant = restaurants[indexPath.row]
        cell.textLabel?.text = restaurant.objectForKey("name") as? String
        
        // Establecemos una imagen por defecto
        cell.imageView?.image = UIImage(named: "photoalbum")
        
        // Comprobamos si la imagen está almacenada en la cache
        if let imageFileURL = imageCache.objectForKey(restaurant.recordID) as? NSURL {
        
            // Obtenemos la imagen de la caché
            print("Get image from cache")
            cell.imageView?.image = UIImage(data: NSData(contentsOfURL: imageFileURL)!)
            
        } else {
        
            // Obtenemos las imagenes de la nube en segundo plano
            let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
            let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [restaurant.recordID])
            fetchRecordsImageOperation.desiredKeys = ["image"]
            fetchRecordsImageOperation.queuePriority = .VeryHigh
        
            fetchRecordsImageOperation.perRecordCompletionBlock = {(record:CKRecord?, recordID:CKRecordID?, error:NSError?) -> Void in
                if (error != nil) {
                    print("Failed to get restaurant image: \(error!.localizedDescription)")
                    return
                }
            
                if let restaurantRecord = record {
                    NSOperationQueue.mainQueue().addOperationWithBlock() {
                        if let imageAsset = restaurantRecord.objectForKey("image") as? CKAsset {
                            cell.imageView?.image = UIImage(data: NSData(contentsOfURL: imageAsset.fileURL)!)
                            
                            // Añadimos la imagen a la caché para cargarla más rápido
                            self.imageCache.setObject(imageAsset.fileURL, forKey: restaurant.recordID)
                            
                            print("Mostrada imagen: \(imageAsset.fileURL)")
                        }
                    }
                }
            }
        
            publicDatabase.addOperation(fetchRecordsImageOperation)
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
