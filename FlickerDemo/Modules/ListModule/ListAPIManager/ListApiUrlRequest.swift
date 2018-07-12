//
//  ListApiUrlRequest.swift
//  FlickerDemo
//
//  Created by Ravi Tailor on 02/07/18.
//  Copyright © 2018 Ravi Tailor. All rights reserved.
//

import Foundation
struct ListApiUrlRequest : ApiUrlRequest {
    
    var searchText : String?
    var pageNumber : Int?
    
    init(_ searchText:String,pageNumber:Int) {
        self.searchText = searchText
        self.pageNumber = pageNumber
    }
    
    let KFlickerPhotosSearchEndpoint                                = "flickr.photos.search"
    
    var urlRequest: URLRequest {
        let pageNumber = String(describing: self.pageNumber!)
        let limit = String(describing: KFlickerPageLimit)
        let searchPerPage = "&text=" + self.searchText! + "&per_page=" + limit + "&page=" + pageNumber
        let apiEndPoint = kFlickerApiBaseURL + "?method=" + KFlickerPhotosSearchEndpoint
        let urlString = apiEndPoint + "&api_key=" + KFlickeryAPIKey + "&format=json&nojsoncallback=2&safe_search=1" + searchPerPage
        print(urlString)
        let url: URL! = URL(string: urlString)
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.httpMethod = "GET"
        
        return request
    }
}
