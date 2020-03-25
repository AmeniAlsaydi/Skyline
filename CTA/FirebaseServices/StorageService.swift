//
//  StorageService.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/20/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation
import FirebaseStorage


class StorageService {
    
    public static let shared = StorageService() // private init required to be a singleton
    private init() {}
    
    private let storageRef = Storage.storage().reference()
    
    public func uploadPhoto(userId: String , image: UIImage, completion: @escaping (Result <URL, Error>) -> ()) {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return
        }
                
        let photoReference = storageRef.child("UserProfilePhotos/\(userId).jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg" 
        
        let _ = photoReference.putData(imageData, metadata: metadata) { (metadata, error) in
            // metadata wil have the image url from firebase
            
            if let error = error {
                completion(.failure(error))
            } else if let  _ = metadata {
                photoReference.downloadURL { (url, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url))
                    }
                }
            }
        }
        
    }
}
