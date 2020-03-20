//
//  DetailViewController.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/19/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import Kingfisher

class ArtDetailViewController: UIViewController {
    
    private let detailView = DetailView()
    private var artObject: ArtObject
    
    private var artDetail: ArtDetail? {
        didSet {
            DispatchQueue.main.async {
                self.updateDetailUI()
            }
        }
    }
    
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
        
        print(artObject.objectNumber)
        updateUI()

        getArtDetail(objectNumber: artObject.objectNumber)
        view.backgroundColor = .white
    }
    
    private func getArtDetail(objectNumber: String) {
        ApiClient.getArtDetail(objectNumber: objectNumber) { (result) in
            switch result {
            case .failure(let error):
                print("error getting art details: \(error.localizedDescription)")
            case .success(let artDetail):
                self.artDetail = artDetail
            }
        }
    }
    
    private func updateUI(){ // I needed to separate the 2 update UIs become some were coming back nil
        detailView.largeLabel.text = artObject.title
        guard let urlString = artObject.webImage?.url else {
            detailView.mainImage.image = UIImage(named: "noimage")
            detailView.backgroundImage.image = UIImage(named: "noimage")
            return
        }
        
        detailView.mainImage.kf.setImage(with: URL(string: urlString))
        detailView.backgroundImage.kf.setImage(with: URL(string: urlString))
        
    }
    
    private func updateDetailUI() {
        guard let artDetail = artDetail else {
            print("no art detail")
            return
        }
        
        detailView.smallLabel1.text = artDetail.plaqueDescriptionEnglish ?? "Description N/A"
        detailView.smallLabel2.text = "Work of: \(artDetail.principalMaker)"
        detailView.smallLabel3.text = "Presenting date: \(artDetail.dating.presentingDate)"
        
        
        
        if !artDetail.principalMakers[0].productionPlaces.isEmpty {
            let productionPlace = artDetail.principalMakers[0].productionPlaces[0]
            detailView.smallLabel4.text = "Place produced: \(productionPlace)"
        } else {
             detailView.smallLabel4.text = "Place produced: N/A"
        }

    }


}
