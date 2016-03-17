//
//  ScheduleTableViewController.swift
//  USC Triathlon
//
//  Created by Daniel Cantwell on 10/21/15.
//  Copyright © 2015 Cantwell Code. All rights reserved.
//

import UIKit

class ScheduleTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var eventsTable: UITableView!
    var events: NSMutableArray?
    var eventToPass: PFObject!
    @IBOutlet weak var eventSegmentControl: UISegmentedControl!
    @IBOutlet weak var addEventButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.eventsTable.delegate = self
        self.eventsTable.dataSource = self
        
        loadData("all")
    }
    
    override func viewDidAppear(animated: Bool) {
        loadData("all")
    }
    
    func loadData(type: String) {
        events = NSMutableArray()
        let parseQuery = PFQuery(className: "Event")
        
        parseQuery.whereKey("type", equalTo: type)
        parseQuery.orderByDescending("date")
        parseQuery.whereKey("date", greaterThanOrEqualTo: NSCalendar.currentCalendar().startOfDayForDate(NSDate()))
        parseQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object:PFObject in objects! {
                    self.events!.addObject(object)
                }
                
                let array = self.events!.reverseObjectEnumerator().allObjects
                self.events = array as! NSMutableArray
                
                self.eventsTable.reloadData()
            }
        }
    }
    
    @IBAction func typeChanged(sender: AnyObject) {
        let index = eventSegmentControl.selectedSegmentIndex
        
        switch index {
        case 0:
            loadData("Practice")
            break;
        case 1:
            loadData("Race")
            break;
        case 2:
            loadData("Other")
            break;
        default:
            break;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    Number of Sections in the Table
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

//    Number of Rows in the Table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if events != nil {
            return self.events!.count
        } else {
            return 0
        }
    }

//    Configure the cells to be displayed
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        let item = events?.objectAtIndex(indexPath.row) as! PFObject
        
        let date = item.valueForKey("date") as! NSDate
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE M/dd/YY"
        let dateString = dateFormatter.stringFromDate(date)
        
        cell.textLabel!.text = item.valueForKey("name") as! String
        cell.detailTextLabel?.text = dateString


        return cell
    }
    
//    Handle cell selection
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow;
        let object = events?.objectAtIndex(indexPath!.row) as! PFObject
        
        eventToPass = object
        performSegueWithIdentifier("eventDetails", sender: self)
        
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
        
        if segue.identifier == "eventDetails" {
            
            let nextView = segue.destinationViewController as! EventDetailsViewController
            nextView.event = eventToPass
        }
    }


}
