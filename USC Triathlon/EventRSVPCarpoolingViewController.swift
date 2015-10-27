//
//  EventRSVPCarpoolingViewController.swift
//  USC Triathlon
//
//  Created by Daniel Cantwell on 10/23/15.
//  Copyright © 2015 Cantwell Code. All rights reserved.
//

import UIKit

class EventRSVPCarpoolingViewController: UIViewController {
    
    var event: PFObject?
    
    @IBOutlet weak var drivingAloneCaption: UILabel!
    @IBOutlet weak var hasCarCaption: UILabel!
    @IBOutlet weak var seatsCaption: UILabel!
    @IBOutlet weak var goingSwitch: UISwitch!
    @IBOutlet weak var drivingAloneSwitch: UISwitch!
    @IBOutlet weak var hasCarSwitch: UISwitch!
    @IBOutlet weak var seatsStepper: UIStepper!
    @IBOutlet weak var seatsLabel: UILabel!
    @IBOutlet weak var commentsField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let submitButton = UIBarButtonItem(title: "Submit", style: UIBarButtonItemStyle.Plain, target: self, action: "submit")
        self.navigationItem.rightBarButtonItem = submitButton
    }
    
    func submit() {
        let eventRSVP = PFObject(className: "RSVP")
        eventRSVP["user"] = PFUser.currentUser()
        eventRSVP["going"] = goingSwitch.on
        eventRSVP["drivingSelf"] = drivingAloneSwitch.on
        eventRSVP["canDrive"] = hasCarSwitch.on
        eventRSVP["seats"] = seatsStepper.value
        eventRSVP["bikeSpots"] = 0
        eventRSVP["requestingBikeRack"] = false
        eventRSVP["requestingTeamBike"] = false
        eventRSVP["comment"] = commentsField.text
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func isGoing(sender: AnyObject) {
        if !goingSwitch.on {
            hideSeats()
            hideCar()
            hideAlone()
        } else {
            showSeats()
            showCar()
            showAlone()
        }
    }

    @IBAction func isDrivingAlone(sender: AnyObject) {
        if drivingAloneSwitch.on {
            hideSeats()
            hideCar()
        } else {
            showSeats()
            showCar()
        }
    }
    
    @IBAction func hasCar(sender: AnyObject) {
        if !hasCarSwitch.on {
            hideSeats()
        } else {
            showSeats()
        }
    }
    
    @IBAction func seatsChanged(sender: AnyObject) {
        seatsLabel.text = String(Int(seatsStepper.value))
    }
    
    func hideSeats() {
        seatsStepper.value = 0
        seatsLabel.text = "0"
        seatsLabel.hidden = true
        seatsStepper.hidden = true
        seatsCaption.hidden = true
    }
    
    func showSeats() {
        seatsStepper.value = 2
        seatsLabel.text = "2"
        seatsLabel.hidden = false
        seatsStepper.hidden = false
        seatsCaption.hidden = false
    }
    
    func hideCar() {
        hasCarSwitch.on = false
        hasCarSwitch.hidden = true
        hasCarCaption.hidden = true
    }
    
    func showCar() {
        hasCarSwitch.on = true
        hasCarSwitch.hidden = false
        hasCarCaption.hidden = false
    }
    
    func hideAlone() {
        drivingAloneSwitch.on = false
        drivingAloneSwitch.hidden = true
        drivingAloneCaption.hidden = true
    }
    
    func showAlone() {
        drivingAloneSwitch.on = false
        drivingAloneSwitch.hidden = false
        drivingAloneCaption.hidden = false
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
