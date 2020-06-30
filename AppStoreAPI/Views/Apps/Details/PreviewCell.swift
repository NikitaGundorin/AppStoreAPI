//
//  PreviewCell.swift
//  AppStoreAPI
//
//  Created by Nikita Gundorin on 30.06.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class PreviewCell: UICollectionViewCell {
    let horizontalController = PreviewScreenshotsController()
    private let previewLabel = UILabel(text: "Preview", font: .boldSystemFont(ofSize: 20))
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(previewLabel)
        addSubview(horizontalController.view)
        
        previewLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        horizontalController.view.anchor(top: previewLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
    }
}
