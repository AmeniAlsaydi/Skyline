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
    
    public func addToEventFavorites(event: Event, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user =  Auth.auth().currentUser else { return}
        
        // REMEMBER : image can be nil and if it is, you're sending and empty string 
        db.collection(DatabaseService.userCollection).document(user.uid).collection(DatabaseService.favoritesEventsCollection).document(event.id).setData(["name": event.name, "type": event.type, "favoritedDate": Timestamp(date: Date()), "id": event.id, "imageUrl": event.images.first?.url ?? ""]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    
    public func addToArtFavorites(artObject: ArtObject, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user =  Auth.auth().currentUser else { return}
        
        // REMEMBER : also image can be nil and if it is, you're sending and empty string
        db.collection(DatabaseService.userCollection).document(user.uid).collection(DatabaseService.favoritesArtsCollection).document(artObject.id).setData(["title": artObject.title, "id": artObject.id, "imageUrl": artObject.webImage?.url ?? ""]){ (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
        
    }
    
    public func isItemInFavorites(artObject: ArtObject? = nil, event: Event? = nil, completion: @escaping (Result<Bool, Error>) -> ()) {
        
        guard let user = Auth.auth().currentUser else { return}
        
        var favoriteCollection: String!
        var favoriteId: String!
        
        if let artObject = artObject {
            favoriteCollection = DatabaseService.favoritesArtsCollection
            favoriteId = artObject.id
        } else if let event = event {
            favoriteCollection = DatabaseService.favoritesEventsCollection
            favoriteId = event.id
        }
        
        db.collection(DatabaseService.userCollection).document(user.uid).collection(favoriteCollection).whereField("id", isEqualTo: favoriteId!).getDocuments { (snapshot, error) in
            // whats behind the word snapshot -- firebase uses the word snap shot to represent the current state of the data
            
            if let error = error {
                completion(.failure(error))
                
            } else if let snapshot = snapshot {
                if snapshot.documents.count > 0 {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            }
        }
    }
    
    
    public func removeFromFavorites(artObject: ArtObject? = nil, event: Event? = nil, completion: @escaping (Result<Bool, Error>) -> ()) {
        
        guard let user = Auth.auth().currentUser else { return}
        
        var favoriteCollection: String!
        var favoriteId: String!
        
        if let artObject = artObject {
            favoriteCollection = DatabaseService.favoritesArtsCollection
            favoriteId = artObject.id
        } else if let event = event {
            favoriteCollection = DatabaseService.favoritesEventsCollection
            favoriteId = event.id
        }
        
        db.collection(DatabaseService.userCollection).document(user.uid).collection(favoriteCollection).document(favoriteId).delete { (error) in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    // FIX THIS - can this be made generic????
    // get fav events
    
    public func getFavoriteEvents(completion: @escaping (Result<[FavoriteEvent], Error>) -> ()) {
        
        guard let user = Auth.auth().currentUser else { return}
        db.collection(DatabaseService.userCollection).document(user.uid).collection(DatabaseService.favoritesEventsCollection).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let favorites = snapshot.documents.map { FavoriteEvent($0.data())}
                completion(.success(favorites))
            }
        }
        
    }
    
    // get fav art
    
    public func getFavoriteArts(completion: @escaping (Result<[FavoriteArt], Error>) -> ()) {
        
        guard let user = Auth.auth().currentUser else { return}
        db.collection(DatabaseService.userCollection).document(user.uid).collection(DatabaseService.favoritesArtsCollection).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let favorites = snapshot.documents.map { FavoriteArt($0.data())}
                completion(.success(favorites))
            }
        }
        
    }
}
