//
//  Like.swift
//  DTT
//
//  Created by Troels Michael Trebbien on 15/03/2018.
//  Copyright © 2018 Martin Herholdt Rasmussen. All rights reserved.
//

import Foundation

class Like {
    
    enum Fields {
        static let liker = "liker"
        static let likee = "likee"
    }
    
    let liker: String
    let likee: String

    init?(dictionary: [String: Any]) {
        guard let liker = dictionary[Fields.liker] as? String else {
            return nil
        }
        self.liker =  liker
        
        guard let likee = dictionary[Fields.likee] as? String else {
            return nil
        }
        self.likee = likee
    }
    
}
