//
//  API.swift
//  USC Triathlon
//
//  Created by Daniel Cantwell on 2/15/16.
//  Copyright © 2016 Cantwell Code. All rights reserved.
//

import Foundation
import UIKit

class API {
    private let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    private var dataTask: NSURLSessionDataTask?
    
    private static let URL_BASE : String = "http://usctriathlon.herokuapp.com/api/"
//    private static let URL_BASE : String = "http://localhost:5000/api/"
    
    private static let POST_LOGIN : String = { URL_BASE + "login" }()
    private static let POST_SIGNUP : String = { URL_BASE + "signup" }()
    
    private static let GET_LOAD_EVENTS : String = { URL_BASE + "loadEvents" }()
    private static let POST_CREATE_EVENT : String = { URL_BASE + "createEvent" }()
    private static let POST_REMOVE_EVENT : String = { URL_BASE + "removeEvent" }()
    private static let POST_RSVP : String = { URL_BASE + "rsvp" }()
    private static let POST_LOAD_RSVPS : String = { URL_BASE + "loadRsvps" }()
    
    private static let GET_LOAD_NEWS : String = { URL_BASE + "loadNews" }()
    private static let POST_ADD_NEWS : String = { URL_BASE + "addNews" }()
    
    private static let POST_UPDATE_MEMBER_CARPOOL : String = { URL_BASE + "updateCarProfile" }()
    private static let POST_UPDATE_MEMBER_INFO : String = { URL_BASE + "updateMemberInfo" }()
    private static let POST_CAR_PROFILE : String = { URL_BASE + "getCarProfile" }()
    
    
    // API FUNCTIONS -------------------------------------------------------------------------------------------------
    
    // ------------- NEWS
    
    func LoadNews(newsHandler: (data: Dictionary<String, AnyObject>?, error: String?) -> ()) {
        print("Load News")
        let url = NSURL(string: API.GET_LOAD_NEWS)
        
        getJSON(url!, dataHandler: {(data) in
            let success = self.apiSuccess(data)
            if success == true {
                newsHandler(data: data, error: nil)
            } else if success == false {
                newsHandler(data: nil, error: data["error"] as? String)
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
            let success = self.apiSuccess(data)
            if success == true {
                print("Add News : Success")
                newsHandler(error: nil)
            } else if success == false {
                print("Add News : \(data["error"] as? String)")
                newsHandler(error: data["error"] as? String)
            } else {
                print("Add News : No data was returned")
                newsHandler(error: "no data was returned")
            }
        })
    }
    
    // ------------- EVENTS
    
    func LoadEvents(type: String, eventHandler: (data: Dictionary<String, AnyObject>?, error: String?) -> ()) {
        print("Load Events")
        let url = NSURL(string: API.GET_LOAD_EVENTS + "/\(type)")
        
        getJSON(url!) { (data) in
            let success = self.apiSuccess(data)
            if success == true {
                print("Load Events : Success")
                eventHandler(data: data, error: nil)
            } else if success == false {
                print("Load Events : \(data["error"] as? String)")
                eventHandler(data: nil, error: data["error"] as? String)
            } else {
                print("Load Events : No data was returned")
                eventHandler(data: nil, error: "no data was returned")
            }
        }
    }
    
    func CreateEvent(type: String, date: Int, meetingLocation: String, details: String, carpooling: Bool, cycling: Bool, reqRsvp: Bool, eventHandler: (error: String?) -> ()) {
        print("Create Event")
        let params = formatParams(["type" : type,"date" : date, "meetingLocation" : meetingLocation, "details" : details,
            "carpooling" : carpooling, "cycling" : cycling, "reqRsvp" : reqRsvp,])
        let url = NSURL(string: API.POST_CREATE_EVENT)
        
        postJSON(params, url: url!) { (data) in
            // get the returned status
            let success = self.apiSuccess(data)
            
            if success == true {
                // if successful
                print("Create Event : Success")
                eventHandler(error: nil)
            } else if success == false {
                // if unsuccessful
                print("Create Event : \(data["error"] as? String)")
                eventHandler(error: data["errro"] as? String)
            } else {
                // if no status
                print("Create Event : No data was returned")
                eventHandler(error: "no data was returned")
            }
        }
    }
    
    func RemoveEvent(type: String, id: String) {
        print("Removing event \(id)")
        let params = formatParams(["type" : type, "id" : id])
        let url = NSURL(string: API.POST_REMOVE_EVENT)
        
        postJSON(params, url: url!) { (data) in
            // get the returned status
            let success = self.apiSuccess(data)
            
            if success == true {
                // if successful
                print("Remove Event : Success")
            } else if success == false {
                // if unsuccessful
                print("Remove Event : \(data["error"] as? String)")
            } else {
                // if no status
                print("Remove Event : No data was returned")
            }
        }
    }
    
    func RSVP(eventId: String, uid: String, method: String, comment: String?, listener: (error: String?) -> ()) {
        print("RSVP for \(eventId)")
        var params : String!
        if comment != nil {
            params = formatParams(["eventId": eventId, "uid": uid, "method": method, "comment": comment!])
        } else {
            params = formatParams(["eventId": eventId, "uid": uid, "method": method])
        }
        let url = NSURL(string: API.POST_RSVP)
        
        postJSON(params, url: url!) { (data) in
            // get the returned status
            let success = self.apiSuccess(data)
            
            if success == true {
                // if successful
                print("Remove Event : Success")
                listener(error: nil)
            } else if success == false {
                // if unsuccessful
                print("Remove Event : \(data["error"] as? String)")
                listener(error: data["error"] as? String)
            } else {
                // if no status
                print("Remove Event : No data was returned")
                listener(error: "No data returned")
            }
        }
    }
    
    func LoadRSVPs(eventId: String, dataHandler: (error: String?, data: Dictionary<String, AnyObject>?) -> ()) {
        print("Loading RSVPs for event \(eventId)")
        let params = formatParams(["eventId": eventId])
        let url = NSURL(string: API.POST_LOAD_RSVPS)
        
        postJSON(params, url: url!) { (data) in
            // get the returned status
            let success = self.apiSuccess(data)
            
            if success == true {
                // if successful
                print("Load RSVPs : Success")
                dataHandler(error: nil, data: data)
            } else if success == false {
                // if unsuccessful
                print("Load RSVPs : \(data["error"] as? String)")
                dataHandler(error: data["error"] as? String, data: nil)
            } else {
                // if no status
                print("Load RSVPs : No data was returned")
                dataHandler(error: "No data was returned", data: nil)
            }
        }
    }
    
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
            // get the returned status
            let success = self.apiSuccess(data)
            
            if success == true {
                // if successful
                if let uid = data["uid"] as? String {
                    listener.signUpSuccess(uid)
                } else {
                    listener.signUpFailure("Sign Up was successful, but no uid was returned")
                }
            } else if success == false {
                // if unsuccessful
                if let error = data["error"] as? String {
                    listener.signUpFailure(error)
                } else {
                    listener.signUpFailure("\(data)\nSign Up was unsuccesful, please try again")
                }
            } else {
                // if no status
                listener.signUpFailure("Neither error nor uid was returned")
            }
        })
    }
    
    /* Params: user id, has car, person capacity, bike capacity, needs a team rack */
    func UpdateCarProfile(uid: String, hasCar: Bool, pCap: Int, bCap: Int, needRack: Bool) {
        print("Update Car Profile")
        
        // prepare parameters and url to pass to the server
        let params = formatParams(["uid": uid, "hasCar": hasCar, "pCap": pCap, "bCap": bCap, "needRack": needRack])
        let url = NSURL(string: API.POST_UPDATE_MEMBER_CARPOOL)
        
        postJSON(params, url: url!) { (data) in
            // get the returned status
            let success = self.apiSuccess(data)
            
            if success == true {
                // if successful
                print("Update Car Profile : Success")
            } else if success == false {
                // if unsuccessful
                print("Update Car Profile : \(data["error"] as? String)")
            } else {
                // if no status
                print("Update Car Profile : No data returned")
            }
        }
    }
    
    func UpdateMemberInfo(uid: String, email: String, firstName: String, lastName: String, year: String, hasBike: Bool) {
        print("Update Member Info")
        
        let params = formatParams(["uid": uid, "email": email, "firstName": firstName, "lastName": lastName, "year": year, "hasBike": hasBike])
        let url = NSURL(string: API.POST_UPDATE_MEMBER_INFO)
        
        postJSON(params, url: url!) { (data) in
            // get the returned status
            let success = self.apiSuccess(data)
            
            if success == true {
                // if successful
                print("Update Member Info : Success")
            } else if success == false {
                // if unsuccessful
                print("Update Member Info : \(data["error"] as? String)")
            } else {
                // if no status
                print("Update Member Info : No data returned")
            }
        }
    }
    
    func GetCarProfile(uid: String, dataHandler: (error: String?, data: Dictionary<String, AnyObject>?) -> ()) {
        print("Get Car Profile")
        let params = formatParams(["uid": uid])
        let url = NSURL(string: API.POST_CAR_PROFILE)
        
        postJSON(params, url: url!) { (data) in
            // get the returned status
            let success = self.apiSuccess(data)
            
            if success == true {
                // if successful
                print("Get Car Profile : Success")
                dataHandler(error: nil, data: data)
            } else if success == false {
                // if unsuccessful
                print("Get Car Profile : \(data["error"] as? String)")
                dataHandler(error: data["error"] as? String, data: nil)
            } else {
                // if no status
                print("Get Car Profile : No data returned")
                dataHandler(error: "No data returned", data: nil)
            }
        }
    }
    
    // HELPER FUNCTIONS ---------------------------------------------------------------------------------------------
    
    private func getJSON(url : NSURL, dataHandler : (data: Dictionary<String, AnyObject>) -> ()) -> Void {
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
                    dataHandler(data: results)
                } else {
                    dataHandler(data: ["error": "json error"])
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
    
    private func postJSON(params : String, url : NSURL, dataHandler : (data: Dictionary<String, AnyObject>) -> ()) -> Void {
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
                    dataHandler(data: results)
                } else {
                    dataHandler(data: ["error": "json error"])
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

    func apiSuccess(data: Dictionary<String, AnyObject>) -> Bool? {
        if let status = data["status"] as? String {
            if status == "success" {
                return true
            } else {
                return false;
            }
        } else {
            return nil
        }
    }
}