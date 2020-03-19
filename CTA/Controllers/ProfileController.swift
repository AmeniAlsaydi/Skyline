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

    override func viewDidLoad() {
        super.viewDidLoad()
        let objectNum = "SK-A-3580"
        getArtDetail(objectNumber: objectNum)

        
    }
    
    private func getArtDetail(objectNumber: String) {
        ApiClient.getArtDetail(objectNumber: objectNumber) { (result) in
            switch result {
            case .failure(let error):
                print("error getting art details: \(error.localizedDescription)")
            case .success(let artDetail):
                print(artDetail.plaqueDescriptionEnglish)
            }
        }
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
