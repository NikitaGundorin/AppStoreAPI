//
//  ReviewFeed.swift
//  AppStoreAPI
//
//  Created by Nikita Gundorin on 01.07.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

struct ReviewFeed: Decodable {
    let entry: [Entry]
}
