//
//  AppsSearchViewController.swift
//  AppStoreAPI
//
//  Created by Nikita Gundorin on 28.06.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit
import SDWebImage


class AppsSearchViewController: BaseListController {
    private let cellId = "cell"
    private var appResults: [Result] = []
    private let searchController = UISearchController(searchResultsController: nil)
    private var timer: Timer?
    private let enterSearchTermLabel: UILabel = {
        let label = UILabel()
        label.text = "Please, enter search term above"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    private var searchText = ""
    private var isPaginating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupCollectionView()
        setupSearchBar()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        enterSearchTermLabel.isHidden = appResults.count != 0
        return appResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SearchResultCell
            else { return UICollectionViewCell() }
        
        cell.appResult = appResults[indexPath.item]
        
        if indexPath.item == appResults.count - 1 && !isPaginating {
            isPaginating = true
            fetchITunesApps()
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appDetailController = AppDetailController(appId: String(appResults[indexPath.item].trackId))
        navigationController?.pushViewController(appDetailController, animated: true)
    }
    
    private func setupLayout() {
        view.addSubview(enterSearchTermLabel)
        enterSearchTermLabel.fillSuperview()
    }
    
    private func setupCollectionView() {
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    private func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func fetchITunesApps(searchTerm: String? = nil) {
        let offset = searchTerm == nil ? appResults.count : 0
        Service.shared.fetchApps(searchTerm: searchTerm ?? searchText, offset: offset) { result, error in
            if let error = error {
                print("Failed to fetch results: ", error)
                return
            }
            if searchTerm == nil {
                self.appResults += result?.results ?? []
            } else {
                self.appResults = result?.results ?? []
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            self.isPaginating = false
        }
    }
}

extension AppsSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 350)
    }
}

extension AppsSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: {_ in
            self.searchText = searchText
            self.fetchITunesApps(searchTerm: searchText)
        })
    }
}
