//
//  OptionCell.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/15/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class OptionCell: UICollectionViewCell {
    
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var selectionButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blackView.layer.cornerRadius = 10
    }
    
}
