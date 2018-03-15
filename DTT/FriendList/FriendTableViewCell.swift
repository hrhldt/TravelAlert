//
//  FriendTableViewCell.swift
//  DTT
//
//  Created by Martin Herholdt Rasmussen on 14/03/2018.
//  Copyright © 2018 Martin Herholdt Rasmussen. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class FriendTableViewCell: UITableViewCell {
    
    static var cellIdentifier = "FriendTableViewCell"
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var name: String = "" {
        didSet {
            nameLabel.text = name
        }
    }
    
    var likeStatus: Like.Status = .dislike {
        didSet {
            likeButton.setTitle(likeStatus.rawValue, for: .normal)
        }
    }
    
    var pictureURL: String = "" {
        didSet {
            let url = URL(string: pictureURL)
            profilePictureImageView.kf.setImage(with: url)
        }
    }
    
}
