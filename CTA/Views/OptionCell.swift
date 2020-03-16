//
//  OptionCell.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/15/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

protocol OptionCellDelegate: AnyObject {
    func didSelectExperience(_ optionCell: OptionCell, experience: String)
}

class OptionCell: UICollectionViewCell {
    
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var selectionButton: UIButton!
    
    weak var delegate: OptionCellDelegate?
    
    override var isSelected: Bool{
        willSet{
            super.isSelected = newValue
            if newValue
            {
                self.selectionButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            }
            else
            {
                self.selectionButton.setImage(UIImage(systemName: "circle"), for: .normal)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blackView.layer.cornerRadius = 10
    }
    
    @IBAction func optionSelected(_ sender: UIButton) {
        delegate?.didSelectExperience(self, experience: optionLabel.text ?? "Art")
    }
}
