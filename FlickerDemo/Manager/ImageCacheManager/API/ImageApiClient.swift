//
//  ImageApiClient.swift
//  FlickerDemo
//
//  Created by Ravi Tailor on 02/07/18.
//  Copyright © 2018 Ravi Tailor. All rights reserved.
//

import Foundation
import UIKit

enum Result<T> {
    case success(T)
    case failure(T)
}

struct ImageApiClient {
    
    var apiClient : ApiClient?
    
    init(apiClient:ApiClient) {
        self.apiClient = apiClient
    }
    
    func getImageFromUrl(url:String,onSuccess:@escaping (_ result : Result<Any>) -> Void) -> URLSessionDataTask? {
        let imageApiRequest = ImageUrlRequest(url: url)
        let dataType = self.apiClient?.makeRequest(request: imageApiRequest, onSuccess: { (response) in
            
            guard let data = response.data, let image = UIImage.init(data: data) else {
                return
            }
            ImageCache.sharedNSCache.setObject(image, forKey: url as NSString)
            DispatchQueue.main.async {
                onSuccess(.success(image))
            }
        }, onFail: { (error) in
            onSuccess(.failure(error))
        })
        return dataType
    }
}
