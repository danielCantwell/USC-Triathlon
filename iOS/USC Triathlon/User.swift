//
//  User.swift
//  USC Triathlon
//
//  Created by Daniel Cantwell on 3/21/16.
//  Copyright © 2016 Cantwell Code. All rights reserved.
//

import Foundation

class User {
    
    static let sharedInstance = User()
    
    // personal information
    var firstName : String = ""
    var lastName : String = ""
    var email : String = ""
    var year : String = ""
    var hasBike : Bool = true
    var isOfficer : Bool = false
    
    // carpool information
    var hasCar : Bool = false
    var personCapacity : Int = 0
    var bikeCapacity : Int = 0
    var needRack : Bool = false
    
    // user prefs
    let prefs : NSUserDefaults
    
    // constructor
    init(first: String, last: String, email: String, isOfficer: Bool, year: String, hasBike: Bool, hasCar: Bool, personCapacity: Int, bikeCapacity: Int, needRack: Bool) {
        self.firstName = first
        self.lastName = last
        self.email = email
        self.isOfficer = isOfficer
        
        self.year = year
        self.hasBike = hasBike
        
        self.hasCar = hasCar
        self.personCapacity = personCapacity
        self.bikeCapacity = bikeCapacity
        self.needRack = needRack
        
        self.prefs = NSUserDefaults.standardUserDefaults()
        
        prefs.setValue(first, forKey: "firstName")
        prefs.setValue(last, forKey: "lastName")
        prefs.setValue(email, forKey: "email")
        prefs.setValue(isOfficer, forKey: "isOfficer")
        prefs.setValue(year, forKey: "year")
        prefs.setValue(hasBike, forKey: "hasBike")
        prefs.setValue(hasCar, forKey: "hasCar")
        prefs.setValue(personCapacity, forKey: "personCapacity")
        prefs.setValue(bikeCapacity, forKey: "bikeCapacity")
        prefs.setValue(needRack, forKey: "needRack")
    }
    
    init() {
        self.prefs = NSUserDefaults.standardUserDefaults()
        
    }
    
}