//
//  CountryCell.swift
//  DTT
//
//  Created by Martin Herholdt Rasmussen on 15/03/2018.
//  Copyright © 2018 Martin Herholdt Rasmussen. All rights reserved.
//

import Foundation
import UIKit

class CountryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryEmojiLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    
    static var cellIdentifier = "CountryTableViewCell"
    
    var country: Country? {
        didSet {
            guard let country = country else { return }
            countryEmojiLabel.text = countryEmoji(fromCode: country.code)
            countryNameLabel.text = country.name
        }
    }
 
    func countryEmoji(fromCode code: String) -> String {
        var emojiStr = ""
        
        let country = code.uppercased()
        for scalar in country.unicodeScalars {
            if let emoji = UnicodeScalar(127397+scalar.value) {
                emojiStr.append(emoji.escaped(asASCII: false))
            }
        }
        
        return emojiStr
    }
}
