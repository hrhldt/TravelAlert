//
//  FriendListViewController.swift
//  DTT
//
//  Created by Martin Herholdt Rasmussen on 14/03/2018.
//  Copyright © 2018 Martin Herholdt Rasmussen. All rights reserved.
//

import UIKit
import Foundation
import FBSDKCoreKit
import TisprCardStack


class FriendListViewController: CardStackViewController, CardStackDelegate, CardStackDatasource {

    @IBOutlet var cardStackView: CardStackView!
    
    private var data: NSArray = NSArray()
    
    private struct Constants {
        static let cellIndentifier = "TisprCardStackDemoViewCellIdentifier"
        static let padding: CGFloat = 20.0
        static let kHeight: CGFloat = 0.67
        static let topStackVisibleCardCount = 1
        static let bottomStackVisibleCardCount = 0
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let size = CGSize(width: view.bounds.width - 2 * Constants.padding, height: Constants.kHeight * view.bounds.height)
        setCardSize(size)
        
        delegate = self
        datasource = self
        
        //configuration of stacks
        layout.topStackMaximumSize = Constants.topStackVisibleCardCount
        layout.bottomStackMaximumSize = Constants.bottomStackVisibleCardCount
        
        loadFriends()
    }
    
    func loadFriends() {

        let request = FBSDKGraphRequest(graphPath: "/\(FBSDKAccessToken.current().userID!)/friends", parameters: ["fields": "id, name, picture"], httpMethod: "GET")
        request?.start(completionHandler: { (connection, result, error) in
            if let error = error {
                print("error: ", error)
            }
            
            
            if let resultDict = result as? NSDictionary {
                self.data = resultDict["data"] as! NSArray
            }
            
            self.cardStackView.reloadData()
            
        })
        
    }
    
    
    func numberOfCards(in cardStack: CardStackView) -> Int {
        return data.count
    }
    
    func card(_ cardStack: CardStackView, cardForItemAtIndex index: IndexPath) -> CardStackViewCell {
        let cell = cardStack.dequeueReusableCell(withReuseIdentifier: Constants.cellIndentifier, for: index) as! SwipeCard
        
        let dictionary = data.object(at: index.row) as! NSDictionary
        
        cell.name = dictionary["name"] as? String ?? ""
        cell.facebookID = dictionary["id"] as? String ?? ""
        
        cell.backgroundColor = UIColor.gray
    
        return cell
        
    }
    
    func cardDidChangeState(_ cardIndex: Int) {
        // Method to observe card postion changes
    }
    
}
