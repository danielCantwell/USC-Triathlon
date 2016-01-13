//
//  EventDetailsViewController.swift
//  USC Triathlon
//
//  Created by Daniel Cantwell on 10/20/15.
//  Copyright © 2015 Cantwell Code. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var event: PFObject?
    var attendees: NSMutableArray?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailsView: UITextView!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var meetingLocationLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentAttendeesSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.sendSubviewToBack(backgroundColor)
        
        let name = event!.valueForKey("name") as! String
        let date = event!.valueForKey("date") as! NSDate
        let eventDetails = event!.valueForKey("details") as! String
        let type = event!.valueForKey("type") as! String
        let eventLocation = event!.valueForKey("eventLocation") as! String
        let meetingLocation = event!.valueForKey("meetingLocation") as! String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "' at' hh:mm a, 'on' EEE M/dd/YY"
        let dateString = dateFormatter.stringFromDate(date)

        // Do any additional setup after loading the view.
        self.navigationItem.title = name
        dateLabel.text = type + dateString
        detailsView.text = eventDetails
        eventLocationLabel.text = eventLocation
        meetingLocationLabel.text = "Meeting at " + meetingLocation
        
        commentButton.hidden = true
        
        let rsvpButton = UIBarButtonItem(title: "RSVP", style: UIBarButtonItemStyle.Plain, target: self, action: "rsvp:")
        self.navigationItem.rightBarButtonItem = rsvpButton
        
        detailsView.layer.borderColor = UIColor.lightGrayColor().CGColor
        detailsView.layer.borderWidth = 0.5
        detailsView.layer.cornerRadius = 10
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadData("going")
    }
    
    func loadData(type: String) {
        
        if type != "comments" {
            attendees = NSMutableArray()
            let parseQuery = PFQuery(className: "RSVP")
            
            if let rsvpList = (event?.valueForKey("rsvps") as? [AnyObject]) {
                
                var rsvpIds : [AnyObject] = []
                for rsvp in rsvpList {
                    let rsvpId = rsvp.valueForKey("objectId") as! String
                    rsvpIds.append(rsvpId)
                }
                parseQuery.includeKey("rsvps")
                
                parseQuery.whereKey("objectId", containedIn: rsvpIds)
                
                var goingRequest = false
                if type == "going" {
                    goingRequest = true
                }
                parseQuery.whereKey("going", equalTo: goingRequest)
                parseQuery.orderByDescending("name")
                parseQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
                    if error == nil {
                        for object:PFObject in objects! {
                            self.attendees!.addObject(object)
                            print("attendee added: " + (object.valueForKey("name") as! String))
                            
                            let rsvpUserId = object.valueForKey("user")!.valueForKey("objectId") as! String
                            // Check if current user has rsvp'd
                            if rsvpUserId == (PFUser.currentUser()!.valueForKey("objectId") as! String) {
                                self.navigationItem.rightBarButtonItem?.enabled = false
                                if (object.valueForKey("going") as! Bool) {
                                    self.navigationItem.rightBarButtonItem?.title = "Going"
                                } else {
                                    self.navigationItem.rightBarButtonItem?.title = "Not Going"
                                }
                            }
                        }
                        
                        let array = self.attendees!.reverseObjectEnumerator().allObjects
                        self.attendees = array as! NSMutableArray
                        
                        self.tableView.reloadData()
                    }
                }

            }
            
        } else {
            
        }
    }
    
    @IBAction func commentsAttendees(sender: AnyObject) {
        let index = commentAttendeesSegment.selectedSegmentIndex
        
        if index == 0 {
            commentButton.hidden = false
            loadData("comments")
        } else if index == 1 {
            commentButton.hidden = true
            loadData("going")
        } else if index == 2 {
            commentButton.hidden = true
            loadData("not going")
        }
    }
    
    func rsvp(sender: UIBarButtonItem) {
        let carpooling = event?.valueForKey("carpooling") as! Bool
        let cycling = event?.valueForKey("cycling") as! Bool
        
        if carpooling && cycling {
            performSegueWithIdentifier("eventRSVP", sender: self)
        } else if carpooling {
            performSegueWithIdentifier("rsvpCarpoolingNoCycling", sender: self)
        } else if cycling {
            performSegueWithIdentifier("rsvpCyclingNoCarpooling", sender: self)
        } else {
            showRSVPAlert()
        }
    }
    
    func submitRSVP(going: Bool, comments: String) {
        let firstName = PFUser.currentUser()?.valueForKey("firstname") as! String
        let lastName = PFUser.currentUser()?.valueForKey("lastname") as! String
        
        let eventRSVP = PFObject(className: "RSVP")
        eventRSVP["user"] = PFUser.currentUser()
        eventRSVP["name"] = firstName + " " + lastName
        eventRSVP["going"] = going
        eventRSVP["drivingSelf"] = false
        eventRSVP["canDrive"] = false
        eventRSVP["seats"] = 0
        eventRSVP["bikeSpots"] = 0
        eventRSVP["requestingBikeRack"] = false
        eventRSVP["requestingTeamBike"] = false
        eventRSVP["comment"] = comments
        
        eventRSVP.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            
            if error == nil {
                
                self.event!.addObject(eventRSVP, forKey: "rsvps")
                self.event?.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    
                    if error == nil {
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                }
            }
        }
    }
    
    func showRSVPAlert() {
        //                Create Alert
        let alertMessage = UIAlertController(title: "RSVP", message: "Are You Going?", preferredStyle: UIAlertControllerStyle.Alert)
        //                Add Text Input
        alertMessage.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "comments (optional)"
        })
        //                Add Not Going Button
        alertMessage.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: { Void in
            //                    Button Click
            
            if let comment = alertMessage.textFields?.first?.text as String! {
                self.submitRSVP(false, comments: comment)
            } else {
                self.submitRSVP(false, comments: "")
            }
        }))
        //                Add Going Button
        alertMessage.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Cancel, handler: { Void in
            //                    Button Click
            if let comment = alertMessage.textFields?.first?.text as String! {
                self.submitRSVP(true, comments: comment)
            } else {
                self.submitRSVP(true, comments: "")
            }
        }))
        //                Show Alert
        self.presentViewController(alertMessage, animated: true, completion: nil)
    }
    
    @IBAction func comment(sender: AnyObject) {
        
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
        if attendees != nil {
            return self.attendees!.count
        } else {
            return 0
        }
    }
    
    //    Configure the cells to be displayed
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        let item = attendees?.objectAtIndex(indexPath.row) as! PFObject
        
        cell.textLabel!.text = item.valueForKey("name") as! String
        
        let index = commentAttendeesSegment.selectedSegmentIndex
        
        if index == 1 {
            cell.detailTextLabel?.text = "passenger"
        }
        
        return cell
    }
    
    //    Handle cell selection
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        // Get Cell Label
//        let indexPath = tableView.indexPathForSelectedRow;
//        let object = attendees?.objectAtIndex(indexPath!.row) as! PFObject
//        
//        eventToPass = object
//        performSegueWithIdentifier("eventDetails", sender: self)
//        
//    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "eventRSVP" {
            
            let nextView = segue.destinationViewController as! EventRSVPViewController
            nextView.event = event
        } else if segue.identifier == "rsvpCarpoolingNoCycling" {
            
        } else if segue.identifier == "rsvpCyclingNoCarpooling" {
            let nextView = segue.destinationViewController as! EventRSVPCyclingViewController
            nextView.event = event
        }
    }
    

}
