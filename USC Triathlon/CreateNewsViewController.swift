//
//  CreateNewsViewController.swift
//  USC Triathlon
//
//  Created by Daniel Cantwell on 1/13/16.
//  Copyright © 2016 Cantwell Code. All rights reserved.
//

import UIKit

class CreateNewsViewController: UIViewController {
    
    var news: PFObject?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var details: UITextView!
    @IBOutlet weak var newsSelector: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let createButton = UIBarButtonItem(title: "Send", style: UIBarButtonItemStyle.Plain, target: self, action: "createNews:")
        self.navigationItem.rightBarButtonItem = createButton
        
        details.layer.borderColor = UIColor.lightGrayColor().CGColor
        details.layer.borderWidth = 0.5
        details.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func newsTypeSelector(sender: AnyObject) {
        let newsTypeIndex = newsSelector.selectedSegmentIndex
        
        if newsTypeIndex == 0 {
            titleLabel.hidden = false
            titleText.hidden = false
        } else {
            titleLabel.hidden = true
            titleText.hidden = true
        }
    }
    
    func createNews(sender: AnyObject) {
            
        var newsTitle : String?
        var newsDetails : String?
        var newsType : String?
        
        let newsTypeIndex = newsSelector.selectedSegmentIndex
        
        var okToSave = false
        
        switch newsTypeIndex {
        case 0:
            newsType = "News"
            
            if (titleText.text != "" && details.text != "") {
                newsTitle = titleText.text as String!
                newsDetails = details.text as String!
                
                okToSave = true
                
            } else if (titleText.text == "") {
                titleText.text = "Please enter a title for your news entry"
            } else if (details.text == "") {
                details.text = "Please enter a description for your news entry"
            }
            
            break
        case 1:
            newsType = "Chat"
            
            if (details.text != "") {
                newsDetails = details.text as String!
                
                okToSave = true
            } else {
                details.text = "Please enter a description for your news entry"
            }
            
            break
        default:
            newsType = "News"
            break
        }
        
        if (okToSave) {
            news = PFObject(className: "News")
            news!["user"] = PFUser.currentUser()
            news!.setObject(newsTitle!, forKey: "title")
            news!.setObject(newsDetails!, forKey: "details")
            news!.setObject(newsType!, forKey: "type")

            news!.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                
                if error == nil {
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier("segueCancel", sender: self)
                    }
                }
            })
        }
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
