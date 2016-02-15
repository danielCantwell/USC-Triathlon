//
//  EventRSVPViewController.swift
//  USC Triathlon
//
//  Created by Daniel Cantwell on 10/20/15.
//  Copyright © 2015 Cantwell Code. All rights reserved.
//

import UIKit

class EventRSVPViewController: UIViewController {
    
    var event: PFObject?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var seatsLabel: UILabel!
    @IBOutlet weak var bikesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UITextField!
    
    @IBOutlet weak var goingSwitch: UISwitch!
    @IBOutlet weak var hasBikeSwitch: UISwitch!
    @IBOutlet weak var teamBikeSwitch: UISwitch!
    @IBOutlet weak var drivingAloneSwitch: UISwitch!
    @IBOutlet weak var hasCarSwitch: UISwitch!
    @IBOutlet weak var rackSwitch: UISwitch!
    
    @IBOutlet weak var seatsCaption: UILabel!
    @IBOutlet weak var bikesCaption: UILabel!
    @IBOutlet weak var requestRackCaption: UILabel!
    @IBOutlet weak var hasCarCaption: UILabel!
    @IBOutlet weak var requestBikeCaption: UILabel!
    @IBOutlet weak var hasBikeCaption: UILabel!
    @IBOutlet weak var drivingAloneCaption: UILabel!
    
    @IBOutlet weak var seatsStepper: UIStepper!
    @IBOutlet weak var bikesStepper: UIStepper!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationItem.title = event!.valueForKey("name") as! String

        // Do any additional setup after loading the view.
        let date = event!.valueForKey("date") as! NSDate
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm a, 'on' EEE M/dd/YY"
        let dateString = dateFormatter.stringFromDate(date)
        
        dateLabel.text = dateString
        
        requestBikeCaption.hidden = true
        teamBikeSwitch.hidden = true
        
        let submitButton = UIBarButtonItem(title: "Submit", style: UIBarButtonItemStyle.Plain, target: self, action: "submit:")
        self.navigationItem.rightBarButtonItem = submitButton
        
    }
    
    func submit(sender: UIBarButtonItem) {
        let firstName = PFUser.currentUser()?.valueForKey("firstname") as! String
        let lastName = PFUser.currentUser()?.valueForKey("lastname") as! String
        
        let eventRSVP = PFObject(className: "RSVP")
        eventRSVP["user"] = PFUser.currentUser()
        eventRSVP["name"] = firstName + " " + lastName
        eventRSVP["going"] = goingSwitch.on
        eventRSVP["drivingSelf"] = drivingAloneSwitch.on
        eventRSVP["canDrive"] = hasCarSwitch.on
        eventRSVP["seats"] = seatsStepper.value
        eventRSVP["bikeSpots"] = bikesStepper.value
        eventRSVP["requestingBikeRack"] = rackSwitch.on
        eventRSVP["requestingTeamBike"] = teamBikeSwitch.on
        eventRSVP["comment"] = commentsLabel.text
        
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
    
    @IBAction func going(sender: AnyObject) {
        
        toggleHasBikeHidden()
        if goingSwitch.on {
            hasBikeSwitch.on = true
        }
        
        if !drivingAloneSwitch.on {
            
            if hasCarSwitch.on {
                toggleSeatsHidden()
                toggleRackHidden()
                
                if !rackSwitch.on {
                    toggleBikesHidden()
                }
            }
            
            toggleCarHidden()
            rackSwitch.on = false
        }
    
        requestBikeCaption.hidden = true
        teamBikeSwitch.hidden = true
        teamBikeSwitch.on = false
    
        
        drivingAloneCaption.hidden = !drivingAloneCaption.hidden
        drivingAloneSwitch.hidden = !drivingAloneSwitch.hidden
        drivingAloneSwitch.on = false
    }
    
    @IBAction func hasCarSwitch(sender: AnyObject) {
        toggleSeatsHidden()
        toggleRackHidden()
        
        if !rackSwitch.on {
            toggleBikesHidden()
        }
        
        rackSwitch.on = false
    }
    
    @IBAction func requestingRackSwitch(sender: AnyObject) {
        toggleBikesHidden()
        
        if rackSwitch.on {
            bikesStepper.value = 3
            bikesLabel.text = "3"
        }
    }
    
    @IBAction func seatsChanged(sender: AnyObject) {
        let seatsString = String(Int(seatsStepper.value))
        seatsLabel.text = seatsString
    }
    
    @IBAction func bikesChanged(sender: AnyObject) {
        let bikesString = String(Int(bikesStepper.value))
        bikesLabel.text = bikesString
    }

    @IBAction func drivingSelf(sender: AnyObject) {
        if hasCarSwitch.on {
            toggleSeatsHidden()
            toggleRackHidden()
            
            if !rackSwitch.on {
                toggleBikesHidden()
            }
        }
        
        toggleCarHidden()
        rackSwitch.on = false
    }
    
    
    @IBAction func bringingBike(sender: AnyObject) {
        if hasBikeSwitch.on {
            requestBikeCaption.hidden = true
            teamBikeSwitch.hidden = true
        } else {
            requestBikeCaption.hidden = false
            teamBikeSwitch.hidden = false
        }
        teamBikeSwitch.on = false
    }
    
    func toggleHasBikeHidden() {
        hasBikeCaption.hidden = !hasBikeCaption.hidden
        hasBikeSwitch.hidden = !hasBikeSwitch.hidden
    }
    
    func toggleCarHidden() {
        hasCarCaption.hidden = !hasCarCaption.hidden
        hasCarSwitch.hidden = !hasCarSwitch.hidden
    }
    
    func toggleSeatsHidden() {
        seatsCaption.hidden = !seatsCaption.hidden
        seatsStepper.hidden = !seatsStepper.hidden
        seatsLabel.hidden = !seatsLabel.hidden
        
        if seatsCaption.hidden {
            seatsLabel.text = "0"
            seatsStepper.value = 0
        } else {
            seatsLabel.text = "2"
            seatsStepper.value = 2
        }
    }
    
    func toggleBikesHidden() {
        bikesCaption.hidden = !bikesCaption.hidden
        bikesStepper.hidden = !bikesStepper.hidden
        bikesLabel.hidden = !bikesLabel.hidden
        
        bikesLabel.text = "0"
        bikesStepper.value = 0
    }
    
    func toggleRackHidden() {
        requestRackCaption.hidden = !requestRackCaption.hidden
        rackSwitch.hidden = !rackSwitch.hidden
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "rsvpSubmitted" {
            
            let nextView = segue.destinationViewController as! EventDetailsViewController
            nextView.event = event
        }
    }


}
