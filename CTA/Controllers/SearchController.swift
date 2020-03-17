//
//  SearchController.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class SearchController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var events = [Event]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private var artObjects = [ArtObject]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private var appState: AppState = .art {
        didSet {
            configureCollectionView()
            // reload collection view
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getUserExperience()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getEvents()

    }
    
    private func getEvents() {
        ApiClient.getEvents(searchQuery: "11201") { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("error getting event: \(error)")
            case .success(let events):
                self?.events = events
                print("number of events returned: \(events.count)")
            }
        }
    }
    
    private func getArt() {
        ApiClient.getArtObjects(searchQuery: "self portrait") { (result) in
            switch result {
            case .failure(let error):
                print("error getting artobjects: \(error)")
            case .success(let artObjects):
                self.artObjects = artObjects
                print("\(artObjects.count) art objects were returned")
            }
        }
    }
    
    private func configureCollectionView() {
        
        if appState == .art {
            collectionView.register(ArtCell.self, forCellWithReuseIdentifier: "artCell")
            getArt()
        } else if appState == .events {
            collectionView.register(EventCell.self, forCellWithReuseIdentifier: "eventCell")
            getEvents()
        }

        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    private func getUserExperience() {
        DatabaseService.shared.getUserExperience { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("ERROR HERE: \(error.localizedDescription)")
            case .success(let experience):
                print("user experience: \(experience)")
                if experience == "Art" {
                    self?.appState = .art
                } else if experience == "Events" {
                    self?.appState = .events
                }
            }
        }
    }
}

extension SearchController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if appState == .events {
            return events.count
        } else if appState == .art {
            return artObjects.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if appState == .events {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as? EventCell else {
                fatalError("could not down cast to event cell")
            }
            let event = events[indexPath.row]
            cell.configureCell(event: event)
            return cell
        } else if appState == .art {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "artCell", for: indexPath) as? ArtCell else {
                fatalError("could not down cast to art cell")
            }
            let artObject = artObjects[indexPath.row]
            cell.configureCell(artObject: artObject)
            return cell
        }
   
        return UICollectionViewCell()
    }
}

extension SearchController: UICollectionViewDelegateFlowLayout {
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
