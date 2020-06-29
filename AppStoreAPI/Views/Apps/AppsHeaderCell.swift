//
//  AppsHeaderCell.swift
//  AppStoreAPI
//
//  Created by Nikita Gundorin on 29.06.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class AppsHeaderCell: UICollectionViewCell {
    
    private let companyLabel = UILabel(text: "Facebook", font: .boldSystemFont(ofSize: 12))
    private let titleLabel = UILabel(text: "Keepung up with friends is faster than ever", font: .systemFont(ofSize: 24))
    private let imageView = UIImageView(cornerRadius: 8)

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        companyLabel.textColor = .systemBlue
        imageView.backgroundColor = .systemYellow
        titleLabel.numberOfLines = 2
        
        let stackView = VerticalStackView(arrangedSubviews: [
            companyLabel,
            titleLabel,
            imageView
        ], spacing: 20)
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 16, left: 0, bottom: 0, right: 0))
    }
}
