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

    static func createUser(name: String, facebookID: String, firebaseID: String) -> DocumentReference? {
        let documentData = [Key.Field.name: name,
                            Key.Field.facebookID: facebookID,
                            Key.Field.firebaseID: firebaseID]
        
        var ref: DocumentReference? = nil
        ref = db.collection(Key.Collection.users).addDocument(data: documentData) { error in
            if let error = error {
                print("Error adding user: \(error)")
            } else {
                print("Added user with ID: \(ref!.documentID)")
            }
        }
        return ref
    }

    static func countryList(snapshotBlock: @escaping FIRQuerySnapshotBlock) {
        let collectionRef = db.collection(Key.Collection.countries)
        collectionRef.getDocuments(completion: snapshotBlock)
    }
    
}
