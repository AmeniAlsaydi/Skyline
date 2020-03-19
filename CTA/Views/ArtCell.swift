//
//  ArtCell.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import Kingfisher

protocol ArtCellDelegate: AnyObject {
    func didFavorite(_ artCell: ArtCell, artObject: ArtObject, isFaved: Bool)
}

class ArtCell: UICollectionViewCell {
    
    weak var delegate: ArtCellDelegate?
    private var currentArtObject: ArtObject!
    
    private var isFavorite = false {
        didSet {
            if isFavorite {
                saveButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                saveButton.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }
    
    
    public lazy var artImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "photo")
        image.tintColor = .black
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 8
        
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Art Name"
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
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
        constrainSaveButton()
        constrainTitleLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        saveButton.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
        
    }
    
    private func updateFavoriteStatus() {
        
        DatabaseService.shared.isItemInFavorites(artObject: currentArtObject) { (result) in
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
        
        delegate?.didFavorite(self, artObject: currentArtObject, isFaved: isFavorite)
    }
    
    private func constrainImage() {
        addSubview(artImage)
        artImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            artImage.topAnchor.constraint(equalTo: topAnchor),
            artImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            artImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            artImage.heightAnchor.constraint(equalTo: artImage.widthAnchor)
        ])
    }
    
    
    private func constrainTitleLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: 5)
        ])
    }
    
    private func constrainSaveButton() {
        addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveButton.widthAnchor.constraint(equalToConstant: 22),
            saveButton.heightAnchor.constraint(equalToConstant: 22),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            saveButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        
    }
    
    public func configureCell(artObject: ArtObject) {
        
        currentArtObject = artObject
        updateFavoriteStatus()
        
        titleLabel.text = artObject.title
        // set image
        if artObject.hasImage {
            guard let image = artObject.webImage?.url else {
                return
            }
            let imageUrl = URL(string: image)
            artImage.kf.setImage(with: imageUrl)
        } else {
            artImage.image = UIImage(named: "noimage")
        }
        
    }
    
    public func configureCell(favoriteArt: FavoriteArt) {
        saveButton.isEnabled = false
        saveButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        titleLabel.text = favoriteArt.title
        
        if favoriteArt.imageUrl == "no imageUrl" {
            artImage.image = UIImage(named: "noimage")
        } else {
            artImage.kf.setImage(with: URL(string: favoriteArt.imageUrl))
        }
        
    }
    
}
