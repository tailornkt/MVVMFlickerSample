//
//  ImageCache.swift
//  FlickerDemo
//
//  Created by Ravi Tailor on 02/07/18.
//  Copyright © 2018 Ravi Tailor. All rights reserved.
//

import Foundation
import UIKit

struct ImageCache {
    static let sharedNSCache: NSCache<NSString, UIImage> = {
        let nsCache = NSCache<NSString, UIImage>()
        nsCache.name = "FlickerImageCache"
        nsCache.countLimit = 1000
        nsCache.totalCostLimit = 5*1024*1024
        return nsCache
    }()
}
