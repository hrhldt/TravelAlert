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
    
    private enum Key {
        enum Collection {
            static let countries = "Countries"
            static let users = "Users"
        }
        enum Field {
            static let name = "name"
            static let facebookID = "facebookID"
            static let firebaseID = "firebaseID"
            static let code = "code"
        }
    }

    static func createUser(name: String, facebookID: String, firebaseID: String) -> DocumentReference {
        let documentData = [Key.Field.name: name,
                            Key.Field.facebookID: facebookID,
                            Key.Field.firebaseID: firebaseID]
        let ref = db.collection(Key.Collection.users).document(facebookID)
        ref.setData(documentData, completion: { error in
            if let error = error {
                print("Error setting user data: \(error)")
            }
        })
        return ref
    }

    static func countryList(completion: (([Country])->(Void))?) {
        let collectionRef = db.collection(Key.Collection.countries)
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
            
            completion?(models)
        }
    }
    
    func getUser(withFacebookID facebookID: String) -> DocumentReference {
        return db.collection(Key.Collection.users).document(facebookID)
    }
}

