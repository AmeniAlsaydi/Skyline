//
//  DetailViewController.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/19/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    private let detailView = DetailView()
    private var artObject: ArtObject
    
    init(_ artObject: ArtObject) {
        self.artObject = artObject
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        updateUI()
    }
    
    
    private func updateUI() {
        
    }


}
