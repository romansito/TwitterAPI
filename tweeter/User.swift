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
    let description: String?
    let followersCount: Int
    let friendsCount: Int
    let backgroundImage: String
    
    init?(json: [String : Any]) {
        if let name = json["name"] as? String, let imageString = json["profile_image_url_https"] as? String, let followersCount = json["followers_count"] as? Int, let friendsCount =  json["friends_count"] as? Int, let backgroundImageString = json["profile_background_image_url_https"] as? String {
            
            self.name = name
            self.profileImageUrlString = imageString
            self.location = json["location"] as? String
            self.description = json["description"] as? String
            self.followersCount = followersCount
            self.friendsCount = friendsCount
            self.backgroundImage = backgroundImageString
            
        } else {
            return nil
        }
    }
}
