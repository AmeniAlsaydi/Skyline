//
//  ProfileController.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher

class ProfileController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var experienceImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    
    
    private var appState: AppState! {
        didSet {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    private var user: User!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        experienceImageView.layer.cornerRadius = experienceImageView.frame.width/2
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    private func getUser() {
           DatabaseService.shared.getUser { [weak self] (result) in
               switch result {
               case .failure(let error):
                   print("ERROR HERE: \(error.localizedDescription)")
               case .success(let user):
                   self?.user = user
                   if user.experience == "Art" {
                       self?.appState = .art
                   } else if user.experience == "Events" {
                       self?.appState = .events
                   }
               }
           }
       }
    
    private func updateUI() {
        
        emailLabel.text = user.email
        displayNameLabel.text = user.displayName

        if let userPhoto = user.photoUrl, userPhoto != "", userPhoto != "no photoUrl" {
            profileImageView.kf.setImage(with: URL(string: userPhoto) )
        } else {
            profileImageView.image = UIImage(named: "person")
        }
        
        
        if appState == .art {
            experienceImageView.image = UIImage(named: "Rijksmuseum")
            experienceLabel.text = "ARTS"
            
        } else if appState == .events {
            experienceImageView.image = UIImage(named: "ticketMaster")
            experienceLabel.text = "EVENTS"
        }
    }
    
    @IBAction func editProfileButton(_ sender: UIButton) {
        // push edit profile page
        let storyboard = UIStoryboard(name: "MainView", bundle: nil)
        let editVC = storyboard.instantiateViewController(identifier: "EditProfileViewController") {
            (coder) in
            return EditProfileViewController(coder: coder, user: self.user)
            
        }
        
        navigationController?.pushViewController(editVC, animated: true)
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
