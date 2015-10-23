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
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var carpoolSwitch: UISwitch!
    @IBOutlet weak var cyclingSwitch: UISwitch!
    @IBOutlet weak var eventSelector: UISegmentedControl!
    @IBOutlet weak var cyclingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createEvent(sender: AnyObject) {
        
        if (nameField.text != "" && locationField.text != "" && descriptionField.text != "") {
            let eventName = nameField.text as String!
            let eventLocation = locationField.text as String!
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
            event!.setObject(eventLocation, forKey: "location")
            event!.setObject(eventDescription, forKey: "details")
            event!.setObject(eventDate, forKey: "date")
            event!.setObject(eventCarpooling, forKey: "carpooling")
            event!.setObject(eventCycling, forKey: "cycling")
            event!.setObject(eventType!, forKey: "type")
            
            event!.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                
                if error == nil {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier("segueCreateEvent", sender: self)
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier("segueCancel", sender: self)
                    }
                }
            })
        } else {
            
        }
    }

    @IBAction func carpoolSwitch(sender: AnyObject) {
        if !carpoolSwitch.on {
            cyclingLabel.hidden = true
            cyclingSwitch.hidden = true
            cyclingSwitch.on = false
        } else {
            cyclingLabel.hidden = false
            cyclingSwitch.hidden = false
            cyclingSwitch.on = true
        }
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
        
        if segue.identifier == "segueCreateEvent" {
            let nextView = segue.destinationViewController as! EventDetailsViewController
            nextView.event = event
        }
    }


}
