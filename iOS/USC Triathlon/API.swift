//
//  API.swift
//  USC Triathlon
//
//  Created by Daniel Cantwell on 2/15/16.
//  Copyright © 2016 Cantwell Code. All rights reserved.
//

import Foundation

class API {
    private let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    private var dataTask: NSURLSessionDataTask?
    
    private static let URL_BASE : String = "http://usctriathlon.herokuapp.com/api/"
    private static let POST_LOGIN : String = { URL_BASE + "login" }()
    private static let POST_SIGNUP : String = { URL_BASE + "signup" }()
    private static let POST_ADD_NEWS : String = { URL_BASE + "addNews" }()
    private static let GET_LOAD_EVENTS : String = { URL_BASE + "loadEvents" }()
    private static let GET_LOAD_NEWS : String = { URL_BASE + "loadNews" }()
    
    // API FUNCTIONS -------------------------------------------------------------------------------------------------
    
    // ------------- NEWS
    
    func LoadNews(newsHandler: (data: Dictionary<String, AnyObject>?, error: String?) -> ()) {
        print("Load News")
        let url = NSURL(string: API.GET_LOAD_NEWS)
        
        getJSON(url!, dataHandler: {(data) in
            if let status = data["status"] as? String {
                if status == "success" {
                    newsHandler(data: data, error: nil)
                } else {
                    newsHandler(data: nil, error: data["error"] as? String)
                }
            } else {
                newsHandler(data: nil, error: "no data was returned")
            }
        })
    }
    
    
    func AddNews(author: String, subject: String, message: String, newsHandler: (error: String?) -> ()) {
        print("Add News")
        let params = formatParams(["author" : author, "subject" : subject, "message" : message])
        let url = NSURL(string: API.POST_ADD_NEWS)
        
        postJSON(params, url: url!, dataHandler: {(data) in
            if let status = data["status"] as? String {
                if status == "success" {
                    print("Add News : Success")
                    newsHandler(error: nil)
                } else {
                    print("Add News : \(data["error"] as? String)")
                    newsHandler(error: data["error"] as? String)
                }
            } else {
                print("Add News : No data was returned")
                newsHandler(error: "no data was returned")
            }
        })
    }
    
    // ------------- EVENTS
    
    // ------------- AUTHENTICATION
    
    func MemberLogin(listener: LoginListener, email: String, password: String) -> Void {
        print("Member Login")
        let params = formatParams(["email" : email, "password" : password])
        let url = NSURL(string: API.POST_LOGIN)
        
        postJSON(params, url: url!, dataHandler: {(data) in
            if let status = data["status"] as? String {
                if status == "success" {
                    if let authData = data["authData"] as? NSDictionary {
                        listener.loginSuccess(authData)
                    } else {
                        listener.loginFailure("Login was successful, but no authdata was returned")
                    }
                } else {
                    if let error = data["error"] as? String {
                        listener.loginFailure(error)
                    } else {
                        listener.loginFailure("\(data)\nLogin was unsuccesful, please try again")
                    }
                }
            } else {
                listener.loginFailure("Neither error nor authdata was returned")
            }
        })
    }
    
    func SignUp(listener: SignUpListener, email: String, password: String, firstName: String, lastName: String, officer: Bool) -> Void {
        print("Sign Up")
        let params = formatParams(["email": email, "password": password, "firstName": firstName, "lastName": lastName, "officer": officer])
        let url = NSURL(string: API.POST_SIGNUP)
        
        postJSON(params, url: url!, dataHandler: {(data) in
            if let status = data["status"] as? String {
                if status == "success" {
                    if let uid = data["uid"] as? String {
                        listener.signUpSuccess(uid)
                    } else {
                        listener.signUpFailure("Sign Up was successful, but no uid was returned")
                    }
                } else {
                    if let error = data["error"] as? String {
                        listener.signUpFailure(error)
                    } else {
                        listener.signUpFailure("\(data)\nSign Up was unsuccesful, please try again")
                    }
                }
            } else {
                listener.signUpFailure("Neither error nor uid was returned")
            }
        })
    }
    
    // HELPER FUNCTIONS ---------------------------------------------------------------------------------------------
    
    private func getJSON(url : NSURL, dataHandler : (Dictionary<String, AnyObject>) -> ()) -> Void {
        // show the network activity indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        dataTask = defaultSession.dataTaskWithURL(url, completionHandler: {(data, response, error) in
            
            // 5 - hide the network indicator when you get a response
            dispatch_async(dispatch_get_main_queue()) {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
            
            
            // 6 - get the http response - either an error or the data you requested
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let data = data, results = self.JSONParseDict(data) {
                    dataHandler(results)
                } else {
                    dataHandler(["error": "json error"])
                }
//                do {
//                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//                    if let data = data, results = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions(rawValue:0)) as? [String: AnyObject] {
//                        dataHandler(results)
//                    } else {
//                        dataHandler(["error": "json error"])
//                    }
//                } catch let error as NSError {
//                    print("Error parsing results: \(error.localizedDescription)")
//                }
            }
        })
        
        dataTask!.resume()
    }
    
    private func postJSON(params : String, url : NSURL, dataHandler : (Dictionary<String, AnyObject>) -> ()) -> Void {
        // show the network activity indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let urlRequest = NSMutableURLRequest(URL: url)
        urlRequest.HTTPMethod = "POST"
        urlRequest.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        
        print("postJson")
        
        dataTask = defaultSession.dataTaskWithRequest(urlRequest, completionHandler: {(data, response, error) in
            
            print("dataTask")
            
            // 5 - hide the network indicator when you get a response
            dispatch_async(dispatch_get_main_queue()) {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
            
            // 6 - get the http response - either an error or the data you requested
            if let error = error {
                print(error.localizedDescription)
            } else {
                
                if let data = data, results = self.JSONParseDict(data) {
                    dataHandler(results)
                } else {
                    dataHandler(["error": "json error"])
                }
                
//                do {
//                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//                    
//                    if let data = data, results = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions(rawValue:0)) as? [String: AnyObject] {
//                        dataHandler(results)
//                    } else {
//                        dataHandler(["error": "json error"])
//                    }
//                } catch let error as NSError {
//                    print("Error parsing results: \(error.localizedDescription)")
//                    dataHandler(["error": "Error parsing results: \(error.localizedDescription)"])
//                }
            }
        })
        
        dataTask!.resume()
    }
    
    private func formatParams(params : Dictionary<String, AnyObject>) -> String {
        var formattedParams : String = ""
        
        for (key, value) in params {
            if (formattedParams.isEmpty) {
                formattedParams.appendContentsOf("\(key)=\(value)")
            } else {
                formattedParams.appendContentsOf("&\(key)=\(value)")
            }
            
        }
        
        return formattedParams
    }
    
/*
    private func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
        
        let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(rawValue: 0)
        
        if NSJSONSerialization.isValidJSONObject(value) {
            
            do{
                let data = try NSJSONSerialization.dataWithJSONObject(value, options: options)
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    return string as String
                }
            }catch {
                
                print("error")
                //Access error here
            }
            
        }
        return ""
        
    }
*/
    private func JSONParseDict(data: NSData) -> Dictionary<String, AnyObject>? {
        
        do {
            if let json = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions(rawValue:0)) as? Dictionary<String, AnyObject> {
                return json
            }
        } catch {
            print("Error parsing JSON dictionary")
        }
        
        
//        if let data: NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
//                
//                do {
//                    if let jsonObj = try NSJSONSerialization.JSONObjectWithData(
//                        data,
//                        options: NSJSONReadingOptions(rawValue: 0)) as? Dictionary<String, AnyObject>{
//                            return jsonObj
//                    }
//                } catch {
//                    print("Error parsing JSON dictionary")
//                }
//        }
        return nil
    }

}