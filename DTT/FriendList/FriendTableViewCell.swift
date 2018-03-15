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
            switch likeStatus {
            case .dislike:
                self.contentView.backgroundColor = UIColor.red.withAlphaComponent(0.2)
            case .unrequitedLike:
                self.contentView.backgroundColor = UIColor.yellow.withAlphaComponent(0.2)
            case .mutualLike:
                self.contentView.backgroundColor = UIColor.green.withAlphaComponent(0.2)
            }
        }
    }
    
    var pictureURL: String = "" {
        didSet {
            let url = URL(string: pictureURL)
            profilePictureImageView.kf.setImage(with: url)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.selectionStyle = .none
    }
    
}
