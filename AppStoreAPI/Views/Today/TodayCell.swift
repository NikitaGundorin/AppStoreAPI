//
//  TodayCell.swift
//  AppStoreAPI
//
//  Created by Nikita Gundorin on 01.07.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class TodayCell: BaseTodayCell {
    override var todayItem: TodayItem! {
        didSet {
            imageView.image = todayItem.image
            categoryLabel.text = todayItem.category
            titleLabel.text = todayItem.title
            descriptionLabel.text = todayItem.description
            backgroundView?.backgroundColor = todayItem.backgroundColor
        }
    }
    private let imageView = UIImageView(image: UIImage(named: "garden"))
    private let categoryLabel = UILabel(text: "LIFE HACK", font: .boldSystemFont(ofSize: 20))
    private let titleLabel = UILabel(text: "Utilizing yourTime", font: .boldSystemFont(ofSize: 28))
    private let descriptionLabel = UILabel(text: "All the tools and apps you need to intelligently organize your life the right way",
                                           font: .systemFont(ofSize: 16), numberOfLines: 3)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        imageView.contentMode = .scaleAspectFill
        let imageContainerView = UIView()
        imageContainerView.addSubview(imageView)
        imageContainerView.clipsToBounds = true
        imageView.centerInSuperview(size: .init(width: 240, height: 240))
        let stackView = VerticalStackView(arrangedSubviews: [
            categoryLabel,
            titleLabel,
            imageContainerView,
            descriptionLabel
        ], spacing: 8)
        addSubview(stackView)
        stackView.anchor(top: safeAreaLayoutGuide.topAnchor,
                         leading: leadingAnchor,
                         bottom: bottomAnchor,
                         trailing: trailingAnchor,
                         padding: .init(top: 24, left: 24, bottom: 24, right: 24))
    }
}
