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
    
    private var searchQuery = "" {
        didSet {
            getUserExperience()
        }
    }
    
    private var events = [Event]() {
        didSet {
             DispatchQueue.main.async {
                if self.events.isEmpty {
                    self.collectionView.backgroundView = EmptyView(title: "No Events", message: "No Events were found in that location. Check your search and try again!")
            } else {
                    self.collectionView.backgroundView = nil
            }
                self.collectionView.reloadData()
            }
        }
    }
    
    private var artObjects = [ArtObject]() {
        didSet {
            if artObjects.isEmpty {
                collectionView.backgroundView = EmptyView(title: "No Art Found", message: "Shrug")
            } else {
                collectionView.backgroundView = nil
            }
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
        //getUserExperience()
        collectionView.backgroundView = EmptyView(title: "Find Your Experience", message: "Find what you're looking for by searching above!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        

    }
    
    private func getEvents() {
        ApiClient.getEvents(searchQuery: searchQuery) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("error getting event: \(error)")
            case .success(let search):
                guard let events = search.embedded?.events else {
                    print("no events returned")
                    self?.events = [Event]()
                    return
                }
                self?.events = events
                print("number of events returned: \(events.count)")
            }
        }
    }
    
    private func getArt() {
        ApiClient.getArtObjects(searchQuery: searchQuery) { (result) in
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
            cell.delegate = self
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


extension SearchController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            print("search text issue")
            return
        }
        
        searchQuery = searchText
    }
}

extension SearchController: EventCellDelegate {
    func didFavorite(_ eventCell: EventCell, event: Event) {
        print("\(event.name) fav button was pressed!")
        
        DatabaseService.shared.addToArtFavorites(event: event) { (result) in
            switch result {
            case .failure(let error):
                print("error saving event: \(error.localizedDescription)")
            case .success:
                print("success! \(event.name) was saved. ")
            }
        }
    }
    
    
}
