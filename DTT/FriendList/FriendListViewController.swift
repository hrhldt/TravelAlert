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
import FirebaseFirestore

class FriendListViewController: UIViewController {
 
    @IBOutlet private weak var tableView: UITableView!
    private var friends = [FBUser]()
    private var likes: [(String, Like.Status)] = []
    private var chosenFriend: FBUser?
    private var listenerRegistrations: [ListenerRegistration]? {
        willSet {
            listenerRegistrations?.forEach({ (listenerRegistration) in
                listenerRegistration.remove()
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFriends()
        listenerRegistrations = Database.listenToLikes(facebookID: Database.myID) { [weak self] (likes) in
            print("Likes received: \(likes)")
            self?.likes = likes
            self?.tableView.reloadData()
        }
    }
    
    private func loadFriends() {
        print(FBSDKAccessToken.current().userID)
        let request = FBSDKGraphRequest(graphPath: "/\(Database.myID)/friends", parameters: ["fields": "id, name, picture"], httpMethod: "GET")
        let _ = request?.start(completionHandler: { (connection, result, error) in
            if let error = error {
                print("error: ", error)
            }

            if let resultDict = result as? [String: Any], let data = resultDict["data"] as? [[String: Any]] {
                self.friends = data.map({ FBUser(dictionary: $0) }).flatMap({ $0 })
            }
            
            self.tableView.reloadData()
        })
    
    }
    
    deinit {
        self.listenerRegistrations = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FriendCountryMatchListViewController {
            destination.friend = chosenFriend
        }
    }
}

extension FriendListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.cellIdentifier) as! FriendTableViewCell
        let friend = friends[indexPath.row]
        cell.name = friend.name
        
        var likeStatus: Like.Status = .dislike
        likes.forEach { (id, status) in
            if id == friend.id {
                likeStatus = status
            }
        }
        
        let friendID = friends[indexPath.row].id
        cell.buttonClicked = {
            Database.toggleLike(liker: Database.myID, likee: friendID)
        }
        cell.likeStatus = likeStatus
        cell.pictureURL = friend.pictureURL
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
}

extension FriendListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenFriend = friends[indexPath.row]
        performSegue(withIdentifier: "ShowFriendCountryMatchList", sender: self)
    }
}
