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
    var author : String!
    var createdAt : NSDate!
    var message : String!
    var subject : String!
    
    init(id: String, author: String, createdAt: NSDate, message: String, subject: String) {
        self.id = id
        self.author = author
        self.createdAt = createdAt
        self.message = message
        self.subject = subject
    }
}