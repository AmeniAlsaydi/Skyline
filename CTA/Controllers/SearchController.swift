//
//  SearchController.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class SearchController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var listener: ListenerRegistration?
    private let center = UNUserNotificationCenter.current()

    
    private var searchQuery = "" {
        didSet {
            if appState == .art {
                getArt()
            } else if appState == .events {
                getEvents()
            }
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
                DispatchQueue.main.async {
                    self.collectionView.backgroundView = EmptyView(title: "No Art Found", message: "No Art was found. Check your search and try again!")
                }
            } else {
                DispatchQueue.main.async {
                    self.collectionView.backgroundView = nil
                }
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
        super.viewDidAppear(true)
        setUpListener()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkForNotificationAuthorization()
        center.delegate = self
        
        collectionView.backgroundView = EmptyView(title: "Find Your Experience", message: "Find what you're looking for by searching above!")
       
        searchBar.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        listener?.remove()
        unregisterKeyboardNotifications()
    }
    
    private func checkForNotificationAuthorization() {
           center.getNotificationSettings { (settings) in
               if settings.authorizationStatus == .authorized {
                   print("app is authorized for notifications")
               } else {
                   self.requestNotificationPermissions()
               }
           }
       }
       
       private func requestNotificationPermissions() {
           center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
               if let error = error {
                   print("error requesting authorization: \(error)")
                   return
               }
               if granted {
                   print("access was granted")
               } else {
                   print("access denied")
               }
           }
       }
    
    private func unregisterKeyboardNotifications() {
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
       }
    
    
    private func createLocalNotification(artObject: ArtObject? = nil, event: Event? = nil) {
           
           // notifcation content:
           let content = UNMutableNotificationContent()
            if let artObject = artObject {
               content.title = "Artwork saved"
               content.subtitle = "\(artObject.title) has been saved to favorites"
            } else if let event = event {
               content.title = "Event saved"
               content.subtitle = "\(event.name) has been saved to your favorites"
           }
           content.sound = .default
           
           // trigger
           let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1 , repeats: false)
           let identifier = UUID().uuidString
           
           let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
           
           // add request to the UNNotificationCenter
           center.add(request) { (error) in
               if let error = error {
                   print("error adding notification request: \(error)")
               } else {
                   print("successfully added notification request")
               }
           }
       }
    
    private func getEvents() {
        ApiClient.getEvents(searchQuery: searchQuery) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("error getting event: \(error)")
            case .success(let search):
                guard let events = search.embedded?.events else {
                    self?.events = [Event]()
                    return
                }
                self?.events = events
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
            }
        }
    }
    
    private func configureCollectionView() {
        
        if appState == .art {
            navigationItem.title = "Find Art work"
            collectionView.register(ArtCell.self, forCellWithReuseIdentifier: "artCell")
        } else if appState == .events {
            navigationItem.title = "Find Events"
            collectionView.register(EventCell.self, forCellWithReuseIdentifier: "eventCell")
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
            cell.delegate = self
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // EventDetailViewController
        if appState == .events {
            let event = events[indexPath.row]
            let detailVC = EventDetailViewController(event)
            navigationController?.pushViewController(detailVC, animated: true)
            
        } else if appState == .art {
            let artObject = artObjects[indexPath.row]
            let detailVC = ArtDetailViewController(artObject)
            navigationController?.pushViewController(detailVC, animated: true)
            
        }
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
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
    
    func didFavorite(_ eventCell: EventCell, event: Event, isFaved: Bool) {
        
        if isFaved {
            // IF FAVED DELETE EVENT
            
            DatabaseService.shared.removeFromFavorites(event: event) { (result) in
                switch result {
                case .failure(let error):
                    print("error un-saving event: \(error.localizedDescription)")
                case .success:
                    print("success! \(event.name) was removed from favs.")
                }
            }
            
        } else {
            
            DatabaseService.shared.addToEventFavorites(event: event) { (result) in
                switch result {
                case .failure(let error):
                    print("error saving event: \(error.localizedDescription)")
                case .success:
                    self.createLocalNotification(event: event)
                }
            }
        }
    }
}

extension SearchController: ArtCellDelegate {
    
    func didFavorite(_ artCell: ArtCell, artObject: ArtObject, isFaved: Bool) {
        if isFaved {
            // IF FAVED DELETE OBJECT
            DatabaseService.shared.removeFromFavorites(artObject: artObject) { (result) in
                switch result {
                case .failure(let error):
                    print("error un-saving art object: \(error.localizedDescription)")
                case .success:
                    print("success! \(artObject.title) was removed from favs.") 
                }
            }
            
        } else {
            // IF NOT FAVED ADD OBJECT TO FAVS
            
            DatabaseService.shared.addToArtFavorites(artObject: artObject) { (result) in
                switch result {
                case .failure(let error):
                    print("error saving art object: \(error.localizedDescription)")
                case .success:
                    self.createLocalNotification(artObject: artObject)
                    print("success! \(artObject.title ) was saved.")
                }
            }
        }
    }
}


extension SearchController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}
