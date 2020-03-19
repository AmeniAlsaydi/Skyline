//
//  FavoritesController.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class FavoritesController: UIViewController {
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        getFavoriteEvents()
        getFavoriteArts()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    private func getFavoriteEvents() {
        DatabaseService.shared.getFavoriteEvents { [weak self] (results) in
            switch results {
            case .failure(let error):
                print("error getting faved events: \(error.localizedDescription)")
            case .success(let favorites):
                print("\(favorites.count) events saved")
                //self?.favoriteEvents = favorites
            }
        }
    }
    
    private func getFavoriteArts() {
        DatabaseService.shared.getFavoriteArts { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("error getting faved events: \(error.localizedDescription)")
            case .success(let favorites):
                print("\(favorites.count) arts saved")
                //self?.favoriteArts = favorites
            }
        }
    }
    
}
