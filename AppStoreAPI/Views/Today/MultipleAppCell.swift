//
//  MultipleAppCell.swift
//  AppStoreAPI
//
//  Created by Nikita Gundorin on 03.07.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit
import SDWebImage

class MultipleAppCell: UICollectionViewCell {
    var app: FeedResult! {
        didSet {
            nameLabel.text = app.name
            companyLabel.text = app.artistName
            appIconImageView.sd_setImage(with: URL(string: app.artworkUrl100))
        }
    }
    private let appIconImageView = UIImageView(cornerRadius: 8)
    private let nameLabel = UILabel(text: "App Name", font: .systemFont(ofSize: 20))
    private let companyLabel = UILabel(text: "Company Name", font: .systemFont(ofSize: 13))
    private let getButton = UIButton(title: "GET")
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        appIconImageView.constrainWidth(constant: 64)
        appIconImageView.constrainHeight(constant: 64)
        getButton.backgroundColor = UIColor(named: "getButtonBG")
        getButton.constrainWidth(constant: 80)
        getButton.constrainHeight(constant: 32)
        getButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        getButton.layer.cornerRadius = 16
        
        let verticalStackView = VerticalStackView(arrangedSubviews: [
            nameLabel,
            companyLabel
        ], spacing: 4)
        
        let horisontalStackView = UIStackView(arrangedSubviews: [
            appIconImageView,
            verticalStackView,
            getButton
        ])
        horisontalStackView.spacing = 16
        horisontalStackView.alignment = .center
        
        addSubview(horisontalStackView)
        horisontalStackView.fillSuperview()
        
        addSubview(separatorView)
        separatorView.anchor(top: nil, leading: nameLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, size: .init(width: 0, height: 0.5))
    }
}
