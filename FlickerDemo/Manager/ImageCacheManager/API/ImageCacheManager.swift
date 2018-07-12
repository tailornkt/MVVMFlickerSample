//
//  ImageCacheManager.swift
//  FlickerDemo
//
//  Created by Ravi Tailor on 02/07/18.
//  Copyright © 2018 Ravi Tailor. All rights reserved.
//

import Foundation
import UIKit

typealias IMAGE_CALLBACK = (_ image : UIImage?) -> Void

struct ImageCacheManager {
    
    static func getImageFromUrl(url: String,onSuccess : @escaping IMAGE_CALLBACK) -> URLSessionDataTask? {
        if let image = ImageCache.sharedNSCache.object(forKey: url as NSString) {
            onSuccess(image)
        }else {
            guard let url = URL(string: url) else {
                onSuccess(nil)
                return nil
            }
            
            let apiClient = ApiClient(sessionConfiguration: URLSessionConfiguration.default, queue: OperationQueue.main)
            let imageApiClient = ImageApiClient(apiClient: apiClient)
            
            let dataTask = imageApiClient.getImageFromUrl(url: url.absoluteString, onSuccess: { (result) in
                switch result {
                case .success(let image) : onSuccess(image as? UIImage)
                case .failure(let error) : print((error as? Error)?.localizedDescription)
                }
            })
            
            return dataTask
        }
        return nil
    }
}
