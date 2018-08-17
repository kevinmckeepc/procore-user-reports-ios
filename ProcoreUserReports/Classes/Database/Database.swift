//
//  Database.swift
//  ProcoreUserReports
//
//  Created by Kevin McKee on 8/16/18.
//  Copyright © 2018 Procore. All rights reserved.
//

import Firebase

struct Database {
    
    // Prepares the Firebase Database
    static func prepare() {
        FirebaseApp.configure()
    }
    
    // Listens for reports being added to the Database
    static func listen<D: JSONDocument>(_ completion: @escaping (D?, JSONDocumentChangeType?, Error?) -> Void) {
     
        let db = Firestore.firestore()
        let docCollection = db.collection(D.collection())
        docCollection.addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot, !snapshot.documents.isEmpty, error == nil else {
                return completion(nil, nil, error)
            }
            
            for change in snapshot.documentChanges {
                print("💥")
                var jsonDoc = try? D(json: change.document.data())
                jsonDoc?.documentID = change.document.documentID
                switch change.type {
                case .added:
                    completion(jsonDoc, .added, nil)
                    break
                case .removed:
                    completion(jsonDoc, .removed, nil)
                    break
                case .modified:
                    completion(jsonDoc, .modified, nil)
                    break
                }
            }
        }
    }
    
    // Generates a sample report and saves it to Firebase
    static func sendSampleReport() {
        guard let path = Bundle.main.path(forResource: "telemetry-report", ofType: "json") else {
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            
            guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSON else {
                return
            }
            
            let db = Firestore.firestore()
            let docCollection = db.collection(UserReport.collection())
            
            docCollection.addDocument(data: json)
        } catch {
            print(error)
        }
        
    }
}
