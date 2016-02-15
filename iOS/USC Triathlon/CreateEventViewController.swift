//
//  CreateEventViewController.swift
//  USC Triathlon
//
//  Created by Daniel Cantwell on 10/21/15.
//  Copyright © 2015 Cantwell Code. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController {

    var event: PFObject?
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var carpoolSwitch: UISwitch!
    @IBOutlet weak var cyclingSwitch: UISwitch!
    @IBOutlet weak var eventSelector: UISegmentedControl!
    @IBOutlet weak var cyclingLabel: UILabel!
    @IBOutlet weak var eventLocationField: UITextField!
    @IBOutlet weak var meetingLocationField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let createButton = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.Plain, target: self, action: "createEvent:")
        self.navigationItem.rightBarButtonItem = createButton
        
        let detailsTap = UITapGestureRecognizer(target: self, action: "scrollView")
        let viewTap = UITapGestureRecognizer(target: self, action: "resetView")
        
        self.view.addGestureRecognizer(viewTap)
        descriptionField.addGestureRecognizer(detailsTap)
        
        descriptionField.layer.borderColor = UIColor.lightGrayColor().CGColor
        descriptionField.layer.borderWidth = 0.5
        descriptionField.layer.cornerRadius = 10
    }
    
    func scrollView() {
        descriptionField.becomeFirstResponder()
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        self.view.frame = CGRectMake(self.view.frame.origin.x, -180, self.view.frame.size.width, self.view.frame.size.height)
    }
    
    func resetView() {
        descriptionField.resignFirstResponder()
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)
        
        let detailsTap = UITapGestureRecognizer(target: self, action: "scrollView")
        descriptionField.addGestureRecognizer(detailsTap)
    }
    
    func createEvent(sender: AnyObject) {
        
        if (nameField.text != "" && eventLocationField.text != "" && meetingLocationField.text != "" && descriptionField.text != "") {
            let eventName = nameField.text as String!
            let eventLocation = eventLocationField.text as String!
            let meetingLocation = meetingLocationField.text as String!
            let eventDescription = descriptionField.text as String!
            let eventDate = datepicker.date
            let eventCarpooling = carpoolSwitch.on
            let eventCycling = cyclingSwitch.on
            let eventTypeIndex = eventSelector.selectedSegmentIndex
            var eventType : String?
            
            switch eventTypeIndex {
            case 0:
                eventType = "Practice"
                break
            case 1:
                eventType = "Race"
                break
            case 2:
                eventType = "Event"
                break
            default:
                eventType = "Practice"
            }
            
            
            //        var object = PFObject(className: "TestClass")
            //        object.addObject("Banana", forKey: "favoriteFood")
            //        object.addObject("Chocolate", forKey: "favoriteIceCream")
            //        object.saveInBackground()
            
            event = PFObject(className: "Event")
            event!.setObject(eventName, forKey: "name")
            event!.setObject(eventLocation, forKey: "eventLocation")
            event!.setObject(meetingLocation, forKey: "meetingLocation")
            event!.setObject(eventDescription, forKey: "details")
            event!.setObject(eventDate, forKey: "date")
            event!.setObject(eventCarpooling, forKey: "carpooling")
            event!.setObject(eventCycling, forKey: "cycling")
            event!.setObject(eventType!, forKey: "type")
            
            event!.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                
                if error == nil {
                    self.navigationController?.popViewControllerAnimated(true)
//                    dispatch_async(dispatch_get_main_queue()) {
//                        self.performSegueWithIdentifier("segueCreateEvent", sender: self)
//                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier("segueCancel", sender: self)
                    }
                }
            })
        } else {
            
        }
    }
    
    @IBAction func nameFieldNext(sender: AnyObject) {
        eventLocationField.becomeFirstResponder()
    }
    
    @IBAction func eventLocationFieldNext(sender: AnyObject) {
        meetingLocationField.becomeFirstResponder()
    }
    
    @IBAction func meetingLocationFieldDone(sender: AnyObject) {
        self.view.endEditing(true)
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
        
//        if segue.identifier == "segueCreateEvent" {
//            let nextView = segue.destinationViewController as! EventDetailsViewController
//            nextView.event = event
//        }
    }


}
