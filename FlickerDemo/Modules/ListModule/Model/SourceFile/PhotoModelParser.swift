//
//  PhotoModelParser.swift
//  FlickerDemo
//
//  Created by Ravi Tailor on 02/07/18.
//  Copyright © 2018 Ravi Tailor. All rights reserved.
//

import Foundation

protocol ModelParsingInterface {
    func getModelDataArray(_ data:Data?,onSuccess:@escaping (_ modelArr : Array<PhotoModel>) -> Void)
}

struct PhotoModelParser : ModelParsingInterface {
    func getModelDataArray(_ data: Data?, onSuccess: @escaping (Array<PhotoModel>) -> Void) {
        
        guard let jsonData = data,
            let jsonObject = try? JSONSerialization.jsonObject(with: jsonData),
            let json = jsonObject as? NSDictionary else {
                onSuccess([])
                return
        }
        if let stat = json.value(forKey: "stat") as? String,stat.lowercased() == "ok" {
            
            if let photos = json.value(forKeyPath: "photos.photo") as? Array<AnyObject> {
                var tempArr : Array<PhotoModel> = []
                for data in photos {
                    if let model =  PhotoModel(json: data as? [String : Any]) {
                        tempArr.append(model)
                    }
                }
                onSuccess(tempArr)
            }else {
                onSuccess([])
            }
        }else {
            onSuccess([])
        }
    }
}
