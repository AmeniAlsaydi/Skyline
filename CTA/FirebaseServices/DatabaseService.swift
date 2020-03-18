//
//  DatabaseService.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DatabaseService {
    static let shared = DatabaseService()
    
    static let userCollection = "users"
    static let favoritesEventsCollection = "favoriteEvents"
    static let favoritesArtsCollection = "favoriteArts"
    
    private let db = Firestore.firestore()
    
    public func createDatabaseUser(authDataResult: AuthDataResult, experience: String, completion: @escaping (Result<Bool, Error>)-> ()) {
           
           guard let email = authDataResult.user.email else {
               return
           }
        db.collection(DatabaseService.userCollection).document(authDataResult.user.uid).setData(["email": email, "createdDate": Timestamp(date: Date()), "userid": authDataResult.user.uid, "experience": experience]) { error in
               
               if let error = error {
                   completion(.failure(error))
               } else {
                   completion(.success(true))
               }
               
           }
       }
    // this should be moved to a UserSession class - have a listener instead of get doc
    // which is a singleton - FIX THIS!
    public func getUserExperience(completion: @escaping (Result<String, Error>)-> ()) {
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        db.collection(DatabaseService.userCollection).document(user.uid).getDocument { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                guard let dictData = snapshot.data() else {
                    return
                }
                let user = User(dictData)
                completion(.success(user.experience))
            }
        }
        
    }
    
    public func addToArtFavorites(event: Event, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user =  Auth.auth().currentUser else { return}
        // , "imageUrl": event.images.first?.url - FIX THIS event image url might be nil
        db.collection(DatabaseService.userCollection).document(user.uid).collection(DatabaseService.favoritesEventsCollection).document(event.id).setData(["name": event.name, "type": event.type, "favoritedDate": Timestamp(date: Date()), "id": event.id]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    
}
