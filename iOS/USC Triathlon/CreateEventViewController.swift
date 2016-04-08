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
    var eventType: String!
    
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var carpoolSwitch: UISwitch!
    @IBOutlet weak var cyclingSwitch: UISwitch!
    @IBOutlet weak var cyclingLabel: UILabel!
    @IBOutlet weak var meetingLocationField: UITextField!
    @IBOutlet weak var reqRsvpSwitch: UISwitch!
    @IBOutlet weak var eventTypeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        eventTypeLabel.text = eventType
        
        let createButton = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CreateEventViewController.createEvent(_:)))
        self.navigationItem.rightBarButtonItem = createButton
        
        let detailsTap = UITapGestureRecognizer(target: self, action: #selector(CreateEventViewController.scrollView))
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(CreateEventViewController.resetView))
        
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
        
        let detailsTap = UITapGestureRecognizer(target: self, action: #selector(CreateEventViewController.scrollView))
        descriptionField.addGestureRecognizer(detailsTap)
    }
    
    func createEvent(sender: AnyObject) {
        
        if (meetingLocationField.text != "" && descriptionField.text != "") {
            let meetingLocation = meetingLocationField.text as String!
            let eventDescription = descriptionField.text as String!
            let eventDate = datepicker.date
            let eventCarpooling = carpoolSwitch.on
            let eventCycling = cyclingSwitch.on
            let eventReqRsvp = reqRsvpSwitch.on
            
            let time : Int = Int(eventDate.timeIntervalSince1970 * 1000)
            
            API().CreateEvent(eventType, date: time, meetingLocation: meetingLocation, details: eventDescription, carpooling: eventCarpooling, cycling: eventCycling, reqRsvp: eventReqRsvp, eventHandler: { (error) in
                if error == nil {
                    print("Event Created - Returning to Schedule")
//                    self.navigationController?.popViewControllerAnimated(true)
//                    self.dismissViewControllerAnimated(false, completion: nil)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                } else {
                    self.title = "Creation Failed. Try Again"
                }
            })
        } else {
            
        }
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
