//
//  EventRSVPCarpoolingViewController.swift
//  USC Triathlon
//
//  Created by Daniel Cantwell on 10/23/15.
//  Copyright © 2015 Cantwell Code. All rights reserved.
//

import UIKit

class EventRSVPCarpoolingViewController: UIViewController {
    
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
