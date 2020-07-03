//
//  TodayMultipleAppsCell.swift
//  AppStoreAPI
//
//  Created by Nikita Gundorin on 03.07.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class TodayMultipleAppsCell: BaseTodayCell {
    override var todayItem: TodayItem! {
        didSet {
            categoryLabel.text = todayItem.category
            titleLabel.text = todayItem.title
            backgroundView?.backgroundColor = todayItem.backgroundColor
            multipleAppsController.apps = todayItem.apps
        }
    }
    var multipleAppsController = TodayMultipleAppsController(mode: .small)
    
    private let categoryLabel = UILabel(text: "LIFE HACK", font: .boldSystemFont(ofSize: 20))
    private let titleLabel = UILabel(text: "Utilizing yourTime", font: .boldSystemFont(ofSize: 28), numberOfLines: 2)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let stackView = VerticalStackView(arrangedSubviews: [
            categoryLabel,
            titleLabel,
            multipleAppsController.view
        ], spacing: 8)
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 24, left: 24, bottom: 24, right: 24))
    }
}
