//
//  AboutTableViewController.swift
//  FoodPin
//
//  Created by Blas Fernandez Segura on 3/4/16.
//  Copyright © 2016 Baenne. All rights reserved.
//

import UIKit
import SafariServices

class AboutTableViewController: UITableViewController, SFSafariViewControllerDelegate {
    
    var sectionTitles = ["Leave Feedback", "Follow Us", "Configuration"]
    var sectionContent = [["Rate us on App Store", "Tell us your feedback"],
                          ["Twitter", "Facebook", "Pinterest", "Instagram"],
                          ["Reset Walkthrough"]]
    var links = ["https://twitter.com/burasu76", "https://facebook.com/blas.fernandez", "https://es.pinterest.com/burasu/", "https://www.instagram.com/burasu76/"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var item = 2
        switch section {
        case 1:
            item = links.count
        case 2:
            item = 1
        default:
            break
        }

        return item
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = sectionContent[indexPath.section][indexPath.row]

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.section {
            
        // Leave us feedback section
        case 0:
            if indexPath.row == 0 {
                if let url = NSURL(string: "http://www.apple.com/itunes/charts/paid-apps/") {
                    UIApplication.sharedApplication().openURL(url)
                }
            } else if indexPath.row == 1 {
                performSegueWithIdentifier("showWebView", sender: self)
            }

        // Follow Us section
        case 1:
            if let url = NSURL(string: links[indexPath.row]) {
                let safariController = SFSafariViewController(URL: url, entersReaderIfAvailable: true)
                UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
                safariController.delegate = self
                presentViewController(safariController, animated: true, completion: nil)
            }
            
        // Configuration:
        case 2:
            
            if indexPath.row == 0 {
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setBool(false, forKey: "hasViewedWalkthrough")
                
                let refreshAlert = UIAlertController(title: "Reset", message: "El tutorial se iniciará la proxima vez que se cargue la aplicación", preferredStyle: UIAlertControllerStyle.Alert)
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                
                presentViewController(refreshAlert, animated: true, completion: nil)
            }
            
        default:
            break
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
