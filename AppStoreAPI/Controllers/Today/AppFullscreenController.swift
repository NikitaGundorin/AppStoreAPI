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
    let floatingContainerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupCloseButton()
        setupFloatingControlls()
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
    
    private func setupFloatingControlls() {
        view.addSubview(floatingContainerView)
        floatingContainerView.layer.cornerRadius = 16
        floatingContainerView.clipsToBounds = true
        floatingContainerView.anchor(top: nil,
                                     leading: view.leadingAnchor,
                                     bottom: view.bottomAnchor,
                                     trailing: view.trailingAnchor,
                                     padding: .init(top: 0,
                                                    left: 16,
                                                    bottom: -90,
                                                    right: 16),
                                     size: .init(width: 0,
                                                 height: 100))
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        floatingContainerView.addSubview(blurView)
        blurView.fillSuperview()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        let imageView = UIImageView(cornerRadius: 16)
        imageView.image = todayItem?.image
        imageView.constrainWidth(constant: 68)
        imageView.constrainHeight(constant: 68)
        
        let getButton = UIButton(title: "GET")
        getButton.backgroundColor = UIColor(named: "getButtonBG")
        getButton.constrainWidth(constant: 80)
        getButton.constrainHeight(constant: 32)
        getButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        getButton.layer.cornerRadius = 16
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            VerticalStackView(arrangedSubviews: [
                UILabel(text: "Life Hack", font: .boldSystemFont(ofSize: 18)),
                UILabel(text: "Utilizing your Time", font: .systemFont(ofSize: 16))
            ], spacing: 4),
            getButton
        ], customSpacing: 16)
        stackView.alignment = .center
        
        floatingContainerView.addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    @objc private func handleTap() {
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.7,
                       options: .curveEaseOut,
                       animations: {
                        self.floatingContainerView.transform = .init(translationX: 0, y: -90)
        })
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
        
        let translationY = -90 - UIApplication.shared.statusBarFrame.height
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.7,
                       options: .curveEaseOut,
                       animations: {
                            self.floatingContainerView.transform = scrollView.contentOffset.y > 100 ?
                                .init(translationX: 0, y: translationY) :
                                .identity
        })
    }
}
