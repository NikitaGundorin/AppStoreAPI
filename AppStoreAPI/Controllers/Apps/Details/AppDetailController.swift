//
//  AppDetailController.swift
//  AppStoreAPI
//
//  Created by Nikita Gundorin on 30.06.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class AppDetailController: BaseListController {
    
    var appId: String! {
        didSet {
            Service.shared.fetchGenericJSONData(urlString: "https://itunes.apple.com/lookup?id=\(appId ?? "")") { (result: SearchResult?, error) in
                self.app = result?.results.first
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            
            let reviewsUrl = "https://itunes.apple.com/rss/customerreviews/page=1/id=\(appId ?? "")/mostrecent/json"
            Service.shared.fetchGenericJSONData(urlString: reviewsUrl) { (reviews: Reviews?, error) in
                self.reviews = reviews
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    private var app: Result?
    private var reviews: Reviews?
    private let detailCellId = "appDetailCell"
    private let previewCellId = "appPreviewCell"
    private let reviewCellId = "appReviewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupCollectionView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellId, for: indexPath) as? AppDetailCell {
            cell.app = app
            return cell
        } else if indexPath.item == 1, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: previewCellId, for: indexPath) as? PreviewCell {
            cell.horizontalController.app = app
            return cell
        } else if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewCellId, for: indexPath) as? ReviewRowCell {
            cell.reviewsController.reviews = reviews
            return cell
        }
        return UICollectionViewCell()
    }
    
    private func setupLayout() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupCollectionView() {
        collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: detailCellId)
        collectionView.register(PreviewCell.self, forCellWithReuseIdentifier: previewCellId)
        collectionView.register(ReviewRowCell.self, forCellWithReuseIdentifier: reviewCellId)
    }
}

extension AppDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 250
        if indexPath.item == 0 {
            height = 1000
            let dummyCell = AppDetailCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: height))
            dummyCell.app = app
            dummyCell.layoutIfNeeded()
            let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: height))
            height = estimatedSize.height
        } else if indexPath.item == 1 {
            height = 500
        }
        
        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 16, right: 0)
    }
}
