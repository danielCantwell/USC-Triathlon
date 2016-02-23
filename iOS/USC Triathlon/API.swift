//
//  API.swift
//  USC Triathlon
//
//  Created by Daniel Cantwell on 2/15/16.
//  Copyright © 2016 Cantwell Code. All rights reserved.
//

import Foundation

class API {
    static var URL_BASE : String = "http://usctriathlon.herokuapp.com/api/"
    static var POST_LOGIN : String = "login"
    static var POST_SIGNUP : String = "signup"
    static var GET_LOAD_EVENTS : String = "loadEvents"
    
    func HTTPsendRequest(request: NSMutableURLRequest, callback: (String, String?) -> Void) {
        
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
    
    static func HTTPGet(url: String, callback: (String, String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!) //To get the URL of the receiver , var URL: NSURL? is used
        HTTPsendRequest(request, callback: callback)
    }
}