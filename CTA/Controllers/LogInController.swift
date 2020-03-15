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
    
    override func viewDidLayoutSubviews() {
        logInButton.layer.cornerRadius = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    


}
