//
//  SignUpViewController.swift
//  USC Triathlon
//
//  Created by Daniel Cantwell on 10/20/15.
//  Copyright © 2015 Cantwell Code. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, SignUpListener {
    
    @IBOutlet weak var signupFirstName: UITextField!
    @IBOutlet weak var signupLastName: UITextField!
    @IBOutlet weak var signupEmail: UITextField!
    @IBOutlet weak var signupPassword: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true
        
        errorMessage.hidden = true
        
        signupPassword.secureTextEntry = true
    }
    
    func signup(first: String, last: String, email: String, password: String, isOfficer: Bool) {
        
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        API().SignUp(self, email: email, password: password, firstName: first, lastName: last, officer: isOfficer)
    }
    
    @IBAction func memberSignup(sender: AnyObject) {
        
        let userFirst = signupFirstName.text
        let userLast = signupLastName.text
        var userEmail = signupEmail.text
        let userPassword = signupPassword.text
        
        if userFirst != "" && userLast != "" && userEmail != "" && userPassword != "" {
            
//            Save email as lowercase
            userEmail = userEmail!.lowercaseString
            
            if userEmail!.hasSuffix("@usc.edu") {
                
                self.signup(userFirst!, last: userLast!, email: userEmail!, password: userPassword!, isOfficer: false)
            } else {
//                User email must end with @usc.edu
                self.signupEmail.text = ""
                self.signupEmail.placeholder = "email must be @usc.edu"
                self.signupPassword.text = ""
            }
        } else {
            if userFirst == "" {
                signupFirstName.placeholder = "First Name (required)"
            }
            if userLast == "" {
                signupLastName.placeholder = "Last Name (required)"
            }
            if userEmail == "" {
                signupEmail.placeholder = "usc email (required)"
            }
            if userPassword == "" {
                signupPassword.placeholder = "password (required)"
            }
        }
        
    }
    
    @IBAction func officerSignup(sender: AnyObject) {
        
        let userFirst = signupFirstName.text
        let userLast = signupLastName.text
        var userEmail = signupEmail.text
        let userPassword = signupPassword.text
        
        if userFirst != "" && userLast != "" && userEmail != "" && userPassword != "" {
            
            //            Save email as lowercase
            userEmail = userEmail!.lowercaseString
            
            if userEmail!.hasSuffix("@usc.edu") {
                
//                Create Alert
                let alertMessage = UIAlertController(title: "Officer Signup", message: "Please enter your officer code", preferredStyle: UIAlertControllerStyle.Alert)
//                Add Text Input
                alertMessage.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                    textField.placeholder = "officer code"
                })
//                Add Button
                alertMessage.addAction(UIAlertAction(title: "Sign Up", style: UIAlertActionStyle.Default, handler: { Void in
//                    Button Click
                    let officerCode = alertMessage.textFields?.first?.text as String!
                    if officerCode != "" {
                        
//                        Check if the officer code is valid
                        PFConfig.getConfigInBackgroundWithBlock({ (var config: PFConfig?, error: NSError?) -> () in
                            if error != nil {
                                config = PFConfig.currentConfig()
                            }
                            
                            let configOfficerCode: NSString? = config?["OfficerCode"] as? NSString
                            
                            if let configOfficerCode = configOfficerCode {
                                if officerCode == configOfficerCode {
                                    
//                                    Officer code matches, continue with signup
                                    self.signup(userFirst!, last: userLast!, email: userEmail!, password: userPassword!, isOfficer: true)
                                    
                                } else {
                                    self.errorMessage.text = "Officer code does not match."
                                    self.errorMessage.hidden = false
                                }
                            } else {
                                self.errorMessage.text = "Could not validate code. Please try again"
                                self.errorMessage.hidden = false
                            }
                        })
                        
                    } else {
                        self.errorMessage.text = "Officer Code is Required"
                        self.errorMessage.hidden = false
                    }
                }))
//                Show Alert
                self.presentViewController(alertMessage, animated: true, completion: nil)
                
            } else {
                signupEmail.text = ""
                signupEmail.placeholder = "email must end in @usc.edu"
            }
        } else {
            if userFirst == "" {
                signupFirstName.placeholder = "First Name (required)"
            }
            if userLast == "" {
                signupLastName.placeholder = "Last Name (required)"
            }
            if userEmail == "" {
                signupEmail.placeholder = "usc email (required)"
            }
            if userPassword == "" {
                signupPassword.placeholder = "password (required)"
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Sign Up Listeners */
    
    func signUpSuccess(uid: String) {
        // sign up successful
        print("signup successful")
        
        // Tempory solution to keeping the user logged in
        var prefs = NSUserDefaults.standardUserDefaults()
        prefs.setBool(true, forKey: "userExists")
        prefs.synchronize()
        
        dispatch_async(dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("segueSignup", sender: self)
        }
    }
    
    func signUpFailure(error: String) {
        // sign up failure
        print("signup failed")
        print(error)
        
        // Tempory solution to keeping the user logged in
        var prefs = NSUserDefaults.standardUserDefaults()
        prefs.setBool(false, forKey: "userExists")
        prefs.synchronize()
        
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator.stopAnimating()
            
            self.signupEmail.text = ""
            self.signupEmail.placeholder = "usc email... signup failed"
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
