//
//  FavoritesController.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class FavoritesController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var listener: ListenerRegistration?
    
    private var refreshControl: UIRefreshControl!

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
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private var favoriteArts = [FavoriteArt]()  {
           didSet {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
           }
       }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpListener()
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // getFavoriteArts()
        // getFavoriteEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(true)
           listener?.remove()
        
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
    
    private func setUpListener() {
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        listener = Firestore.firestore().collection(DatabaseService.userCollection).document(user.uid).addSnapshotListener({ [weak self] (snapshot, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Try again later", message: "\(error.localizedDescription)")
                }
            } else if let snapshot = snapshot {
                snapshot.data()
                guard let dictData = snapshot.data() else {
                    return
                }
                let user = User(dictData)
                if user.experience == "Art" {
                    self?.appState = .art
                } else if user.experience == "Events" {
                    self?.appState = .events
                }
            }
        })
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
    
    
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
             return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
         }
}
