//
//  API.swift
//  USC Triathlon
//
//  Created by Daniel Cantwell on 2/15/16.
//  Copyright © 2016 Cantwell Code. All rights reserved.
//

import Foundation

class API {
    let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    var dataTask: NSURLSessionDataTask?
    
    static var URL_BASE : String = "http://usctriathlon.herokuapp.com/api/"
    static var POST_LOGIN : String = { URL_BASE + "login" }()
    static var POST_SIGNUP : String = { URL_BASE + "signup" }()
    static var GET_LOAD_EVENTS : String = { URL_BASE + "loadEvents" }()
    
    // API FUNCTIONS
    
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
    
    
    // HELPER FUNCTIONS
    
    private func getJSON(url : NSURL, dataHandler : ([String: AnyObject]) -> ()) -> Void {
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
                do {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    if let data = data, results = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions(rawValue:0)) as? [String: AnyObject] {
                        dataHandler(results)
                    } else {
                        dataHandler(["error": "json error"])
                    }
                } catch let error as NSError {
                    print("Error parsing results: \(error.localizedDescription)")
                }
            }
        })
        
        dataTask!.resume()
    }
    
    private func postJSON(params : String, url : NSURL, dataHandler : ([String: AnyObject]) -> ()) -> Void {
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
                do {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    if let data = data, results = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions(rawValue:0)) as? [String: AnyObject] {
                        dataHandler(results)
                    } else {
                        dataHandler(["error": "json error"])
                    }
                } catch let error as NSError {
                    print("Error parsing results: \(error.localizedDescription)")
                    dataHandler(["error": "Error parsing results: \(error.localizedDescription)"])
                }
            }
        })
        
        dataTask!.resume()
    }
    
    private func formatParams(params : Dictionary<String, String>) -> String {
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
    
    private func JSONParseDict(jsonString:String) -> Dictionary<String, AnyObject> {
        
        if let data: NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
                
                do {
                    if let jsonObj = try NSJSONSerialization.JSONObjectWithData(
                        data,
                        options: NSJSONReadingOptions(rawValue: 0)) as? Dictionary<String, AnyObject>{
                            return jsonObj
                    }
                } catch {
                    print("Error")
                }
        }
        return [String: AnyObject]()
    }
    
    private func HTTPsendRequest(request: NSMutableURLRequest,callback: (String, String?) -> Void) {
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request,completionHandler :
            {
                data, response, error in
                if error != nil {
                    callback("", (error!.localizedDescription) as String)
                } else {
                    callback(NSString(data: data!, encoding: NSUTF8StringEncoding) as! String,nil)
                }
        })
        
        task.resume() //Tasks are called with .resume()
        
    }
    
    private func HTTPGet(url: String, callback: (String, String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!) //To get the URL of the receiver , var URL: NSURL? is used
        HTTPsendRequest(request, callback: callback)
    }
    
    private func HTTPGetJSON(url: String, callback: (Dictionary<String, AnyObject>, String?) -> Void) {
            
            let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            HTTPsendRequest(request) {
                (data: String, error: String?) -> Void in
                if error != nil {
                    callback(Dictionary<String, AnyObject>(), error)
                } else {
                    let jsonObj = self.JSONParseDict(data)
                    callback(jsonObj, nil)
                }
            }
    }
    
    private func HTTPPostJSON(url: String, jsonObj: AnyObject, callback: (Dictionary<String, AnyObject>, String?) -> Void) {
        
            let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let jsonString = JSONStringify(jsonObj)
            let data: NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
            request.HTTPBody = data
        
            HTTPsendRequest(request) {
                (data: String, error: String?) -> Void in
                if error != nil {
                    callback(Dictionary<String, AnyObject>(), error)
                } else {
                    let jsonObj = self.JSONParseDict(data)
                    callback(jsonObj, nil)
                }
            }
    }
*/
}