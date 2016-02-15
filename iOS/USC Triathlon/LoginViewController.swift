//
//  LoginViewController.swift
//  USC Triathlon
//
//  Created by Daniel Cantwell on 10/20/15.
//  Copyright © 2015 Cantwell Code. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        Check if the user is already logged in
        if PFUser.currentUser() != nil {
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("segueLogin", sender: self)
            }
        }
        
        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true
        
        loginPassword.secureTextEntry = true
        
//        var object = PFObject(className: "TestClass")
//        object.addObject("Banana", forKey: "favoriteFood")
//        object.addObject("Chocolate", forKey: "favoriteIceCream")
//        object.saveInBackground()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logIn(sender: AnyObject) {
        
        var userEmail = loginEmail.text as String!
        let userPassword = loginPassword.text as String!
        
        if userEmail != "" && userPassword != "" {
            
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
            
            userEmail = userEmail!.lowercaseString
            
            // email and password are present, attempt to login
            PFUser.logInWithUsernameInBackground(userEmail, password: userPassword) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    // User Exists
                    dispatch_async(dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier("segueLogin", sender: self)
                    }
                } else {
                    // User Does Not Exist
                    self.activityIndicator.stopAnimating()
                    self.loginEmail.text = ""
                    self.loginEmail.placeholder = "usc email... login failed"
                    self.loginPassword.text = ""
                }
            }
            
        } else if loginEmail.text == "" {
            self.loginEmail.placeholder = "usc email (required)"
        } else if loginPassword.text == "" {
            self.loginPassword.placeholder = "password (required)"
        }
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        
//        if segue.identifier == "segueLogin" {
//            
//            
//        }
//    }
    

}
