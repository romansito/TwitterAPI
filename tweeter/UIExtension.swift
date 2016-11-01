//
//  UIExtension.swift
//  tweeter
//
//  Created by Roman Salazar on 10/31/16.
//  Copyright © 2016 Roman Salazar. All rights reserved.
//

import UIKit

extension UIResponder {
    class func identifier() -> String {
        return String(describing: self)
    }
}

