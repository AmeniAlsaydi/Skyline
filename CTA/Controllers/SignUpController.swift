//
//  SignInController.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/15/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let options = ["Art", "Events"]
    
    private var selectedExperience = "Art"
    
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
        signUpButton.layer.cornerRadius = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(tapGesture)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self

    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        // create user on firebase
        /*
         user properties
         - experience
         - email
         - userId
         - createdDate?
         */
        
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
                self.showAlert(title: "Missing feilds", message: "Missing email or password.")
                return
            }
            
        AuthenticationSession.shared.createNewUser(email: email, password: password) { (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Error Signing up", message: "\(error.localizedDescription)")

                }
            case .success(let authDataResult):
                DispatchQueue.main.async {
                    //create a data base user and navigate to app view:
                    self.createDatabaseUser(authDataResult: authDataResult, experience: self.selectedExperience)
                }
            }
        }
        
    }
    
    private func createDatabaseUser(authDataResult: AuthDataResult, experience: String) {
        DatabaseService.shared.createDatabaseUser(authDataResult: authDataResult, experience: experience) { [weak self] (result) in
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Account error", message: error.localizedDescription)
            case .success:
                DispatchQueue.main.async {
                    print("database user created - check fire base database.")
                     //self?.navigateToMainView()
                }
               
            }
        }
        
    }
    
    
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension SignUpController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "optionCell", for: indexPath) as? OptionCell else {fatalError("could not down cast to Option Cell")}
        let option = options[indexPath.row]
        cell.optionLabel.text = option
        cell.delegate = self
        return cell
    }
}

extension SignUpController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize = UIScreen.main.bounds
        let height = maxSize.height * 0.10
        let width = maxSize.width * 0.2
        
        return CGSize(width: width, height: height)
    }
}


extension SignUpController: OptionCellDelegate {
    func didSelectExperience(_ optionCell: OptionCell, experience: String) {
        selectedExperience = experience
    }
}

extension SignUpController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true 
    }
}
