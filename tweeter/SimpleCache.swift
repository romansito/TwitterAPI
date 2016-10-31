//
//  SimpleCache.swift
//  tweeter
//
//  Created by Roman Salazar on 10/31/16.
//  Copyright © 2016 Roman Salazar. All rights reserved.
//

import UIKit

class SimpleCache {
    static let share = SimpleCache()
    
    private var cache = [String : UIImage]()
    private let capacity = 100 // Keep 100 recent images.
    
    func image(key: String) -> UIImage? {
        return self.cache[key]
    }
    
    func setImage(image: UIImage, key: String) {
        //Remove last object to keep our simple cache == capacity.
        if self.cache.count >= capacity {
            guard let key = Array(self.cache.keys).last else {return}
            self.cache[key] = nil
        }
        // Set image for key (URL String)
        self.cache[key] = image
    }
    
}
