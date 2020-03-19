//
//  DetailView.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/19/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class DetailView: UIView {
    
    public lazy var scrollView: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.backgroundColor = .clear
        return scrollview
    }()
    
    public lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    public lazy var backgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "noimage")
        iv.clipsToBounds = true
        iv.alpha = 1
        return iv
    }()
    
    
    public lazy var blur: UIVisualEffectView = {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.extraLight))
        return blur
    }()
    
    public lazy var mainImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "noimage")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    public lazy var largeLabel: UILabel = {
        let label = UILabel()
        label.text = "Large Label"
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 35)
        return label
    }()
    
    public lazy var icon: UIImageView = { // can be a clock or calender
        let iv = UIImageView()
        iv.image = UIImage(systemName: "mic")
        iv.tintColor = .black
        return iv
    }()
    
    public lazy var smallLabel1: UILabel = { // eventTime or date created date
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .light)
        label.text = "Small Label"
        return label
    }()
    
    public lazy var smallLabel2: UILabel = { // description or price range
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .light)
        label.text = "Small Label"
        return label
    }()
    
    public lazy var smallLabel3: UILabel = { // link to event place produced
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .light)
        label.text = "Small Label"
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
        scrollViewContraints()
        contentViewContraints()
        backgroundImageContraints()
        blurContraints()
        ImageContraints()
        largeLabelConstraints()
        iconConstraints()
        addressConstraints()
        
    }
    
    private func scrollViewContraints() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let width = self.bounds.width
        let height = self.bounds.height

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.widthAnchor.constraint(equalToConstant: width),
            scrollView.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    private func contentViewContraints() {
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    private func backgroundImageContraints() {
        
        contentView.addSubview(backgroundImage)
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        backgroundImage.topAnchor.constraint(equalTo: scrollView.topAnchor),
        backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
        backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
        backgroundImage.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    
    private func blurContraints() {
        
        backgroundImage.addSubview(blur)
        blur.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
        blur.topAnchor.constraint(equalTo: backgroundImage.topAnchor),
        blur.leadingAnchor.constraint(equalTo: backgroundImage.leadingAnchor),
        blur.trailingAnchor.constraint(equalTo: backgroundImage.trailingAnchor),
        blur.heightAnchor.constraint(equalTo: backgroundImage.heightAnchor)
        ])
    }
    
    private func ImageContraints() {
        contentView.addSubview(mainImage)
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        mainImage.topAnchor.constraint(equalTo: backgroundImage.centerYAnchor, constant: -70),
        mainImage.centerXAnchor.constraint(equalTo: centerXAnchor),
        mainImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.90),
        mainImage.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func largeLabelConstraints() {
        contentView.addSubview(largeLabel)
        largeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            largeLabel.topAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: 20),
            largeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            largeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)

        ])
    }
    
    private func iconConstraints() {
        contentView.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        
          NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: largeLabel.bottomAnchor, constant: 10),
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            icon.widthAnchor.constraint(equalToConstant: 20),
            icon.heightAnchor.constraint(equalTo: icon.widthAnchor)
          
          ])
    }
    
    private func addressConstraints() {
           contentView.addSubview(smallLabel1)
           smallLabel1.translatesAutoresizingMaskIntoConstraints = false
           
           NSLayoutConstraint.activate([
               smallLabel1.topAnchor.constraint(equalTo: icon.topAnchor),
               smallLabel1.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
               smallLabel1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
           ])
       }
    
}
