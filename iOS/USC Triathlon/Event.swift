//
//  Event.swift
//  USC Triathlon
//
//  Created by Daniel Cantwell on 10/22/15.
//  Copyright © 2015 Cantwell Code. All rights reserved.
//

import Foundation

class Event {
    var id : String!
    var type : String!
    var date : NSDate!
    var details : String!
    var meetingLocation : String!
    var carpooling : Bool!
    var cycling : Bool!
    var reqRsvp : Bool!
    
    init(id: String, type: String, date: NSDate, details: String, meetingLocation: String, carpooling: Bool, cycling: Bool, reqRsvp: Bool) {
        self.id = id
        self.type = type
        self.date = date
        self.details = details
        self.meetingLocation = meetingLocation
        self.carpooling = carpooling
        self.cycling = cycling
        self.reqRsvp = reqRsvp
    }
}