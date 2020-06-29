//
//  FeedResult.swift
//  AppStoreAPI
//
//  Created by Nikita Gundorin on 29.06.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

struct FeedResult: Decodable {
    let name: String
    let artistName: String
    let artworkUrl100: String
}
