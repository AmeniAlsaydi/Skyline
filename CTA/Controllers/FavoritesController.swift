//
//  FavoritesController.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class FavoritesController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var appState: AppState = .events {
        didSet {
            configureCollectionView()
            // reload collection view
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private var favoriteEvents = [FavoriteEvent]() {
        didSet{
             self.collectionView.reloadData()
        }
    }
    
    private var favoriteArts = [FavoriteArt]()  {
           didSet{
                self.collectionView.reloadData()
           }
       }
    
    override func viewDidAppear(_ animated: Bool) {
        getFavoriteEvents()
        getFavoriteArts()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserExperience()
    }
    
    private func configureCollectionView() {
        
        // register cells
        
        if appState == .art {
            collectionView.register(ArtCell.self, forCellWithReuseIdentifier: "artCell")
            getFavoriteArts()
        } else if appState == .events {
            collectionView.register(EventCell.self, forCellWithReuseIdentifier: "eventCell")
            getFavoriteEvents()
        }
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func getUserExperience() {
           DatabaseService.shared.getUser { [weak self] (result) in
               switch result {
               case .failure(let error):
                   print("ERROR HERE: \(error.localizedDescription)")
               case .success(let user):
                print("user experience: \(user.experience)")
                if user.experience == "Art" {
                       self?.appState = .art
                } else if user.experience == "Events" {
                       self?.appState = .events
                   }
               }
           }
       }
    
    private func getFavoriteEvents() {
        DatabaseService.shared.getFavoriteEvents { [weak self] (results) in
            switch results {
            case .failure(let error):
                print("error getting faved events: \(error.localizedDescription)")
            case .success(let favorites):
                print("\(favorites.count) events saved")
                self?.favoriteEvents = favorites
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
                self?.favoriteArts = favorites
            }
        }
    }
    
}

extension FavoritesController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if appState == .events {
            return favoriteEvents.count
        } else if appState == .art {
            return favoriteArts.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if appState == .events {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as? EventCell else {
                fatalError("could not down cast to event cell")
            }
            let event = favoriteEvents[indexPath.row]
            cell.configureCell(favoriteEvent: event)
            //cell.delegate = self
            return cell
        } else if appState == .art {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "artCell", for: indexPath) as? ArtCell else {
                fatalError("could not down cast to art cell")
            }
            let artObject = favoriteArts[indexPath.row]
            cell.configureCell(favoriteArt: artObject)
            //cell.delegate = self
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension FavoritesController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let maxSize = UIScreen.main.bounds
        
        var height: CGFloat!
        var width: CGFloat!
        
        if appState == .art {
            height = maxSize.height * 0.25
            width = maxSize.width * 0.45
        } else if appState == .events {
            height = maxSize.height * 0.11
            width = maxSize.width
        }
        
        return CGSize(width: width, height: height)
    }
}
