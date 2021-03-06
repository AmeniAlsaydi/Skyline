//
//  EventDetailViewController.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/20/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import SafariServices

class EventDetailViewController: UIViewController {
    
    private let detailView = DetailView()
    private var event: Event
    
    private var eventDetail: Event?
    
    private var isFavorite = false {
        didSet {
            if isFavorite {
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star.fill")
            } else {
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star")
            }
        }
    }
    
    init(_ event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = detailView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        updateFavoriteStatus()
        configureNavBar()
        updateUI()
        getEventDetail()
        detailView.button.setTitle("Buy Tickets", for: .normal)
        detailView.button.addTarget(self, action: #selector(websitePressed(_:)), for: .touchUpInside)
 
    }
    
    
    @objc private func websitePressed(_ sender: UIButton) {
        
        if let urlString = URL(string: event.url) {
            let safariVC = SFSafariViewController(url: urlString)
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    private func updateFavoriteStatus() {
        
        DatabaseService.shared.isItemInFavorites(event: event) { (result) in
            switch result {
            case .failure(let error):
                print("error checking if faved: \(error.localizedDescription)")
            case .success(let isfav):
                if isfav {
                    self.isFavorite = true
                } else {
                    self.isFavorite = false
                }
            }
        }
    }
    
    
    private func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(favoriteButtonPressed(sender:)))
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationItem.backBarButtonItem?.tintColor = .black // no working
    }

    
    @objc func favoriteButtonPressed(sender: UIBarButtonItem) {
        
        if isFavorite {
            // remove from favs
            isFavorite = false
            DatabaseService.shared.removeFromFavorites(event: event) { (result) in
                switch result {
                case .failure(let error):
                    print("error un-saving event: \(error.localizedDescription)")
                case .success:
                    print("success! \(self.event.name) was removed from favs.")
                }
            }
            
        } else {
            // add to favs
            isFavorite = true
            
            DatabaseService.shared.addToEventFavorites(event: event) { (result) in
                switch result {
                case .failure(let error):
                    print("error saving event: \(error.localizedDescription)")
                case .success:
                    print("success! \(self.event.name) was saved to favs.")
                }
            }
        }
    }

   private func getEventDetail() {
    ApiClient.getEventDetail(eventId: event.id) { (result) in
            switch result {
            case .failure(let appError):
                print("error getting event details: \(appError)")
            case .success(let event):
                self.eventDetail = event
                DispatchQueue.main.async {
                    self.updateDetailUI()
                }
            }
        }
    }
    
    private func updateUI() {
        
        detailView.mainImage.kf.setImage(with: URL(string: event.images[0].url))
        detailView.backgroundImage.kf.setImage(with: URL(string: event.images[0].url))
        
        detailView.largeLabel.text = event.name
        let date = event.dates.start.dateTime?.convertToDate()
        detailView.smallLabel1.text = "DATE: \(date?.convertToString() ?? "Not Available")"
        detailView.icon.image = UIImage(systemName: "calendar")
    }
    
    private func updateDetailUI() {
        
        guard let eventDetail = eventDetail else {
            print("could not unwrap event detail")
            return
        }
        let min = eventDetail.priceRanges?[0].min ?? 2
        let max = eventDetail.priceRanges?[0].max ?? 2
        let currency = eventDetail.priceRanges?[0].currency ?? ""
        let priceRange = "$\(min) - $\(max) \(currency)"
        
        detailView.smallLabel2.text = "Price Range: \(priceRange)"
        
        guard let embeddedEventInfo = eventDetail.embedded, let venue = embeddedEventInfo.venues.first else {
            print("issue getting venue info")
            return
        }
        
        let address = "\(venue.address.line1) \(venue.city.name) \(venue.state.stateCode) \(venue.postalCode)"
        detailView.smallLabel3.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        detailView.smallLabel3.text = "Venue: \(address)"
        
    }

}
