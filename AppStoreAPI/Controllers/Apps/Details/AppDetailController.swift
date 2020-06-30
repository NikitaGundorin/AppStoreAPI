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
        }
    }
    private var app: Result?
    private let cellId = "appDetailCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupCollectionView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? AppDetailCell
            else { return UICollectionViewCell() }
        
        cell.app = app
        return cell
    }
    
    private func setupLayout() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupCollectionView() {
        collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: cellId)
    }
}

extension AppDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = CGFloat(1000)
        let dummyCell = AppDetailCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: height))
        dummyCell.app = app
        dummyCell.layoutIfNeeded()
        let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: height))
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
}
