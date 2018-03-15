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

class FriendListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet weak var tableView: UITableView!
    var data: NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Finder"
        loadFriends()
    }
    
    func loadFriends() {
        print(FBSDKAccessToken.current().userID)
        let request = FBSDKGraphRequest(graphPath: "/\(FBSDKAccessToken.current().userID!)/friends", parameters: ["fields": "id, name, picture"], httpMethod: "GET")
        request?.start(completionHandler: { (connection, result, error) in
            if let error = error {
                print("error: ", error)
            }
            
            print(result)
            
            if let resultDict = result as? NSDictionary {
                self.data = resultDict["data"] as! NSArray
            }
            
            self.tableView.reloadData()
        })
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.cellIdentifier) as! FriendTableViewCell
        let dictionary = data.object(at: indexPath.row) as! NSDictionary
        cell.name = dictionary["name"] as? String ?? ""
        if let pictureDict = dictionary["picture"] as? NSDictionary,
            let pictureData = pictureDict["data"] as? NSDictionary,
            let url = pictureData["url"] as? String {
            cell.pictureURL = url
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
