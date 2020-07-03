//
//  AppFullscreenHeaderCell.swift
//  AppStoreAPI
//
//  Created by Nikita Gundorin on 02.07.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class AppFullscreenHeaderCell: UITableViewCell {
    let todayCell = TodayCell()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(todayCell)
        todayCell.backgroundView?.layer.shadowOpacity = 0
        todayCell.backgroundView?.layer.cornerRadius = 0
        todayCell.fillSuperview()
        
        addSubview(closeButton)
        closeButton.anchor(top: safeAreaLayoutGuide.topAnchor,
                           leading: nil,
                           bottom: nil,
                           trailing: trailingAnchor,
                           padding: .init(top: 12, left: 0, bottom: 0, right: 12),
                           size: .init(width: 80, height: 38))
    }
}
