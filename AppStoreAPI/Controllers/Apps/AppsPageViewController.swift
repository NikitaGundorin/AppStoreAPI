//
//  AppsPageViewController.swift
//  AppStoreAPI
//
//  Created by Nikita Gundorin on 29.06.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class AppsPageViewController: BaseListController {
    
    private let cellId = "appsGroupCell"
    private let headerId = "headerId"
    private var groups = [AppGroup]()
    private var socialApps = [SocialApp]()
    private let activityIndicatorView: UIActivityIndicatorView = {
        let aiv: UIActivityIndicatorView = {
            if #available(iOS 13, *) {
                return UIActivityIndicatorView(style: .large)
            } else {
                let aiv = UIActivityIndicatorView(style: .whiteLarge)
                aiv.color = .black
                return aiv
            }
        }()
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupCollectionView()
        fetchData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? AppsGroupCell
            else { return UICollectionViewCell() }
        let appGroup = groups[indexPath.item]
        cell.titleLabel.text = appGroup.feed.title
        cell.horizontalController.appGroup = appGroup
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? AppsPageHeader
            else { return UICollectionReusableView() }
        
        header.appHeaderHorizontalController.apps = socialApps
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }
    
    private func setupLayout() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
    }
    
    private func setupCollectionView() {
        if #available(iOS 13, *) {
            collectionView.backgroundColor = .systemBackground
        } else {
            collectionView.backgroundColor = .white
        }
        
        collectionView.register(AppsGroupCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(AppsPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    private func fetchData() {
        let urlStrings = [
            "https://rss.itunes.apple.com/api/v1/us/ios-apps/new-apps-we-love/all/10/explicit.json",
            "https://rss.itunes.apple.com/api/v1/us/ios-apps/new-games-we-love/all/10/explicit.json",
            "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-free/all/10/explicit.json",
            "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-grossing/all/10/explicit.json",
            "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-paid/all/10/explicit.json"
        ]
        
        var results = [AppGroup?](repeating: nil, count: urlStrings.count)
        let dispatchGroup = DispatchGroup()
        let completionHandler = { (appGroup: AppGroup?, error: Error?, number: Int) in
            dispatchGroup.leave()
            if let error = error {
                print("Failed to fetch apps: ", error)
                return
            }
            results[number] = appGroup
        }
        
        for (number, urlString) in urlStrings.enumerated() {
            dispatchGroup.enter()
            Service.shared.fetchAppGroup(urlString: urlString, number: number, completion: completionHandler)
        }
        
        dispatchGroup.enter()
        Service.shared.fetchSocialApps { (apps, error) in
            dispatchGroup.leave()
            if let error = error {
                print("Failed to fetch social apps: ", error)
                return
            }
            self.socialApps = apps
        }
        
        dispatchGroup.notify(queue: .main) {
            self.activityIndicatorView.stopAnimating()
            results.forEach { appGroup in
                if let appGroup = appGroup {
                    self.groups.append(appGroup)
                }
            }
            self.collectionView.reloadData()
        }
    }
}

extension AppsPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 0, right: 0)
    }
}
