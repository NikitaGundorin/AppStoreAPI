//
//  ScreenshotCell.swift
//  AppStoreAPI
//
//  Created by Nikita Gundorin on 01.07.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class ScreenshotCell: UICollectionViewCell {
    let imageView = UIImageView(cornerRadius: 12)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(imageView)
        imageView.fillSuperview()
    }
}
