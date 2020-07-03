//
//  TodayController.swift
//  AppStoreAPI
//
//  Created by Nikita Gundorin on 01.07.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class TodayController: BaseListController {
    static let cellSize: CGFloat = 470
    private var todayItems = [TodayItem]()
    private let activityIndicator: UIActivityIndicatorView = {
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
    private var startingFrame: CGRect?
    private var tabBarFrame: CGRect?
    private var appFullscreenController: UIViewController!
    private var anchorConstraint: AnchoredConstraints?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        fetchData()
        setupCollectionView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todayItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let todayItem = todayItems[indexPath.item]
        let cellId = todayItem.cellType.rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        if let cell = cell as? BaseTodayCell {
            cell.todayItem = todayItem
        }
        
        (cell as? TodayMultipleAppsCell)?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleAppsTap)))
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch todayItems[indexPath.item].cellType {
        case .multiple:
            showDailyListFullScreen(indexPath: indexPath)
        case .single:
            showSingleAppFullscreen(indexPath: indexPath)
        }
    }
    
    private func setupCollectionView() {
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        collectionView.register(TodayMultipleAppsCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
    }
    
    private func setupLayout() {
        view.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
    }
    
    private func fetchData() {
        let urlStrings = [
            "https://rss.itunes.apple.com/api/v1/us/ios-apps/new-games-we-love/all/10/explicit.json",
            "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-grossing/all/10/explicit.json",
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
        
        dispatchGroup.notify(queue: .main) {
            self.activityIndicator.stopAnimating()
            self.todayItems.append(contentsOf: [
                TodayItem(category: "LIFE HACK",
                          title: "Utilizing your Time",
                          image: UIImage(named: "garden"),
                          description: "All the tools and apps you need to intelligently organize your life the right way.",
                          backgroundColor: .white,
                          cellType: .single,
                          apps: []),
                TodayItem(category: "HOLIDAYS",
                          title: "Travel on a Budget",
                          image: UIImage(named: "holiday"),
                          description: "Find out all you need to know on how to travel without packing everything!",
                          backgroundColor: #colorLiteral(red: 0.9860358834, green: 0.9676796794, blue: 0.7220557332, alpha: 1),
                          cellType: .single,
                          apps: []),
            ])
            results.forEach { appGroup in
                if let appGroup = appGroup {
                    self.todayItems.append(.init(category: "DailyList",
                                                 title: appGroup.feed.title,
                                                 image: nil,
                                                 description: "",
                                                 backgroundColor: .white,
                                                 cellType: .multiple,
                                                 apps: appGroup.feed.results))
                }
            }
            self.collectionView.reloadData()
        }
    }
    
    private func showDailyListFullScreen( indexPath: IndexPath) {
        let fullController = TodayMultipleAppsController(mode: .fullScreen)
        fullController.view.backgroundColor = .systemTeal
        fullController.apps = todayItems[indexPath.item].apps
        let navController = BackEnabledNavigationController(rootViewController: fullController)
        navController.modalPresentationStyle = .fullScreen
        navController.isNavigationBarHidden = true
        present(navController, animated: true)
    }
    
    private func showSingleAppFullscreen(indexPath: IndexPath) {
        setupSingleAppFullscreenController(indexPath)
        setupSingleAppFullscreenStartingPosition(indexPath)
        beginAnimationSingleAppFullscreen()
    }
    
    private func setupSingleAppFullscreenController(_ indexPath: IndexPath) {
        let appFullscreenController = AppFullscreenController()
        appFullscreenController.dismissHandler = {
            self.handleRemoveFullscreenView()
        }
        appFullscreenController.todayItem = todayItems[indexPath.item]
        self.appFullscreenController = appFullscreenController
    }
    
    private func setupSingleAppFullscreenStartingPosition(_ indexPath: IndexPath) {
        guard let fullscreenView = appFullscreenController.view else { return }
        fullscreenView.layer.cornerRadius = 16
        view.addSubview(fullscreenView)
        addChild(appFullscreenController)
        collectionView.isUserInteractionEnabled = false
        
        setupStartingCellFrame(indexPath)
        guard let startingFrame = startingFrame else { return }
        
        anchorConstraint = fullscreenView.anchor(top: view.topAnchor,
                                                 leading: view.leadingAnchor,
                                                 bottom: nil,
                                                 trailing: nil,
                                                 padding: .init(top: startingFrame.origin.y,
                                                                left: startingFrame.origin.x,
                                                                bottom: 0,
                                                                right: 0),
                                                 size: .init(width: startingFrame.width,
                                                             height: startingFrame.width))
        
        view.layoutIfNeeded()
        tabBarFrame = tabBarController?.tabBar.frame
    }
    
    private func setupStartingCellFrame(_ indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath),
            let startingFrame = cell.superview?.convert(cell.frame, to: nil)
            else { return }
        
        self.startingFrame = startingFrame
    }
    
    private func beginAnimationSingleAppFullscreen() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.anchorConstraint?.top?.constant = 0
            self.anchorConstraint?.leading?.constant = 0
            self.anchorConstraint?.width?.constant = self.view.frame.width
            self.anchorConstraint?.height?.constant = self.view.frame.height

            self.view.layoutIfNeeded()
            
            if #available(iOS 13, *) {
                self.tabBarController?.tabBar.frame = CGRect(x: 0, y: self.view.bounds.height + (self.tabBarFrame?.height ?? 0.0) + 20, width: self.tabBarFrame?.width ?? 0.0, height: self.tabBarFrame?.height ?? 0.0)
            } else {
                self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: self.tabBarController?.tabBar.frame.height ?? 0.0)
            }
            self.navigationController?.isNavigationBarHidden = true
        }, completion: nil)
    }
    
    @objc private func handleRemoveFullscreenView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            guard let startingFrame = self.startingFrame else { return }
            
            self.anchorConstraint?.top?.constant = startingFrame.origin.y
            self.anchorConstraint?.leading?.constant = startingFrame.origin.x
            self.anchorConstraint?.width?.constant = startingFrame.width
            self.anchorConstraint?.height?.constant = startingFrame.height
            
            self.view.layoutIfNeeded()
            
            if #available(iOS 13, *) {
                self.tabBarController?.tabBar.frame = self.tabBarFrame ?? .zero
            } else {
                self.tabBarController?.tabBar.transform = .identity
            }
            self.navigationController?.isNavigationBarHidden = false
        }, completion: { _ in
            self.appFullscreenController.view.removeFromSuperview()
            self.appFullscreenController.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true
        })
    }
    
    @objc private func handleMultipleAppsTap(gesture: UIGestureRecognizer) {
        if let cell = gesture.view as? TodayMultipleAppsCell {
            guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
            let apps = self.todayItems[indexPath.item].apps
            let fullController = TodayMultipleAppsController(mode: .fullScreen)
            fullController.view.backgroundColor = .systemTeal
            fullController.apps = apps
            let navController = BackEnabledNavigationController(rootViewController: fullController)
            navController.modalPresentationStyle = .fullScreen
            navController.isNavigationBarHidden = true
            present(navController, animated: true)
        }
    }
}

extension TodayController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 32, height: TodayController.cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
}
