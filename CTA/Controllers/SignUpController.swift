//
//  SignInController.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/15/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class SignUpController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var signUpButton: UIButton!
    
    private let options = ["ART", "EVENTS"]
    
    override func viewDidLayoutSubviews() {
        signUpButton.layer.cornerRadius = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self

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
