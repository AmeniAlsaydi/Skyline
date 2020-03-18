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
        label.font = UIFont (name: "Georgia", size: 20)
        label.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private lazy var msgLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 14)
        label.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
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
        setupMsgConstaints()
        setUptitleConstraints()
        
    }
    
    private func setupMsgConstaints() {
        addSubview(msgLabel)
        msgLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            msgLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            msgLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            msgLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            msgLabel.trailingAnchor.constraint(equalTo: leadingAnchor, constant: -8)
        ])
    }
    
    private func setUptitleConstraints() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: msgLabel.topAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
            
        ])
    }
    

}
