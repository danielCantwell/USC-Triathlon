//
//  NewsViewController.swift
//  USC Triathlon
//
//  Created by Daniel Cantwell on 10/20/15.
//  Copyright © 2015 Cantwell Code. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var newsTable: UITableView!
    @IBOutlet weak var newsTypeSelector: UISegmentedControl!
    
    var newsToPass: News!
    var news: NSMutableArray = NSMutableArray()
    var index: Int?
    
    @IBOutlet weak var addNewsButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.newsTable.delegate = self
        self.newsTable.dataSource = self
        
        newsTable.estimatedRowHeight = 200.0
        newsTable.rowHeight = UITableViewAutomaticDimension
        
        index = newsTypeSelector.selectedSegmentIndex
//        loadData(index!)
        
        let tempBarButton = addNewsButton
        addNewsButton = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        index = newsTypeSelector.selectedSegmentIndex
        loadData(index!)
    }
    
    func loadData(typeIndex: Int) {
        
        news.removeAllObjects()
        
        if typeIndex == 0 {
            API().LoadNews({ (data, error) -> () in
                if error != nil {
                    print("Could not load news")
                    print(error)
                } else {
                    print("Success loading news")
//                    print(data)
                    
                    let newsDictionary = data!["news"]
                    for (key, value) in newsDictionary as! [String : Dictionary<String, AnyObject>] {
//                        print("value: \(value)")
                        if let a = value["author"] as? String,
                            let c = value["createdAt"] as? Double,
                            let m = value["message"] as? String,
                            let s = value["subject"] as? String {
                                
                                print("news item added")
                                let created = NSDate(timeIntervalSince1970: c / 1000)
                                
                                let newsItem = News(id: key, author: a, createdAt: created, message: m, subject: s)
                                self.news.addObject(newsItem)
                        }
                    }
                    
                    let arrayToSort = NSArray(object: self.news.objectEnumerator().allObjects)[0] as! [News]
                    let sortedArray = arrayToSort.sort({ (a, b) -> Bool in
                        b.createdAt.compare(a.createdAt) == NSComparisonResult.OrderedAscending
                    })
                    self.news = NSMutableArray(array: sortedArray)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.newsTable.reloadData()
                    }
                }
            })
        } else if typeIndex == 1 {
            
        }
    }
    
    @IBAction func typeChanged(sender: AnyObject) {
        index = newsTypeSelector.selectedSegmentIndex
        loadData(index!)
    }
    
    // MARK: - Table view data source
    
    //    Number of Sections in the Table
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //    Number of Rows in the Table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.news.count
    }
    
    //    Configure the cells to be displayed
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("subtitleCell", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        let item = news.objectAtIndex(indexPath.row) as! News
        
        let date = item.createdAt as NSDate
        let dateFormatter = NSDateFormatter()
        
        if index == 0 {
            dateFormatter.dateFormat = "EEE M/dd/YY"
            
            cell.textLabel!.text = item.subject as String
            let dateString = dateFormatter.stringFromDate(date)
            cell.detailTextLabel?.text = dateString
            
            cell.selectionStyle = UITableViewCellSelectionStyle.Default
            
        } else {
            dateFormatter.dateFormat = "h:mm a  M/dd/YY"
            
            cell.textLabel!.text = item.message as String
            cell.textLabel!.numberOfLines = 0;
            cell.textLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
            cell.detailTextLabel!.textAlignment = NSTextAlignment.Right
            
            let dateString = dateFormatter.stringFromDate(date)
            cell.detailTextLabel?.text = item.author + "    " + dateString
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }
        
        return cell
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        let item = news?.objectAtIndex(indexPath.row) as! PFObject
//        var text : NSString = item.valueForKey("message") as! String
//        
//        var cellFont = UIFont().fontWithSize(17.0)
//        var constraintSize = CGSizeMake(280.0, CGFloat(MAXFLOAT))
//        var labelSize =
//        
//        UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
//        CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
//        CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
//        
//        return labelSize.height + 20;
//    }
    
    //    Handle cell selection
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow;
        
        let object = news.objectAtIndex(indexPath!.row) as! News
//
        newsToPass = object
        performSegueWithIdentifier("newsDetails", sender: self)
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */



    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "addNews" {
            let newsTypeIndex = newsTypeSelector.selectedSegmentIndex
            
            let nextView = segue.destinationViewController as! CreateNewsViewController
            nextView.newsTypeIndex = newsTypeIndex
            
        } else if segue.identifier == "newsDetails" {
            let nextView = segue.destinationViewController as! NewsDetailsViewController
            nextView.news = newsToPass
        }
    }
}
