//
//  BaseTodayCell.swift
//  AppStoreAPI
//
//  Created by Nikita Gundorin on 03.07.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

import UIKit

class BaseTodayCell: UICollectionViewCell {
    var todayItem: TodayItem!
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseOut,
                           animations: {
                            self.transform = self.isHighlighted ? .init(scaleX: 0.9, y: 0.9) : .identity
            }, completion: nil)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupShadow() {
        backgroundView = UIView()
        addSubview(self.backgroundView!)
        backgroundView?.fillSuperview()
        backgroundView?.layer.cornerRadius = 16
        backgroundView?.layer.shadowColor = UIColor.black.cgColor
        backgroundView?.layer.shadowOpacity = 0.2
        backgroundView?.layer.shadowRadius = 10
        backgroundView?.layer.shouldRasterize = true
    }
}
