//
//  Feed.swift
//  AppStoreAPI
//
//  Created by Nikita Gundorin on 29.06.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

struct Feed: Decodable {
    let title: String
    let results: [FeedResult]
}
