//
//  ReviewCell.swift
//  AppStoreAPI
//
//  Created by Nikita Gundorin on 01.07.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class ReviewCell: UICollectionViewCell {
    
    let titleLabel = UILabel(text: "Review Title", font: .boldSystemFont(ofSize: 18))
    let authorLabel: UILabel = {
        let label = UILabel(text: "Author", font: .systemFont(ofSize: 16))
        label.textColor = .lightGray
        label.textAlignment = .right
        return label
    }()
    let starsLabel = UILabel(text: "Stars", font: .systemFont(ofSize: 14))
    
    let starsStackView: UIStackView = {
        var arrangedSubviews = [UIView]()
        (0..<5).forEach { _ in
            let imageView = UIImageView(image: UIImage(named: "star"))
            imageView.constrainWidth(constant: 24)
            imageView.constrainHeight(constant: 24)
            arrangedSubviews.append(imageView)
        }
        arrangedSubviews.append(UIView())
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        
        return stackView
    }()
    
    let bodyLabel = UILabel(text: "1. Review body\n3. Review body\n3. Review body",
                            font: .systemFont(ofSize: 16),
                            numberOfLines: 5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        backgroundColor = UIColor(named: "reviewBG")
        layer.cornerRadius = 16
        clipsToBounds = true
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        let topStackView = UIStackView(arrangedSubviews: [
            titleLabel,
            authorLabel
        ], customSpacing: 8)
        
        let stackView = VerticalStackView(arrangedSubviews: [
            topStackView,
            starsStackView,
            bodyLabel
        ], spacing: 12)
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
    }
}
