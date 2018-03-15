//
//  User.swift
//  DTT
//
//  Created by Troels Michael Trebbien on 15/03/2018.
//  Copyright © 2018 Martin Herholdt Rasmussen. All rights reserved.
//

import Foundation

class User {
    
    enum Fields {
        static let name = "name"
        static let facebookID = "facebookID"
        static let firebaseID = "firebaseID"
        static let matches = "matches"
        static let countries = "countries"
    }
    
    let name: String
    let facebookID: String
    let firebaseID: String
    let matches: [String]
    let countries: [String]
    
    init?(dictionary: [String: Any]) {
        guard let name = dictionary[Fields.name] as? String else {
            return nil
        }
        self.name =  name
        
        guard let facebookID = dictionary[Fields.facebookID] as? String else {
            return nil
        }
        self.facebookID = facebookID
        
        guard let firebaseID = dictionary[Fields.firebaseID] as? String else {
            return nil
        }
        self.firebaseID = firebaseID
        
        guard let matches = dictionary[Fields.matches] as? [String] else {
            return nil
        }
        self.matches = matches
        
        guard let countries = dictionary[Fields.countries] as? [String] else {
            return nil
        }
        self.countries = countries
    }
    
}
