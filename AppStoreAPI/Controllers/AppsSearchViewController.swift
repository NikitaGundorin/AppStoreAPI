//
//  AppsSearchViewController.swift
//  AppStoreAPI
//
//  Created by Nikita Gundorin on 28.06.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit
import SDWebImage


class AppsSearchViewController: UICollectionViewController {

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
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        return cell
    }
    
    private func setupLayout() {
        view.addSubview(enterSearchTermLabel)
        enterSearchTermLabel.fillSuperview()
    }
    
    private func setupCollectionView() {
        if #available(iOS 13, *) {
            collectionView.backgroundColor = .systemBackground
        } else {
            collectionView.backgroundColor = .white
        }
        
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    private func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func fetchITunesApps(searchTerm: String) {
        Service.shared.fetchApps(searchTerm: searchTerm) { results, error in
            if let error = error {
                print("Failed to fetch results: ", error)
                return
            }
            self.appResults = results
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
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
            self.fetchITunesApps(searchTerm: searchText)
        })
    }
}
