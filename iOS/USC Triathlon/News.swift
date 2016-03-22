//
//  News.swift
//  USC Triathlon
//
//  Created by Daniel Cantwell on 3/22/16.
//  Copyright © 2016 Cantwell Code. All rights reserved.
//

import Foundation

class News {
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