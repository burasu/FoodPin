//
//  DiscoverTableViewController.swift
//  FoodPin
//
//  Created by Blas Fernandez Segura on 4/4/16.
//  Copyright © 2016 Baenne. All rights reserved.
//

import UIKit
import Foundation
import CloudKit

class DiscoverTableViewController: UITableViewController {

    @IBOutlet var spinner:UIActivityIndicatorView!
    
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
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]        
        
        // Componemos la consulta a realizar
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name", "type", "location"]
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
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! DiscoverTableViewCell
        
        // Configure the cell...
        let restaurant = restaurants[indexPath.row]
        cell.nameLabel.text = restaurant.objectForKey("name") as? String
        cell.typeLabel.text = restaurant.objectForKey("type") as? String
        print(restaurant.objectForKey("type") as? String)
        cell.locationLabel.text = restaurant.objectForKey("location") as? String
        
        // Establecemos una imagen por defecto
        cell.bgImageView.image = nil
        
        // Comprobamos si la imagen está almacenada en la cache
        if let imageFileURL = imageCache.objectForKey(restaurant.recordID) as? NSURL {
        
            // Obtenemos la imagen de la caché
            print("Get image from cache")
            cell.bgImageView.image = UIImage(data: NSData(contentsOfURL: imageFileURL)!)
            
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
                            cell.bgImageView.image = UIImage(data: NSData(contentsOfURL: imageAsset.fileURL)!)                            
                            // Añadimos la imagen a la caché para cargarla más rápido
                            self.imageCache.setObject(imageAsset.fileURL, forKey: restaurant.recordID)
                        }
                    }
                }
            }
        
            publicDatabase.addOperation(fetchRecordsImageOperation)
        }

        return cell
    }

}
