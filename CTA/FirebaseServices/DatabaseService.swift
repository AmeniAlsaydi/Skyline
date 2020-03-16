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
    
}
