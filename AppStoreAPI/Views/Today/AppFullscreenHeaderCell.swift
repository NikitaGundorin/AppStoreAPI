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
    }
}
