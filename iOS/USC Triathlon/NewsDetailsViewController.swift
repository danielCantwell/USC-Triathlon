//
//  NewsDetailsViewController.swift
//  USC Triathlon
//
//  Created by Daniel Cantwell on 10/20/15.
//  Copyright © 2015 Cantwell Code. All rights reserved.
//

import UIKit

class NewsDetailsViewController: UIViewController {
    
    var news : News!
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var subjectBackground: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a EEE M/dd/YY"
        let dateString = dateFormatter.stringFromDate(news.createdAt)

        subjectLabel.text = news.subject
        dateLabel.text = String(dateString)
        messageLabel.text = news.message
        
//        subjectLabel.sizeToFit()
//        dateLabel.sizeToFit()
        subjectBackground.sizeToFit()
        messageLabel.sizeToFit()
        
        
//        let maxWidth : CGFloat = messageLabel.frame.width
//        let maxHeight : CGFloat = 10000
//        let rect = messageLabel.attributedText?.boundingRectWithSize(CGSizeMake(maxWidth, maxHeight),
//            options: .UsesLineFragmentOrigin, context: nil)
//        messageLabel.frame.size.height = (rect?.size.height)!
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
