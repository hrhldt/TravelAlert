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
    }

    static func createUser(name: String, facebookID: String, firebaseID: String) -> DocumentReference {
        let documentData = [User.Fields.name: name,
                            User.Fields.facebookID: facebookID,
                            User.Fields.firebaseID: firebaseID]
        let ref = db.collection(Collections.users).document(facebookID)
        ref.setData(documentData, completion: { error in
            if let error = error {
                print("Error setting user data: \(error)")
            }
        })
        return ref
    }
    
    static func getMe(facebookID: String, completion: @escaping (User) -> Void) {
        let ref = db.collection(Collections.users).document(facebookID)
        ref.addSnapshotListener { (snapshot, error) in
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

    static func countryList(completion: @escaping ([Country]) -> Void) {
        let collectionRef = db.collection(Collections.countries)
        collectionRef.addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot results: \(error!)")
                return
            }
            let models = snapshot.documents.map { (document) -> Country in
                if let model = Country(dictionary: document.data()) {
                    return model
                } else {
                    // Don't use fatalError here in a real app.
                    fatalError("Unable to initialize type \(Country.self) with dictionary \(document.data())")
                }
            }
            
            completion(models)
        }
    }
    
    static func getUser(withFacebookID facebookID: String) -> DocumentReference {
        return db.collection(Collections.users).document(facebookID)
    }
}

