//
//  EditProfileViewController.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/20/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher // will need this for 

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var displayTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    private let experienceOptions = ["Art", "Events"]
    private var user: User
    private var experience: String?
    
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    private var selectedImage: UIImage? {
        didSet {
            profileImageView.image = selectedImage
        }
    }
    
    init?(coder: NSCoder, user: User) { 
        self.user = user
        super.init(coder:coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        saveButton.layer.cornerRadius = 10
        saveButton.layer.borderWidth = 1.0
        saveButton.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        displayTextField.delegate = self
        updateUI()
        setPicker()
        
    }
    
    private func updateUI() {
        displayTextField.text = user.displayName ?? ""
        if let photoUrl = user.photoUrl, !photoUrl.isEmpty, photoUrl != "no photoUrl" {
            profileImageView.kf.setImage(with: URL(string: photoUrl))
        } else {
            profileImageView.image = UIImage(named: "camera1")
        }
    }
    
    private func setPicker() {
        let index = experienceOptions.firstIndex(of: user.experience) ?? 0
        DispatchQueue.main.async {
            self.pickerView.selectRow(index, inComponent: 0, animated: true)
        }
    }
    
    
    @IBAction func editPictureButtonPressed(_ sender: UIButton) {
        // present image picker view
        
        let alertController = UIAlertController(title: "Change Profile Photo", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { alertAction in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
        let photoLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { alertAction in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
        }
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        alertController.view.tintColor = .black
        present(alertController, animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        updateUser()
        // pop VC
        navigationController?.popViewController(animated: true)
    }
    
    private func updateUser() {
        
        let displayName = displayTextField.text ?? ""
        
        if let selectedImage = selectedImage {
            guard let user = Auth.auth().currentUser else { return }
            
               let resizedImage = UIImage.resizeImage(originalImage: selectedImage, rect: profileImageView.bounds)
               
               StorageService.shared.uploadPhoto(userId: user.uid, image: resizedImage) { [weak self] (result) in
                   switch result{
                       case .failure(let error):
                           print("error uploading photo/updating profile: \(error.localizedDescription)")
                       case .success(let url):
                           self?.updateUserInfo(displayName: displayName, photoUrl: url.absoluteString)
                   }
               }
            
        } else {
            updateUserInfo(displayName: displayName, photoUrl: user.photoUrl ?? "")
        }
    }
    
    private func updateUserInfo(displayName: String, photoUrl: String) {
        
        DatabaseService.shared.updateDatabaseUser(displayName: displayName, photoUrl: photoUrl, experience: experience ?? user.experience) { (result) in
            switch result {
            case .failure(let error):
                print("failed to update user profile: \(error.localizedDescription)")
            case .success:
                print("successfully updated user")
            }
        }
    }
}

extension EditProfileViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        experienceOptions.count
    }
}

extension EditProfileViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return experienceOptions[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        experience = experienceOptions[row]
        
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        return true
    }
}


extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        selectedImage = image
        dismiss(animated: true)
    }
}
