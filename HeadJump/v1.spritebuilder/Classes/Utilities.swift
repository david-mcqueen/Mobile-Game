//
//  Utilities.swift
//  v1
//
//  Created by David McQueen on 06/07/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
class Save {
    class func image(key:String, _ value:UIImage) {
        NSUserDefaults.standardUserDefaults().setObject(UIImagePNGRepresentation(value), forKey: key)
    }
}

class Load {
    class func image(key:String) -> UIImage! {
        return UIImage(data: ( NSUserDefaults.standardUserDefaults().objectForKey(key) as! NSData))!   // Swift 1.2 "as!" to use it with Xcode 6.1.1 change it to "as"
    }
}