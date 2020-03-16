//
//  SearchController.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class SearchController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()

    }
    
    private func configureCollectionView() {
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: "eventCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }

}

extension SearchController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as? EventCell else {
            fatalError("could not down cast to event cell")
        }
        return cell
    }
}

extension SearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let maxSize = UIScreen.main.bounds
        let height = maxSize.height * 0.15
        let width = maxSize.width
        return CGSize(width: width, height: height)
    }
}
