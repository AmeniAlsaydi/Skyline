//
//  LogInController.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/15/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class LogInController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(didTap(_:)))
        return gesture
    }()
    
    @objc private func didTap(_ gesture: UITapGestureRecognizer ) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        logInButton.layer.cornerRadius = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(tapGesture) // TEST THIS
        emailTextField.delegate = self
        passwordTextField.delegate = self

    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        // log user in
        guard let email = emailTextField.text, !email.isEmpty else {
            emailTextField.layer.borderWidth = 1.0
            emailTextField.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            passwordTextField.layer.borderWidth = 1.0
            passwordTextField.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            return
        }
        
        
        AuthenticationSession.shared.signExisitingUser(email: email, password: password) { (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Error signing in", message: error.localizedDescription)
                }
            case .success:
                DispatchQueue.main.async {
                    // go to main view
                    self.navigateToMainView()
                }
            }
        }
        
    }
    
    private func navigateToMainView() {
        // we have the uiviewcontroller extension
        UIViewController.showViewController(storyBoardName: "MainView", viewControllerId: "MainTabBarController")
        
    }
}


extension LogInController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true 
    }
}
