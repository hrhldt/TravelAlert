//
//  SwipeCard.swift
//  DTT
//
//  Created by Henrik Kruger on 15/03/2018.
//  Copyright © 2018 Martin Herholdt Rasmussen. All rights reserved.
//

import Foundation
import UIKit
import TisprCardStack
import Kingfisher

class SwipeCard: CardStackViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clipsToBounds = false
        
        nameLabel.text = ""
        profileImage.kf.setImage(with: URL(string: ""))
        
    }
    
    var name: String = "" {
        didSet {
            nameLabel.text = name
        }
    }
    
    var facebookID: String = "" {
        didSet {
            let url = URL(string: "https://graph.facebook.com/\(facebookID)/picture?type=large")
            profileImage.kf.setImage(with: url)
        }
    }
    

    
    
}
