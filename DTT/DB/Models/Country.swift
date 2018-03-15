//
//  Country.swift
//  DTT
//
//  Created by Martin Herholdt Rasmussen on 15/03/2018.
//  Copyright © 2018 Martin Herholdt Rasmussen. All rights reserved.
//

import Foundation

class Country {
    
    enum SerializedKey: String {
        case name = "name"
        case code = "code"
    }
    
    let name: String
    let code: String
    
    init?(dictionary: [String: Any]) {
        guard let name = dictionary[SerializedKey.name.rawValue] as? String, let code = dictionary[SerializedKey.code.rawValue] as? String else {
            return nil
        }
        
        self.name =  name
        self.code = code
    }
    
}
