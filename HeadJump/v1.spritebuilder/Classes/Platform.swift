//
//  Platform.swift
//  v1
//
//  Created by David McQueen on 24/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

public class Platform: CCNode{
    var platform: CCNode!;
    
    func didLoadFromCCB(){
        platform.physicsBody.sensor = true;
    }
}
