//
//  FBUser.swift
//  DTT
//
//  Created by Troels Michael Trebbien on 15/03/2018.
//  Copyright © 2018 Martin Herholdt Rasmussen. All rights reserved.
//

import Foundation

class FBUser {
    
    enum Fields {
        static let name = "name"
        static let id = "id"
        static let picture = "picture"
        static let pictureData = "data"
        static let pictureURL = "url"
    }

    let name: String
    let id: String
    let pictureURL: String

    init?(dictionary: [String: Any]) {
        guard let name = dictionary[Fields.name] as? String else {
            return nil
        }
        self.name =  name
        
        guard let id = dictionary[Fields.id] as? String else {
            return nil
        }
        self.id = id
        
        if let picture = dictionary[Fields.picture] as? [String: Any],
            let pictureData = picture[Fields.pictureData] as? [String: Any],
            let pictureDataURL = pictureData[Fields.pictureURL] as? String {
            self.pictureURL = pictureDataURL
        } else {
            self.pictureURL = ""
        }
    }
    
}
