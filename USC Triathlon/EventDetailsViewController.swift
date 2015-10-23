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
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var backgroundColor: UIView!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentAttendeesSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.sendSubviewToBack(backgroundColor)
        
        let name = event!.valueForKey("name") as! String
        let date = event!.valueForKey("date") as! NSDate
        let eventDetails = event!.valueForKey("details") as! String
        let type = event!.valueForKey("type") as! String
        let location = event!.valueForKey("location") as! String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "' at' hh:mm a, 'on' EEE M/dd/YY"
        let dateString = dateFormatter.stringFromDate(date)

        // Do any additional setup after loading the view.
        navBar.title = name
        dateLabel.text = type + dateString
        detailsView.text = eventDetails
        locationLabel.text = "Meeting at " + location
        
        commentButton.hidden = true
    }
    
    @IBAction func commentsAttendees(sender: AnyObject) {
        let index = commentAttendeesSegment.selectedSegmentIndex
        
        if index == 0 {
            commentButton.hidden = false
        } else if index == 1 {
            commentButton.hidden = true
        }
    }
    
    @IBAction func rsvp(sender: AnyObject) {
        performSegueWithIdentifier("eventRSVP", sender: self)
    }
    
    @IBAction func comment(sender: AnyObject) {
        
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
        
        if segue.identifier == "eventRSVP" {
            
            let nextView = segue.destinationViewController as! EventRSVPViewController
            nextView.event = event
        }
    }
    

}
