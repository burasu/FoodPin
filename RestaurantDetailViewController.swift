//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by Blas Fernandez Segura on 24/3/16.
//  Copyright © 2016 Baenne. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var restaurantImageView: UIImageView!
    var restaurant:Restaurant!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        restaurantImageView.image = UIImage(named: restaurant.image)
//        print(restaurant.name)
//        print(restaurant.type)
//        print(restaurant.location)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
        
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
        case 3:             // Ha estado ahí
            cell.fieldLabel.text = "Been here"
            cell.valueLabel.text = (restaurant.isVisited) ? "Yes, I've been here" : "No"
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        
        return cell
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
