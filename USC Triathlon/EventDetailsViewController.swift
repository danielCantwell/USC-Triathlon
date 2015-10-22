//
//  EventDetailsViewController.swift
//  USC Triathlon
//
//  Created by Daniel Cantwell on 10/20/15.
//  Copyright © 2015 Cantwell Code. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    
    var event: PFObject?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var detailsView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let name = event!.valueForKey("name") as! String
        let date = event!.valueForKey("date") as! NSDate
        let eventDetails = event!.valueForKey("details") as! String
        let type = event!.valueForKey("type") as! String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "' at' hh:mm a, 'on' EEE M/dd/YY"
        let dateString = dateFormatter.stringFromDate(date)

        // Do any additional setup after loading the view.
        navBar.title = name
        dateLabel.text = type + dateString
        detailsView.text = eventDetails
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func comment(sender: AnyObject) {
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
