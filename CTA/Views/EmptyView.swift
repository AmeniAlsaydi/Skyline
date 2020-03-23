//
//  EmptyView.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/17/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class EmptyView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont (name: "Times New Roman", size: 25) // Georgia-Bold
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private lazy var msgLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    
    init(title: String, message: String) { 
        super.init(frame: UIScreen.main.bounds)
        titleLabel.text = title
        msgLabel.text = message
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setUptitleConstraints()
        setupMsgConstaints()

    }

    
    private func setUptitleConstraints() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
            
        ])
    }
    
    private func setupMsgConstaints() {
        addSubview(msgLabel)
        msgLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            msgLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            msgLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            msgLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    

}
