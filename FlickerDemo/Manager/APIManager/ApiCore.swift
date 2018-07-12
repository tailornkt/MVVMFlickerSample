//
//  ApiCore.swift
//  FlickerDemo
//
//  Created by Ravi Tailor on 02/07/18.
//  Copyright © 2018 Ravi Tailor. All rights reserved.
//

import Foundation

let kFlickerApiBaseURL                 = "https://api.flickr.com/services/rest/"

let KFlickerPageLimit                  = 10

let KFlickeryAPIKey:String             = "ab726e418794ee185dc80ea739c331e0"

enum ApiError : Error {
    case responseError(data:Data,response:HTTPURLResponse)
    case requestError(error:Error,des:String)
    case parserError(code:Int,data:Data,response:HTTPURLResponse,error:Error,des:String)
}

struct ApiResponse {
    var data : Data?
    var response : HTTPURLResponse
}

protocol ApiUrlRequest {
    var urlRequest : URLRequest {get}
}
protocol ApiRequest {
    func makeRequest(request: ApiUrlRequest,onSuccess:@escaping (_ response : ApiResponse) -> Void,onFail:@escaping (_ error: Error) -> Void) -> URLSessionDataTask?
}
