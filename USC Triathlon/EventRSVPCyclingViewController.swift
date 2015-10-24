//
//  EventRSVPCyclingViewController.swift
//  USC Triathlon
//
//  Created by Daniel Cantwell on 10/23/15.
//  Copyright © 2015 Cantwell Code. All rights reserved.
//

import UIKit

class EventRSVPCyclingViewController: UIViewController {
    
    var event: PFObject!
    
    @IBOutlet weak var haveBikeCaption: UILabel!
    @IBOutlet weak var requestingBikeCaption: UILabel!
    @IBOutlet weak var goingSwitch: UISwitch!
    @IBOutlet weak var haveBikeSwitch: UISwitch!
    @IBOutlet weak var requestingBikeSwitch: UISwitch!
    @IBOutlet weak var commentsField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let submitButton = UIBarButtonItem(title: "Submit", style: UIBarButtonItemStyle.Plain, target: self, action: "submit")
        self.navigationItem.rightBarButtonItem = submitButton
        
//        self.navigationItem.title = event!.valueForKey("name") as! String
        
//        Start with "requesting team bike" hidden
        requestingBikeCaption.hidden = true
        requestingBikeSwitch.hidden = true
    }
    
    func submit() {
        let eventRSVP = PFObject(className: "RSVP")
        eventRSVP["user"] = PFUser.currentUser()
        eventRSVP["going"] = goingSwitch.on
        eventRSVP["drivingSelf"] = false
        eventRSVP["canDrive"] = false
        eventRSVP["seats"] = 0
        eventRSVP["bikeSpots"] = 0
        eventRSVP["requestingBikeRack"] = false
        eventRSVP["requestingTeamBike"] = requestingBikeSwitch.on
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
    
    @IBAction func goingChanged(sender: AnyObject) {
        
        if goingSwitch.on {
            haveBikeCaption.hidden = false
            haveBikeSwitch.hidden = false
            haveBikeSwitch.on = true
        } else {
            haveBikeCaption.hidden = true
            haveBikeSwitch.hidden = true
            haveBikeSwitch.on = false
        }
        requestingBikeCaption.hidden = true
        requestingBikeSwitch.hidden = true
        requestingBikeSwitch.on = false
    }
    
    @IBAction func hasBikeChanged(sender: AnyObject) {
        
        if haveBikeSwitch.on {
            requestingBikeCaption.hidden = true
            requestingBikeSwitch.hidden = true
            requestingBikeSwitch.on = false
        } else {
            requestingBikeCaption.hidden = false
            requestingBikeSwitch.hidden = false
            requestingBikeSwitch.on = true
        }
    }
    
    @IBAction func commentDone(sender: AnyObject) {
        commentsField.resignFirstResponder()
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
