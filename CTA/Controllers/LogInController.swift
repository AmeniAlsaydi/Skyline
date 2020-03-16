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
    @IBOutlet weak var passwordTextFeild: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    private var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(didTap))
        return gesture
    }()
    
    @objc private func didTap() {
        resignFirstResponder()
    }
    override func viewDidLayoutSubviews() {
        logInButton.layer.cornerRadius = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(tapGesture) // TEST THIS
        emailTextField.delegate = self
        passwordTextFeild.delegate = self

    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        // log user in
        
    }
}


extension LogInController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
    }
}
