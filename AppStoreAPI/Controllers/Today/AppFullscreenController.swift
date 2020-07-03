//
//  AppFullscreenController.swift
//  AppStoreAPI
//
//  Created by Nikita Gundorin on 01.07.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class AppFullscreenController: UIViewController {
    let tableView = UITableView(frame: .zero, style: .plain)
    var dismissHandler: (() -> ())?
    var todayItem: TodayItem?
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupCloseButton()
    }
    
    @objc private func handleDismiss(button: UIButton) {
        button.isHidden = true
        dismissHandler?()
    }
    
    private func setupTableView() {
        view.clipsToBounds = true
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        let height = UIApplication.shared.statusBarFrame.height
        tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                           leading: nil,
                           bottom: nil,
                           trailing: view.trailingAnchor,
                           padding: .init(top: 0, left: 0, bottom: 0, right: 12),
                           size: .init(width: 80, height: 40))
    }
}

extension AppFullscreenController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let headerCell = AppFullscreenHeaderCell()
            headerCell.todayCell.todayItem = todayItem
            return headerCell
        }
        let cell = AppFullscreedDescriptionCell()
        return cell
    }
}

extension AppFullscreenController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return TodayController.cellSize
        }
        return UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
        }
    }
}
