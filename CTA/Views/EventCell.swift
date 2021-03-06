//
//  EventCell.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import Kingfisher

protocol EventCellDelegate: AnyObject {
    func didFavorite(_ eventCell: EventCell, event: Event, isFaved: Bool)
}

class EventCell: UICollectionViewCell {
    
    weak var delegate: EventCellDelegate?
    private var currentEvent: Event!
    
    private var isFavorite: Bool! {
        didSet {
            if isFavorite {
                saveButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                saveButton.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }
    
    public lazy var eventImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "photo")
        image.tintColor = .black
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 8
        
        return image
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.bold)
        label.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        return label
    }()
    
    private lazy var eventNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Event Name"
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        label.numberOfLines = 2
        return label
    }()
    
    public lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return button
    }()
    
    public lazy var shareButton: UIButton = {
           let button = UIButton()
           button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
           button.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
           return button
       }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        constrainImage()
        constrainDate()
        constrainNameLabel()
        constrainSaveButton()
        constrainShareButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        saveButton.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func updateFavoriteStatus() {
        
        DatabaseService.shared.isItemInFavorites(event: currentEvent) { (result) in
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
    
    @objc private func saveButtonPressed(_ sender: UIButton) {
        
        if isFavorite {
            saveButton.setImage(UIImage(systemName: "star"), for: .normal)
            
        } else {
            saveButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            
        }

        delegate?.didFavorite(self, event: currentEvent, isFaved: isFavorite)
        isFavorite = !isFavorite
    }
    
    
    private func constrainImage() {
        addSubview(eventImage)
        eventImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            eventImage.topAnchor.constraint(equalTo: topAnchor),
            eventImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            eventImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            eventImage.widthAnchor.constraint(equalTo: eventImage.heightAnchor)
        ])
        
    }
    
    private func constrainDate() {
        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: eventImage.trailingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
    }
    
    
    
    private func constrainNameLabel() {
        
        addSubview(eventNameLabel)
        eventNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            eventNameLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            eventNameLabel.leadingAnchor.constraint(equalTo: eventImage.trailingAnchor, constant: 8),
            eventNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        
        ])
    }
    
    private func constrainSaveButton() {
    
          addSubview(saveButton)
          saveButton.translatesAutoresizingMaskIntoConstraints = false
          
          NSLayoutConstraint.activate([
              saveButton.widthAnchor.constraint(equalToConstant: 22),
              saveButton.heightAnchor.constraint(equalToConstant: 22),
              saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
              saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
          ])
          
      }
    
    private func constrainShareButton() {
    
          addSubview(shareButton)
          shareButton.translatesAutoresizingMaskIntoConstraints = false
          
          NSLayoutConstraint.activate([
              shareButton.widthAnchor.constraint(equalToConstant: 22),
              shareButton.heightAnchor.constraint(equalToConstant: 22),
              shareButton.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -8),
              shareButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
          ])
          
      }
    
    public func configureCell(event: Event) {
        
        currentEvent = event
        updateFavoriteStatus()
        
        eventNameLabel.text = event.name
        let date = event.dates.start.dateTime?.convertToDate()
        dateLabel.text = date?.convertToString()
        guard let imageUrl = event.images.first?.url else {
            print("no url")
            return
        }
        eventImage.kf.setImage(with: URL(string: imageUrl))
        
        
    }
    
    public func configureCell(favoriteEvent: FavoriteEvent) {
        
        let dateinfo = DateInfo(start: StartInfo(dateTime: nil))
        let event = Event(name: favoriteEvent.name, type: "event", id: favoriteEvent.id, url: "", images: [], dates: dateinfo, priceRanges: nil, embedded: nil)
        
        currentEvent = event
        
        isFavorite = true
        eventNameLabel.text = favoriteEvent.name
        dateLabel.text = favoriteEvent.eventDate.dateValue().convertToString()
        if favoriteEvent.imageUrl == "no imageUrl" {
            eventImage.image = UIImage(named: "noimage")
        } else {
            eventImage.kf.setImage(with: URL(string: favoriteEvent.imageUrl))
        }
        
    }
}
