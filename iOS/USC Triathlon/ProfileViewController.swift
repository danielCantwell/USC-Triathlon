//
//  ProfileViewController.swift
//  USC Triathlon
//
//  Created by Daniel Cantwell on 4/8/16.
//  Copyright © 2016 Cantwell Code. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var hasCarSwitch: UISwitch!
    @IBOutlet weak var pCapStepper: UIStepper!
    @IBOutlet weak var pCapLabel: UILabel!
    @IBOutlet weak var bCapStepper: UIStepper!
    @IBOutlet weak var bCapLabel: UILabel!
    @IBOutlet weak var needRackSwitch: UISwitch!
    @IBOutlet weak var hasBikeSwitch: UISwitch!
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var yearText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let prefs = NSUserDefaults.standardUserDefaults()
        let hasCar = prefs.boolForKey("hasCar")
        let pCap = prefs.integerForKey("passengerCapacity")
        let bCap = prefs.integerForKey("bikeCapacity")
        
        if hasCar {
            hasCarSwitch.setOn(true, animated: true)
            pCapStepper.value = Double(pCap)
            bCapStepper.value = Double(bCap)
            pCapLabel.text = String(pCap)
            bCapLabel.text = String(bCap)
        }
        
        if let fn = prefs.stringForKey("firstName"), let ln = prefs.stringForKey("lastName"), let email = prefs.stringForKey("email"), let year = prefs.stringForKey("year") {
            
            firstNameText.text = fn
            lastNameText.text = ln
            emailText.text = email
            yearText.text = year
            
            hasBikeSwitch.setOn(prefs.boolForKey("hasBike"), animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func PassengerCapacityStepper(sender: AnyObject) {
        pCapLabel.text = String(Int8(pCapStepper.value))
    }
    
    @IBAction func BikeCapacityStepper(sender: AnyObject) {
        bCapLabel.text = String(Int8(bCapStepper.value))
    }
    
    @IBAction func UpdateProfile(sender: AnyObject) {
        let prefs = NSUserDefaults.standardUserDefaults()
        let uid = prefs.stringForKey("uid")!
        
        if firstNameText.text!.isEmpty || lastNameText.text!.isEmpty || emailText.text!.isEmpty || yearText.text!.isEmpty {
            let alert = UIAlertController(title: "Empty Fields", message: "Please do not leave any field blank", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        API().UpdateMemberInfo(uid, email: emailText.text!, firstName: firstNameText.text!, lastName: lastNameText.text!, year: yearText.text!, hasBike: hasBikeSwitch.on)
        prefs.setBool(hasBikeSwitch.on, forKey: "hasBike")
        prefs.setValue(emailText.text, forKey: "email")
        prefs.setValue(firstNameText.text, forKey: "firstName")
        prefs.setValue(lastNameText.text, forKey: "lastName")
        prefs.setValue(yearText.text, forKey: "year")
        API().UpdateCarProfile(uid, hasCar: hasCarSwitch.on, pCap: Int(pCapStepper.value), bCap: Int(bCapStepper.value), needRack: needRackSwitch.on)
        prefs.setBool(hasCarSwitch.on, forKey: "hasCar")
        prefs.setBool(needRackSwitch.on, forKey: "needRack")
        prefs.setInteger(Int(pCapStepper.value), forKey: "passengerCapacity")
        prefs.setInteger(Int(bCapStepper.value), forKey: "bikeCapacity")
        prefs.synchronize()
        
        let alert = UIAlertController(title: "Profile Updated", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
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
