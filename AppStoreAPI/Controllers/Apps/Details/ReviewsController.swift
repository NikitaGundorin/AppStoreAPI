//
//  ReviewsController.swift
//  AppStoreAPI
//
//  Created by Nikita Gundorin on 01.07.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class ReviewsController: HorizontalSnappingController {
    
    var reviews: Reviews? {
        didSet {
            collectionView.reloadData()
        }
    }
    private let cellId = "reviewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviews?.feed.entry.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ReviewCell else {
            return UICollectionViewCell()
        }
        let review = reviews?.feed.entry[indexPath.item]
        cell.authorLabel.text = review?.author.name.label
        cell.titleLabel.text = review?.title.label
        cell.bodyLabel.text = review?.content.label
        
        if let rating = Int(review?.rating.label ?? "") {
            for (i, view) in cell.starsStackView.arrangedSubviews.enumerated() {
                view.alpha = i >= rating ? 0 : 1
            }
        }
        
        return cell
    }
    
    private func setupCollectionView() {
        collectionView.register(ReviewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
}

extension ReviewsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 32, height: view.frame.height)
    }
}

