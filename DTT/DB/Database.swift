//
//  Database.swift
//  DTT
//
//  Created by Troels Michael Trebbien on 15/03/2018.
//  Copyright © 2018 Martin Herholdt Rasmussen. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Database {
    
    private static var db: Firestore {
        return Firestore.firestore()
    }
    
    private enum Collections {
        static let countries = "Countries"
        static let users = "Users"
        static let likes = "Likes"
    }

    // MARK: - CRUD
    static func createUser(name: String, facebookID: String, firebaseID: String) {
        let documentData = [User.Fields.name: name,
                            User.Fields.facebookID: facebookID,
                            User.Fields.firebaseID: firebaseID]
        let ref = db.collection(Collections.users).document(facebookID)
        ref.setData(documentData, completion: { error in
            if let error = error {
                print("Error creating user: \(error)")
            }
        })
    }
    
    private static func createLike(liker: String, likee: String) {
        let documentData = [Like.Fields.liker: liker,
                            Like.Fields.likee: likee]
        let documentID = "\(liker),\(likee)"
        let ref = db.collection(Collections.likes).document(documentID)
        ref.setData(documentData, completion: { error in
            if let error = error {
                print("Error creating like: \(error)")
            }
        })
    }
    
    private static func deleteLike(liker: String, likee: String) {
        let documentID = "\(liker),\(likee)"
        let ref = db.collection(Collections.likes).document(documentID)
        ref.delete { (error) in
            if let error = error {
                print("Error deleting like: \(error)")
            }
        }
    }
    
    
    static func toggleLike(liker: String, likee: String) {
        let documentID = "\(liker),\(likee)"
        let ref = db.collection(Collections.likes).document(documentID)
        ref.getDocument { (snapshot, error) in
            guard error == nil else { return }
            if snapshot?.data() == nil {
                createLike(liker: liker, likee: likee)
            } else {
                deleteLike(liker: liker, likee: likee)
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
    
    // MARK: - Listeners
    static func getMatches(facebookID: String, completion: @escaping ([String]) -> Void) -> [ListenerRegistration] {
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
                completion(likers.filter({ likees.contains($0) }))
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
                completion(likers.filter({ likees.contains($0) }))
            })
        }
        return [reg1, reg2]
    }
    
    static func getMe(facebookID: String, completion: @escaping (User) -> Void) -> ListenerRegistration {
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

