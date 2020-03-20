//
//  ProfileController.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var experienceImageView: UIImageView!
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        experienceImageView.layer.cornerRadius = experienceImageView.frame.width/2
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func editProfileButton(_ sender: UIButton) {
        // push edit profile page 
        
    }
    

    @IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {
        
        showOptionsAlert(title: nil, message: "Are you sure?") { (alerAction) in
            if alerAction.title == "Yes, Get me out." {
                
                do {
                    try Auth.auth().signOut()
                    UIViewController.showViewController(storyBoardName: "Login", viewControllerId: "LogInController")
                } catch {
                    self.showAlert(title: "Error signing out", message: "\(error.localizedDescription)")
                }
            }
        }
        
    }
    
    

}
