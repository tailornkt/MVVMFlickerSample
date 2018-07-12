//
//  ImageUrlRequest.swift
//  FlickerDemo
//
//  Created by Ravi Tailor on 02/07/18.
//  Copyright © 2018 Ravi Tailor. All rights reserved.
//

import Foundation

struct ImageUrlRequest : ApiUrlRequest {
    
    var imgUrl: String
    init(url: String) {
        self.imgUrl = url
    }
    var urlRequest: URLRequest  {
        var request = URLRequest(url:URL(string: self.imgUrl)!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        return request
    }
}
