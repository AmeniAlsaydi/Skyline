//
//  ArtCell.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class ArtCell: UICollectionViewCell {
    
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
        constrainTitleLabel()
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
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8)
        ])
    }
    
}
