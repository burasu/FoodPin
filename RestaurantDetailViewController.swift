//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by Blas Fernandez Segura on 24/3/16.
//  Copyright © 2016 Baenne. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var restaurantImageView:UIImageView!
    var restaurant:Restaurant!
    @IBOutlet var tableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = restaurant.name

        // Do any additional setup after loading the view.
        restaurantImageView.image = UIImage(named: restaurant.image)
        
        tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! RestaurantDetailTableViewCell
        
        // Configuramos la celda
        switch indexPath.row {
        case 0:             // Nombre
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = restaurant.name
        case 1:             // Tipo
            cell.fieldLabel.text = "Type"
            cell.valueLabel.text = restaurant.type
        case 2:             // Localidad
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = restaurant.location
        case 3:
            cell.fieldLabel.text = "Phone"
            cell.valueLabel.text = restaurant.phoneNumber
        case 4:             // Ha estado ahí
            cell.fieldLabel.text = "Been here"
            cell.valueLabel.text = (restaurant.isVisited) ? "Yes, I've been here" : "No"
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
        
    }
    
    @IBAction func close(segue:UIStoryboardSegue)
    {
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showReview" {
            let destinationController = segue.destinationViewController as! ReviewViewController
            destinationController.restaurantImage = restaurant.image
        }
    }
    

}
