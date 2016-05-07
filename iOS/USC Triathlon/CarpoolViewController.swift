//
//  CarpoolViewController.swift
//  USC Triathlon
//
//  Created by Daniel Cantwell on 4/10/16.
//  Copyright © 2016 Cantwell Code. All rights reserved.
//

import UIKit

class CarpoolViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var event : Event!
    let tableSections : NSMutableArray = NSMutableArray()
    var people : [Array<String>] = [Array<String>]()
    var drivers : Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
    
    @IBOutlet weak var tableView: UITableView!
    
    var driverInfoRequestCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
        API().LoadRSVPs(event.id, dataHandler: { (error, data) in
            if (error != nil) {
                let alert = UIAlertController(title: "Couldn't Load RSVPs", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                if let sections = data!["rsvps"] as? [String : Dictionary<String, AnyObject>] {
                    
                    var c = 0
                    
                    for (key, value) in sections {
                        print("Adding Section \(key)")
                        self.tableSections.addObject(key)
                        self.people.append([])
                        for (k, v) in value {
                            
                            let name = v["name"] as! String
                            
                            self.people[c].append(name)
                            print("Adding Name \(name)")
                            
                            self.drivers[k] = Dictionary<String, AnyObject>()
                            
                            self.driverInfoRequestCount += 1
                            API().GetCarProfile(k, dataHandler: { (error, data) in
                                self.driverInfoRequestCount -= 1
                                if error != nil {
                                    print("Could not find car info for the driver")
                                } else {
                                    self.drivers[k] = data!["carInfo"]
                                }
                            })
                        }
                        
                        
                        c += 1
                    }
                    
                    while (self.driverInfoRequestCount > 0) {
                        /* THIS IS TERRIBLE PROGRAMMING PRACTICE, BUT IT IS A TEMPORARY FIX */
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                    }
                    
                } else {
                    print("Data")
                    print(data)
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Table View */
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableSections.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.tableSections[section] as! String
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red: 189/255, green: 32/255, blue: 49/255, alpha: 1)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellType = tableSections[indexPath.section]
        let cell = tableView.dequeueReusableCellWithIdentifier("cell\(cellType)", forIndexPath: indexPath)
        
        // Configure the cell...
        let text = self.people[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = text
        
        if cellType as! String == "Driver" {
            if let info = drivers.first?.1 {
                if let pCap = info["passengerCapacity"] as? String, let bCap = info["bikeCapacity"] as? String {
                    let carInfo = "\(pCap) passengers, \(bCap) bikes"
                    cell.detailTextLabel?.text = carInfo
                }
            }
        }
        
        return cell
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
