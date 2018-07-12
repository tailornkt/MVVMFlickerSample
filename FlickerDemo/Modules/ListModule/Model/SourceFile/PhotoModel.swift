//
//  PhotoModel.swift
//  FlickerDemo
//
//  Created by Ravi Tailor on 02/07/18.
//  Copyright © 2018 Ravi Tailor. All rights reserved.
//

import Foundation

struct PhotoModel {
    
    var id: String
    var owner: String
    var secret: String
    var server: String
    var farm: Int
    var title: String
    var ispublic: Bool
    var isfriend: Bool
    var isfamily: Bool
    
    init?(json: [String : Any]?)  {
        guard let id = json?["id"] as? String,
            let owner = json?["owner"] as? String,
            let secret = json?["secret"] as? String,
            let server = json?["server"] as? String,
            let title = json?["title"] as? String,
            let ispublic = json?["ispublic"] as? Bool,
            let isfriend = json?["isfriend"] as? Bool,
            let isfamily = json?["isfamily"] as? Bool,
            let farm = json?["farm"] as? Int else {
                return nil
        }
        
        
        self.id = id
        self.owner = owner
        self.secret = secret
        self.server = server
        self.farm = farm
        self.title = title
        self.ispublic = ispublic
        self.isfriend = isfriend
        self.isfamily = isfamily
        
    }
}
