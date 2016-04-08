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
    var events: NSMutableArray = NSMutableArray()
    var eventToPass: PFObject!
    @IBOutlet weak var eventSegmentControl: UISegmentedControl!
    @IBOutlet weak var addEventButton: UIBarButtonItem!
    
    var typeIndex : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.eventsTable.delegate = self
        self.eventsTable.dataSource = self
        
//        loadData("practice")
    }
    
    override func viewDidAppear(animated: Bool) {
//        loadData("practice")
        typeChanged(self)
    }
    
    func loadData(type: String) {
        events.removeAllObjects()
        
        API().LoadEvents(type) { (data, error) in
            if (error != nil) {
                print("Could not load events")
                print(error)
            } else {
                print("Success loading events")
//                print(data!["events"])
                
                let newsDictionary = data!["events"]
                for (key, value) in newsDictionary as! [String : Dictionary<String, AnyObject>] {
                    if let d = value["date"] as? NSString,
                        let details = value["details"] as? String,
                        let meetingLocation = value["meetingLocation"] as? String,
                        let carpooling = value["carpooling"] as? Bool,
                        let cycling = value["cycling"] as? Bool,
                        let reqRsvp = value["reqRsvp"] as? Bool {
                        
                        let dateNumber = NSDecimalNumber(string: d as NSString as String)
//                        NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:<your string object>];
                        let date = NSDate(timeIntervalSince1970: Double(dateNumber) / 1000)
                        
                        if date.compare(NSDate()) == NSComparisonResult.OrderedDescending {
                            let eventItem = Event(id: key, date: date, details: details, meetingLocation: meetingLocation, carpooling: carpooling, cycling: cycling, reqRsvp: reqRsvp)
                            self.events.addObject(eventItem)
                            print("event item added")
                        } else {
                            API().RemoveEvent(type, id: key);
                        }
                        
                        
                    } else {
                        if let date = value["date"] as? NSNumber {
                            print("Date: \(date)")
                        } else {
                            print("date could not be extracted")
                        }
                        if let details = value["details"] as? String {
                            print("Details: \(details)")
                        } else {
                            print("details could not be extracted")
                        }
                        if let meetingLocation = value["meetingLocation"] as? String {
                            print("Meeting Location: \(meetingLocation)")
                        } else {
                            print("meetingLocation could not be extracted")
                        }
                        if let carpooling = value["carpooling"] as? Bool {
                            print("Carpooling: \(carpooling)")
                        } else {
                            print("carpooling could not be extracted")
                        }
                        if let cycling = value["cycling"] as? Bool {
                            print("Cycling: \(cycling)")
                        } else {
                            print("cycling could not be extracted")
                        }
                        if let reqRsvp = value["reqRsvp"] as? Bool {
                            print("Requires RSVP: \(reqRsvp)")
                        } else {
                            print("reqRsvp could not be extracted")
                        }
                    }
                }
                
                let arrayToSort = NSArray(object: self.events.objectEnumerator().allObjects)[0] as! [Event]
                let sortedArray = arrayToSort.sort({ (a, b) -> Bool in
                    a.date.compare(b.date) == NSComparisonResult.OrderedAscending
                })
                self.events = NSMutableArray(array: sortedArray)
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.eventsTable.reloadData()
                }
            }
        }
    }
    
    @IBAction func typeChanged(sender: AnyObject) {
        typeIndex = eventSegmentControl.selectedSegmentIndex
        
        switch typeIndex {
        case 0:
            loadData("practice")
            break;
        case 1:
            loadData("race")
            break;
        case 2:
            loadData("other")
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
        return self.events.count
    }

//    Configure the cells to be displayed
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        let item = events.objectAtIndex(indexPath.row) as! Event
        
        let date = item.date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE M/dd/YY"
        let dateString = dateFormatter.stringFromDate(date)
        
        cell.textLabel!.text = item.details
        cell.textLabel!.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        cell.detailTextLabel?.text = dateString


        return cell
    }
    
//    Handle cell selection
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        // Get Cell Label
//        let indexPath = tableView.indexPathForSelectedRow;
//        let object = events?.objectAtIndex(indexPath!.row) as! PFObject
//        
//        eventToPass = object
//        performSegueWithIdentifier("eventDetails", sender: self)
//        
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
            
        } else if segue.identifier == "createEvent" {
            let nextView = segue.destinationViewController as! CreateEventViewController
            
            if typeIndex == 0 {
                nextView.eventType = "practice"
            } else if typeIndex == 1 {
                nextView.eventType = "race"
            } else {
                nextView.eventType = "other"
            }
        }
    }


}
