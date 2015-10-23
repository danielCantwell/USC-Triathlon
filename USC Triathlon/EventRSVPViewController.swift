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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var goingSwitch: UISwitch!
    @IBOutlet weak var drivingSelfSwitch: UISwitch!
    @IBOutlet weak var hasCarSwitch: UISwitch!
    @IBOutlet weak var seatsLabel: UILabel!
    @IBOutlet weak var rackSwitch: UISwitch!
    @IBOutlet weak var bikesLabel: UILabel!
    @IBOutlet weak var teamBikeSwitch: UISwitch!
    @IBOutlet weak var commentsLabel: UITextField!
    @IBOutlet weak var seatsCaption: UILabel!
    @IBOutlet weak var bikesCaption: UILabel!
    @IBOutlet weak var seatsStepper: UIStepper!
    @IBOutlet weak var bikesStepper: UIStepper!
    @IBOutlet weak var requestRackCaption: UILabel!
    @IBOutlet weak var hasCarCaption: UILabel!
    @IBOutlet weak var hasBikeSwitch: UISwitch!
    @IBOutlet weak var requestBikeCaption: UILabel!
    @IBOutlet weak var hasBikeCaption: UILabel!
    @IBOutlet weak var drivingAloneCaption: UILabel!
    @IBOutlet weak var drivingAloneSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

        requestBikeCaption.hidden = true
        teamBikeSwitch.hidden = true
    }
    
    @IBAction func submit(sender: AnyObject) {
        
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
        
        (seatsCaption.hidden) ? (seatsLabel.text = "0") : (seatsLabel.text = "2")
    }
    
    func toggleBikesHidden() {
        bikesCaption.hidden = !bikesCaption.hidden
        bikesStepper.hidden = !bikesStepper.hidden
        bikesLabel.hidden = !bikesLabel.hidden
        
        bikesLabel.text = "0"
    }
    
    func toggleRackHidden() {
        requestRackCaption.hidden = !requestRackCaption.hidden
        rackSwitch.hidden = !rackSwitch.hidden
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
