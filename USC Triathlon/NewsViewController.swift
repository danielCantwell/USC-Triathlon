//
//  NewsViewController.swift
//  USC Triathlon
//
//  Created by Daniel Cantwell on 10/20/15.
//  Copyright © 2015 Cantwell Code. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var newsTable: UITableView!
    @IBOutlet weak var newsTypeSelector: UISegmentedControl!
    var news: NSMutableArray?
    var index: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.newsTable.delegate = self
        self.newsTable.dataSource = self
        
        index = newsTypeSelector.selectedSegmentIndex
        loadData(index!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        index = newsTypeSelector.selectedSegmentIndex
        loadData(index!)
    }
    
    func loadData(typeIndex: Int) {
        news = NSMutableArray()
        let parseQuery = PFQuery(className: "News")
        
        var type : String!
        switch typeIndex {
        case 0:
            type = "News"
            break
        case 1:
            type = "Chat"
            break
        default:
            type = "News"
            break
        }
        
        parseQuery.whereKey("type", equalTo: type)
        parseQuery.orderByAscending("createdAt")
        parseQuery.includeKey("user");
        
        parseQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object:PFObject in objects! {
                    self.news!.addObject(object)
                }
                
                let array = self.news!.reverseObjectEnumerator().allObjects
                self.news = array as! NSMutableArray
                
                self.newsTable.reloadData()
            }
        }
    }
    
    @IBAction func typeChanged(sender: AnyObject) {
        index = newsTypeSelector.selectedSegmentIndex
        loadData(index!)
    }
    
    // MARK: - Table view data source
    
    //    Number of Sections in the Table
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //    Number of Rows in the Table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if news != nil {
            return self.news!.count
        } else {
            return 0
        }
    }
    
    //    Configure the cells to be displayed
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("subtitleCell", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        let item = news?.objectAtIndex(indexPath.row) as! PFObject
        
        let date = item.valueForKey("createdAt") as! NSDate
        let dateFormatter = NSDateFormatter()
        
        if index == 0 {
            dateFormatter.dateFormat = "EEE M/dd/YY"
            
            cell.textLabel!.text = item.valueForKey("title") as! String
            
        } else {
            dateFormatter.dateFormat = "h:mm a EEE M/dd/YY"
            
            cell.textLabel!.text = item.valueForKey("details") as! String
        }
        
        let dateString = dateFormatter.stringFromDate(date)
        cell.detailTextLabel?.text = dateString
        
        return cell
    }
    
    //    Handle cell selection
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Get Cell Label
//        let indexPath = tableView.indexPathForSelectedRow;
//        let object = news?.objectAtIndex(indexPath!.row) as! PFObject
//        
//        eventToPass = object
//        performSegueWithIdentifier("eventDetails", sender: self)
        
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



    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "addNews" {
            
            let newsTypeIndex = newsTypeSelector.selectedSegmentIndex
            
            
            let nextView = segue.destinationViewController as! CreateNewsViewController
            nextView.newsTypeIndex = newsTypeIndex
        }
    }
}
