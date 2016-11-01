//
//  User.swift
//  tweeter
//
//  Created by Roman Salazar on 10/17/16.
//  Copyright © 2016 Roman Salazar. All rights reserved.
//

import Foundation

class User {
    
    let name : String
    let profileImageUrlString : String
    let location : String?
    
    init?(json: [String : Any]) {
        if let name = json["name"] as? String, let imageString = json["profile_image_url_https"] as? String {
            
            self.name = name
            self.profileImageUrlString = imageString
            self.location = json["location"] as? String
            
        } else {
            return nil
        }
    }
}
