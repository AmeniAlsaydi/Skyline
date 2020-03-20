//
//  EditProfileViewController.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/20/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    
    //private var user: User
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        saveButton.layer.cornerRadius = 10
        saveButton.layer.borderWidth = 1.0
        saveButton.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
       // save profile changes

        updateExperience()
            }
    
    private func updateExperience() {
        DatabaseService.shared.updateExperience(experience: "Events") { (result) in
            switch result {
            case .failure(let error):
                print("error updating experience: \(error.localizedDescription)")
            case .success:
                print("success updating experience - confirm on firbase console")
                
            }
        }
    }
    
}
