//
//  ListApiRequestManager.swift
//  FlickerDemo
//
//  Created by Ravi Tailor on 02/07/18.
//  Copyright © 2018 Ravi Tailor. All rights reserved.
//

import Foundation

typealias FetchFlickerPhotosListOnSuccess = (_ books: Array<PhotoModel>) -> Void
typealias FetchFlickerPhotosListOnFail = (_ error: Error) -> Void

struct ListApiRequestManager  {
    var apiClient : ApiClient?
    
    init(_ client:ApiClient) {
        self.apiClient = client
    }
    
    func fetchFlickerPhotos(_ pageNumber: Int,searchText:String,onSuccess: @escaping FetchFlickerPhotosListOnSuccess,onFail: @escaping FetchFlickerPhotosListOnFail) {
        
        let apiUrlRequest = ListApiUrlRequest(searchText, pageNumber: pageNumber)
        var key : NSString = ""
        if let urlStr = apiUrlRequest.urlRequest.url?.absoluteString {
            key = NSString(string:urlStr)
        }
        if let apiResponseData = ApiCacheManager.cacheManager.object(forKey:key) {
            let data = Data(referencing: apiResponseData)
            PhotoModelParser().getModelDataArray(data, onSuccess: { (arr) in
                onSuccess(arr)
            })
        }else {
            let _ = self.apiClient?.makeRequest(request: apiUrlRequest, onSuccess: { (response) in
                if let data = response.data {
                    let nsdata = NSData(data: data)
                    ApiCacheManager.cacheManager.setObject(nsdata, forKey: key)
                }
                PhotoModelParser().getModelDataArray(response.data, onSuccess: { (arr) in
                    onSuccess(arr)
                })
            }, onFail: { (error) in
                onFail(error)
            })
        }
    }
}
