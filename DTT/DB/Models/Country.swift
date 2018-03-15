//
//  Country.swift
//  DTT
//
//  Created by Martin Herholdt Rasmussen on 15/03/2018.
//  Copyright © 2018 Martin Herholdt Rasmussen. All rights reserved.
//

import Foundation

class Country {
    
    enum Fields {
        static let code = "code"
        static let name = "name"
    }
    
    let name: String
    let code: String
    
    init?(dictionary: [String: Any]) {
        guard let name = dictionary[Fields.name] as? String else {
            return nil
        }
        self.name =  name
        
        guard let code = dictionary[Fields.code] as? String else {
            return nil
        }
        self.code = code
    }
    
}
