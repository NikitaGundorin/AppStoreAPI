//
//  TodayItem.swift
//  AppStoreAPI
//
//  Created by Nikita Gundorin on 02.07.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

struct TodayItem {
    let category: String
    let title: String
    let image: UIImage?
    let description: String
    let backgroundColor: UIColor
    let cellType: CellType
    let apps: [FeedResult]
    
    enum CellType: String {
        case single
        case multiple
    }
}
