//
//  Platform.swift
//  v1
//
//  Created by David McQueen on 24/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

public class NewPlatform: CCNode{
    weak var newPlane: CCNode!;
    
    var MoveRight_Left: Bool = false;
    var PlatformDead: Bool = false;
    
    func didLoadFromCCB(){
        newPlane.physicsBody.sensor = true;
    }
}
