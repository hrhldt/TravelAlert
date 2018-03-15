////
////  Database.swift
////  DTT
////
////  Created by Troels Michael Trebbien on 15/03/2018.
////  Copyright © 2018 Martin Herholdt Rasmussen. All rights reserved.
////
//
//import Foundation
//import Firebase
//
//struct Database {
//    
//    private var db: Firestore {
//        return Firestore.firestore()
//    }
//    
//    private enum Key {
//        enum Collection {
//            static let countries = "Countries"
//            static let users = "Users"
//        }
//        enum Field {
//            static let name = "name"
//            static let facebookID = "facebookID"
//            static let firebaseID = "firebaseID"
//        }
//    }
//
//    func createUser(name: String, facebookID: String, firebaseID: String) -> DocumentReference? {
//        let documentData = [Key.Field.name: name,
//                            Key.Field.facebookID: facebookID,
//                            Key.Field.firebaseID: firebaseID]
//        
//        var ref: DocumentReference? = nil
//        ref = db.collection(Key.Collection.users).addDocument(data: documentData) { error in
//            if let error = error {
//                print("Error adding user: \(error)")
//            } else {
//                print("Added user with ID: \(ref!.documentID)")
//            }
//        }
//        return ref
//    }
//
//}

