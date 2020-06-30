//
//  AppDetailCell.swift
//  AppStoreAPI
//
//  Created by Nikita Gundorin on 30.06.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class AppDetailCell: UICollectionViewCell {
    var app: Result! {
        didSet {
            nameLabel.text = app?.trackName
            releaseNotesLabel.text = app?.releaseNotes
            priceButton.setTitle(app?.formattedPrice, for: .normal)
            if let urlString = app?.artworkUrl100 {
                appIconImageView.sd_setImage(with: URL(string: urlString))
            }
        }
    }
    private let appIconImageView = UIImageView(cornerRadius: 16)
    private let nameLabel = UILabel(text: "App Name", font: .boldSystemFont(ofSize: 24), numberOfLines: 2)
    private let priceButton: UIButton = {
        let button = UIButton(title: "$4.99")
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let whatsNewLabel = UILabel(text: "What's New", font: .boldSystemFont(ofSize: 20))
    private let releaseNotesLabel = UILabel(text: "Release Notes", font: .systemFont(ofSize: 16), numberOfLines: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        appIconImageView.constrainWidth(constant: 140)
        appIconImageView.constrainHeight(constant: 140)
        priceButton.constrainWidth(constant: 80)
        
        let infoStackView = VerticalStackView(arrangedSubviews: [
            nameLabel,
            UIStackView(arrangedSubviews: [priceButton, UIView()]),
            UIView()
        ], spacing: 12)
        let topStackView = UIStackView(arrangedSubviews: [
            appIconImageView,
            infoStackView
        ], customSpacing: 20
        )
        let stackView = VerticalStackView(arrangedSubviews: [
            topStackView,
            whatsNewLabel,
            releaseNotesLabel
        ], spacing: 16)
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 20, left: 20, bottom: 20, right: 20))
    }
}
