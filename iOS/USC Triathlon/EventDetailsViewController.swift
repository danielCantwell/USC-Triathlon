//
//  EventDetailsViewController.swift
//  USC Triathlon
//
//  Created by Daniel Cantwell on 10/20/15.
//  Copyright © 2015 Cantwell Code. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    
    var event: Event!
    var attendees: NSMutableArray?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailsView: UITextView!
    @IBOutlet weak var meetingLocationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = event.date
        let eventDetails = event.details
        let type = event.type
        let meetingLocation = event.meetingLocation
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a 'on' EEE M/dd/YY"
        let dateString = dateFormatter.stringFromDate(date)

        // Do any additional setup after loading the view.
        self.navigationItem.title = type
        dateLabel.text = dateString
        detailsView.text = eventDetails
        meetingLocationLabel.text = "Meeting at " + meetingLocation
        
        
        let rsvpButton = UIBarButtonItem(title: "RSVP", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EventDetailsViewController.rsvp(_:)))
        self.navigationItem.rightBarButtonItem = rsvpButton
        
        detailsView.layer.borderColor = UIColor.lightGrayColor().CGColor
        detailsView.layer.borderWidth = 0.5
        detailsView.layer.cornerRadius = 10
        
//        loadData("going")
    }
    
//    func loadData(type: String) {
//        
//        if type != "comments" {
//            attendees = NSMutableArray()
//            let parseQuery = PFQuery(className: "RSVP")
//            
//            if let rsvpList = (event?.valueForKey("rsvps") as? [AnyObject]) {
//                
//                var rsvpIds : [AnyObject] = []
//                for rsvp in rsvpList {
//                    let rsvpId = rsvp.valueForKey("objectId") as! String
//                    rsvpIds.append(rsvpId)
//                }
//                parseQuery.includeKey("rsvps")
//                
//                parseQuery.whereKey("objectId", containedIn: rsvpIds)
//                
//                var goingRequest = false
//                if type == "going" {
//                    goingRequest = true
//                }
//                parseQuery.whereKey("going", equalTo: goingRequest)
//                parseQuery.orderByDescending("name")
//                parseQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
//                    if error == nil {
//                        for object:PFObject in objects! {
//                            self.attendees!.addObject(object)
//                            print("attendee added: " + (object.valueForKey("name") as! String))
//                            
//                            let rsvpUserId = object.valueForKey("user")!.valueForKey("objectId") as! String
//                            // Check if current user has rsvp'd
//                            if rsvpUserId == (PFUser.currentUser()!.valueForKey("objectId") as! String) {
//                                self.navigationItem.rightBarButtonItem?.enabled = false
//                                if (object.valueForKey("going") as! Bool) {
//                                    self.navigationItem.rightBarButtonItem?.title = "Going"
//                                } else {
//                                    self.navigationItem.rightBarButtonItem?.title = "Not Going"
//                                }
//                            }
//                        }
//                        
//                        let array = self.attendees!.reverseObjectEnumerator().allObjects
//                        self.attendees = array as! NSMutableArray
//                        
////                        self.tableView.reloadData()
//                    }
//                }
//
//            }
//            
//        } else {
//            
//        }
//    }
    
    func rsvp(sender: UIBarButtonItem) {
        showRSVPAlert()
    }
    
    func submitRSVP(going: String, comments: String) {
        
        API().RSVP(event.id, uid: NSUserDefaults.standardUserDefaults().stringForKey("uid")!, method: going, comment: comments) { (error) in
            if ((error) != nil) {
                let alert = UIAlertController(title: "RSVP Failed", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        }
        
        
//        let firstName = PFUser.currentUser()?.valueForKey("firstname") as! String
//        let lastName = PFUser.currentUser()?.valueForKey("lastname") as! String
//        
//        let eventRSVP = PFObject(className: "RSVP")
//        eventRSVP["user"] = PFUser.currentUser()
//        eventRSVP["name"] = firstName + " " + lastName
//        eventRSVP["status"] = going
//        eventRSVP["comment"] = comments
//        
//        eventRSVP.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//            
//            if error == nil {
//                
//                self.event!.addObject(eventRSVP, forKey: "rsvps")
//                self.event?.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//                    
//                    if error == nil {
//                        self.navigationController?.popViewControllerAnimated(true)
//                    }
//                }
//            }
//        }
    }
    
    func showRSVPAlert() {
        let prefs = NSUserDefaults.standardUserDefaults()
        let hasCar = prefs.boolForKey("hasCar")
        let pCap = prefs.integerForKey("passengerCapacity")
        let bCap = prefs.integerForKey("bikeCapacity")
        
        
        //                Create Alert
        let alertMessage = UIAlertController(title: "RSVP", message: "How are you getting there?", preferredStyle: UIAlertControllerStyle.Alert)
        //                Add Text Field
        alertMessage.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            hasCar ? (textField.text = "Your car holds \(pCap) people and \(bCap) bikes") : (textField.text = "You have no car")
            textField.userInteractionEnabled = false
        })
        //                Add Text Input
        alertMessage.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "comments (optional)"
        })
        //                Add Going Button
        alertMessage.addAction(UIAlertAction(title: "Passenger", style: UIAlertActionStyle.Default, handler: { Void in
            //                    Button Click
            if let comment = alertMessage.textFields?[1].text as String! {
                self.submitRSVP("Passenger", comments: comment)
            } else {
                self.submitRSVP("Passenger", comments: "")
            }
        }))
        if hasCar {
            alertMessage.addAction(UIAlertAction(title: "Driver", style: UIAlertActionStyle.Default, handler: { Void in
                //                    Button Click
                if let comment = alertMessage.textFields?[1].text as String! {
                    self.submitRSVP("Driver", comments: comment)
                } else {
                    self.submitRSVP("Driver", comments: "")
                }
            }))
        }
        //                Add Not Going Button
        alertMessage.addAction(UIAlertAction(title: "Alone", style: UIAlertActionStyle.Default, handler: { Void in
            //                    Button Click
            
            if let comment = alertMessage.textFields?[1].text as String! {
                self.submitRSVP("Alone", comments: comment)
            } else {
                self.submitRSVP("Alone", comments: "")
            }
        }))
        //                Cancel Button
        alertMessage.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) in
            alertMessage.dismissViewControllerAnimated(true, completion: nil)
        }))
        //                Show Alert
        self.presentViewController(alertMessage, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "eventPeople" {
            
            let nextView = segue.destinationViewController as! CarpoolViewController
            nextView.event = event
        }
    }
    

}
