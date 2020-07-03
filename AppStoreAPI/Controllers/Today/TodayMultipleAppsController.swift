//
//  TodayMultipleAppsController.swift
//  AppStoreAPI
//
//  Created by Nikita Gundorin on 03.07.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class TodayMultipleAppsController: BaseListController {
    var apps: [FeedResult]? {
        didSet {
            collectionView.reloadData()
        }
    }
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    private let cellId = "multipleAppCell"
    private let mode: Mode
    
    init(mode: Mode) {
        self.mode = mode
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch mode {
        case .fullScreen:
            return apps?.count ?? 0
        case .small:
            return min(4, apps?.count ?? 0)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        if let cell = cell as? MultipleAppCell {
            cell.app = apps?[indexPath.item]
        }
        
        return cell
    }
    
    override var prefersStatusBarHidden: Bool {
        switch mode {
        case .fullScreen:
            return true
        case .small:
            return false
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let appId = apps?[indexPath.row].id else { return }
        let appDetailController = AppDetailController(appId: appId)
        navigationController?.pushViewController(appDetailController, animated: true )
    }
    
    private func setupCollectionView() {
        collectionView.register(MultipleAppCell.self, forCellWithReuseIdentifier: cellId)
        if mode == .small {
            collectionView.isScrollEnabled = false
        }
    }
    
    private func setupLayout() {
        if mode == .fullScreen {
            view.addSubview(closeButton)
            closeButton.anchor(top: view.topAnchor,
                               leading: nil,
                               bottom: nil,
                               trailing: view.trailingAnchor,
                               padding: .init(top: 20, left: 0, bottom: 0, right: 16),
                               size: .init(width: 44, height: 44))
            navigationController?.isNavigationBarHidden = true
        }
    }
    
    @objc private func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    enum Mode {
        case small
        case fullScreen
    }
}

extension TodayMultipleAppsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch mode {
        case .fullScreen:
            return .init(width: view.frame.width - 48, height: 80)
        case .small:
            return .init(width: view.frame.width, height: 80)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch mode {
        case .fullScreen:
            return .init(top: 12, left: 24, bottom: 12, right: 24)
        case .small:
            return .zero
        }
    }
}
