//
//  Database.swift
//  DTT
//
//  Created by Troels Michael Trebbien on 15/03/2018.
//  Copyright © 2018 Martin Herholdt Rasmussen. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FBSDKCoreKit

struct Database {
    
    private static var db: Firestore {
        return Firestore.firestore()
    }
    static var myID: String {
        return FBSDKAccessToken.current().userID
    }
    
    private enum Collections {
        static let countries = "Countries"
        static let users = "Users"
        static let likes = "Likes"
    }

    // MARK: - CRUD
    static func createUser(facebookID: String) {
        let ref = db.collection(Collections.users).document(facebookID)
        ref.getDocument { (snapshot, error) in
            guard error == nil else { return }
            if snapshot?.data() == nil {
                let documentData: [String: Any] = [User.Fields.facebookID: facebookID,
                                                   User.Fields.countryCodes: []]
                ref.setData(documentData, completion: { error in
                    if let error = error {
                        print("Error creating user: \(error)")
                    }
                })
            }
        }
    }
    
    static func toggleLike(liker: String, likee: String) {
        let likeID = "\(liker),\(likee)"
        let ref = db.collection(Collections.likes).document(likeID)
        ref.getDocument { (snapshot, error) in
            guard error == nil else { return }
            if snapshot?.data() == nil {
                createLike(liker: liker, likee: likee)
            } else {
                deleteLike(liker: liker, likee: likee)
            }
        }
    }
    
    static func toggleCountryCode(facebookID: String, countryCode: String) {
        let ref = db.collection(Collections.users).document(facebookID)
        ref.getDocument { (snapshot, error) in
            guard error == nil else { return }
            if let data = snapshot?.data(), let user = User(dictionary: data) {
                let countryCodes: [String]
                if user.countryCodes.contains(countryCode) {
                    countryCodes = user.countryCodes.filter({ $0 != countryCode })
                } else {
                    countryCodes = user.countryCodes + [countryCode]
                }
                updateUserCountries(facebookID: facebookID, countryCodes: countryCodes)
            }
        }
    }
    
    static func updateUserCountries(facebookID: String, countryCodes: [String]) {
        let ref = db.collection(Collections.users).document(facebookID)
        ref.updateData([User.Fields.countryCodes : countryCodes]) { (error) in
            if let error = error {
                print("Error updating user's countries: \(error)")
            }
        }
    }
    
    static func getCountryList(completion: @escaping ([Country]) -> Void) {
        let ref = db.collection(Collections.countries)
        ref.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot results: \(error!)")
                return
            }
            let models = snapshot.documents.map { (document) -> Country in
                if let model = Country(dictionary: document.data()) {
                    return model
                } else {
                    fatalError("Unable to initialize type \(Country.self) with dictionary \(document.data())")
                }
            }
            completion(models)
        }
    }
    
    private static func createLike(liker: String, likee: String) {
        let documentData = [Like.Fields.liker: liker,
                            Like.Fields.likee: likee]
        let likeID = "\(liker),\(likee)"
        let ref = db.collection(Collections.likes).document(likeID)
        ref.setData(documentData, completion: { error in
            if let error = error {
                print("Error creating like: \(error)")
            }
        })
    }
    
    private static func deleteLike(liker: String, likee: String) {
        let likeID = "\(liker),\(likee)"
        let ref = db.collection(Collections.likes).document(likeID)
        ref.delete { (error) in
            if let error = error {
                print("Error deleting like: \(error)")
            }
        }
    }
    
    // MARK: - Listeners
    static func listenToLikes(facebookID: String, completion: @escaping ([(String, Like.Status)]) -> Void) -> [ListenerRegistration] {
        let likerQuery = db.collection(Collections.likes).whereField(Like.Fields.liker, isEqualTo: facebookID)
        let likeeQuery = db.collection(Collections.likes).whereField(Like.Fields.likee, isEqualTo: facebookID)
       
        let reg1 = likerQuery.addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching liker snapshot results: \(error!)")
                completion([])
                return
            }
            let likees = snapshot.documents.map { (document) -> String in
                if let model = Like(dictionary: document.data()) {
                    return model.likee
                } else {
                    fatalError("Unable to initialize type \(Like.self) with dictionary \(document.data())")
                }
            }
            likeeQuery.getDocuments(completion: { (snapshot, error) in
                guard let snapshot = snapshot else {
                    print("Error fetching liker snapshot results: \(error!)")
                    completion([])
                    return
                }
                let likers = snapshot.documents.map { (document) -> String in
                    if let model = Like(dictionary: document.data()) {
                        return model.liker
                    } else {
                        fatalError("Unable to initialize type \(Like.self) with dictionary \(document.data())")
                    }
                }
                let returnValues = likees.map({ (friendID) -> (String, Like.Status) in
                    return (friendID, likers.contains(friendID) ? .mutualLike : .unrequitedLike)
                })
                completion(returnValues)
            })
        }
        
        let reg2 = likeeQuery.addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching liker snapshot results: \(error!)")
                completion([])
                return
            }
            let likers = snapshot.documents.map { (document) -> String in
                if let model = Like(dictionary: document.data()) {
                    return model.liker
                } else {
                    fatalError("Unable to initialize type \(Like.self) with dictionary \(document.data())")
                }
            }
            likerQuery.getDocuments(completion: { (snapshot, error) in
                guard let snapshot = snapshot else {
                    print("Error fetching liker snapshot results: \(error!)")
                    completion([])
                    return
                }
                let likees = snapshot.documents.map { (document) -> String in
                    if let model = Like(dictionary: document.data()) {
                        return model.likee
                    } else {
                        fatalError("Unable to initialize type \(Like.self) with dictionary \(document.data())")
                    }
                }
                let returnValues = likees.map({ (friendID) -> (String, Like.Status) in
                    return (friendID, likers.contains(friendID) ? .mutualLike : .unrequitedLike)
                })
                completion(returnValues)
            })
        }
        return [reg1, reg2]
    }
    
    static func listenToUser(facebookID: String, completion: @escaping (User) -> Void) -> ListenerRegistration {
        let ref = db.collection(Collections.users).document(facebookID)
        return ref.addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot results: \(error!)")
                return
            }
            if let data = snapshot.data(), let user = User(dictionary: data) {
                completion(user)
                return
            }
            fatalError("Unable to get user.")
        }
    }
}

