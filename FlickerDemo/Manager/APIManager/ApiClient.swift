//
//  ApiClient.swift
//  FlickerDemo
//
//  Created by Ravi Tailor on 02/07/18.
//  Copyright © 2018 Ravi Tailor. All rights reserved.
//

import Foundation

struct ApiClient : ApiRequest {
    
    let urlSession : URLSession
    
    init(sessionConfiguration:URLSessionConfiguration,queue:OperationQueue?) {
        self.urlSession = URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: queue)
    }
    
    func makeRequest(request: ApiUrlRequest, onSuccess: @escaping (ApiResponse) -> Void, onFail: @escaping (Error) -> Void) -> URLSessionDataTask? {
        
        let dataTask = self.urlSession.dataTask(with: request.urlRequest) { (data, response, error) in
            guard let httpUrlResponse = response as? HTTPURLResponse else {
                onFail(ApiError.requestError(error: error!, des: "Invalid Response"))
                return
            }
            let successRange = 200 ... 299
            if successRange.contains(httpUrlResponse.statusCode) {
                onSuccess(ApiResponse(data: data, response: httpUrlResponse))
            }else {
                onFail(ApiError.responseError(data: data!, response: httpUrlResponse))
            }
        }
        dataTask.resume()
        
        return dataTask
    }
}
