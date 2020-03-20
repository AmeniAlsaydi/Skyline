//
//  EventDetailViewController.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/20/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    private let detailView = DetailView()
    private var event: Event
    
    private var eventDetail: Event? {
        didSet {
            DispatchQueue.main.async {
                self.updateDetailUI()
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
        print(event.id)
        view.backgroundColor = .white
        
        configureNavBar()
        updateUI()
        getEventDetail() 

        // Do any additional setup after loading the view.
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(favoriteButtonPressed(sender:)))
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationItem.backBarButtonItem?.tintColor = .black // no working
    }
    
    @objc func favoriteButtonPressed(sender: UIBarButtonItem) {
        //  FIX THIS: favoriting logic here please
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star.fill")
        
    }

   private func getEventDetail() {
        ApiClient.getEventDetail(eventId: "k7v1Fpd4yZoOp") { (result) in
            switch result {
            case .failure(let appError):
                print("error getting event details: \(appError)")
            case .success(let event):
                self.eventDetail = event
            }
        }
    }
    
    private func updateUI() {
        
        detailView.mainImage.kf.setImage(with: URL(string: event.images[0].url))
        detailView.backgroundImage.kf.setImage(with: URL(string: event.images[0].url))
        
        detailView.largeLabel.text = event.name
        // FIX THIS- format date
        detailView.smallLabel1.text = "DATE: \(event.dates.start.dateTime)"
        detailView.icon.image = UIImage(systemName: "calendar")
        
        detailView.smallLabel3.textColor = #colorLiteral(red: 0, green: 0.5209486485, blue: 1, alpha: 1)
        detailView.smallLabel3.isUserInteractionEnabled = true
        detailView.smallLabel3.text = event.url
        
        // add gesture
        // safari services
    }
    
    private func updateDetailUI() {
        
        guard let eventDetail = eventDetail else {
            print("could not unwrap event detail")
            return
        }
        let priceRange = "\(eventDetail.priceRanges?[0].min ?? 2)" // Fix this
        detailView.smallLabel2.text = priceRange
        
    }

}
