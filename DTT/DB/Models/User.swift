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
        static let facebookID = "facebookID"
        static let countryCodes = "countryCodes"
    }
    
    let facebookID: String
    let countryCodes: [String]
    
    init?(dictionary: [String: Any]) {
        guard let facebookID = dictionary[Fields.facebookID] as? String else {
            return nil
        }
        self.facebookID = facebookID

        guard let countryCodes = dictionary[Fields.countryCodes] as? [String] else {
            return nil
        }
        self.countryCodes = countryCodes
    }
    
}
