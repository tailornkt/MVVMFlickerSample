//
//  ApiCacheManager.swift
//  FlickerDemo
//
//  Created by Ravi Tailor on 02/07/18.
//  Copyright © 2018 Ravi Tailor. All rights reserved.
//

import Foundation

struct ApiCacheManager {
    static let cacheManager: NSCache<NSString, NSData> = {
        let nsCache = NSCache<NSString, NSData>()
        nsCache.name = "FlickerImageCache"
        nsCache.countLimit = 1000
        nsCache.totalCostLimit = 5*1024*1024
        return nsCache
    }()
}
