//
//  GamePlay.swift
//  v1
//
//  Created by David McQueen on 06/07/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//
import Foundation

class GamePlay: CCNode, CCPhysicsCollisionDelegate {
    
   //MARK:- SpriteBuilder Objects
   weak var hero: CCSprite!;
   weak var background: CCNode!;
   weak var background2: CCNode!;
   weak var gamePhysicsNode: CCPhysicsNode!;
   weak var newPlatform: CCSprite!;
   weak var platformLayer : CCNode!;
   weak var contentNode: CCNode!
   weak var backgroundGround: CCNode!;
   weak var heightLabel:CCLabelTTF!;

   //MARK:- Device constants
   var backgroundWidth: CGFloat!;
   var backgroundWidthHalf: CGFloat!;
   var backgroundHeight: CGFloat!;

   //MARK:- Game constants / Settings
   let verticalImpulse: CGFloat = 1500;
   let horizontalImpulse: CGFloat = 200;
   let blockMoveSpeed: CGFloat = 30;
   let maxVerticalVelocity: Float = 200;
   let newPlatformHeight: CGFloat = 0.6; //The top % that a new platform can be generated in
   let maxJumps: Int = 300; //The # of jumps before needing to land on a platform
   let platformWidth: CGFloat = 200;
   let platformHeight: CGFloat = 40;
   let firstPlatformPosition : CGFloat = 280;
   let distanceBetweenPlatforms : CGFloat = 160;
   var newPlatformMinHeight: UInt32!; //The min height a new platform can appear
   var newPlatformTopArea: UInt32!;
   let distanceFromEdgeToTriggerNewPlatform = 75;
   let playerDistanceFromCameraBottom: CGFloat = 0.3; //The % distance of screen height from bottom
   var playerHeightPosCamera: CGFloat!;
   var platformMoveSpeed = 15.0;

   //MARK:- Game variables
   var platforms: [NewPlatform] = [];
   var lastPlatformPosition: CGFloat = 280;
   var currentJumps: Int = 0;
   var lastPlayerHeight: CGFloat = 0.0;
   var maxScore: CGFloat = 0.0;
   var heightAboveGround: CGFloat = 0;

    func didLoadFromCCB() {
        userInteractionEnabled = true;
        backgroundWidth = background.contentSize.width;
        backgroundWidthHalf = backgroundWidth/2;
        backgroundHeight = background.contentSize.height;
        newPlatformTopArea = (UInt32)(backgroundHeight * newPlatformHeight);
        newPlatformMinHeight = (UInt32)(backgroundHeight * (1 - newPlatformHeight));
        playerHeightPosCamera = backgroundHeight * playerDistanceFromCameraBottom;

        gamePhysicsNode.collisionDelegate = self;
        gamePhysicsNode.debugDraw = false; //TODO:- Remove Debug

        spawnNewPlatform();
        spawnNewPlatform();
        
        var myLoadedUIImage: UIImage = Load.image("myImageKey");
        imageWithImage(&myLoadedUIImage, i_width: hero.spriteFrame.rect.width);
        println("Sprite width: \(hero.spriteFrame.rect.width)");
        println("Image width: \(myLoadedUIImage.size.width)");
        
//
//        var frame = CCSpriteFrame(texture: myLoadedUIImage, rectInPixels: hero.spriteFrame.rect, rotated: false, offset: 0, originalSize: 0);
////        CCSpriteFrame(imageNamed: myLoadedUIImage) as CCSpriteFrame
//        hero.spriteFrame = frame;
//        
        
        var newTexture = CCTexture(CGImage: myLoadedUIImage.CGImage, contentScale: 1.0)
        var frame = CCSpriteFrame(
            texture: newTexture,
            rectInPixels: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: myLoadedUIImage.size),
            rotated: false,
            offset: CGPoint(x: 0.0, y: 0.0),
            originalSize: myLoadedUIImage.size
        );
    
        
            hero.spriteFrame = frame;
    }
    
    func imageWithImage(inout sourceImage: UIImage, i_width: CGFloat){
        var oldWidth: CGFloat = sourceImage.size.width;
        var scaleFactor: CGFloat = i_width / oldWidth;
        
        var newHeight: CGFloat = sourceImage.size.height * scaleFactor;
        var newWidth: CGFloat = oldWidth * scaleFactor;
        
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
        sourceImage.drawInRect(CGRectMake(0, 0, newWidth, newHeight));
        
        sourceImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }


    //Updated when Physics updates
    override func fixedUpdate(delta: CCTime) {
        heightAboveGround = gamePhysicsNode.convertToWorldSpace(hero.position).y - hero.contentSize.height;

//        println("Ground \(gamePhysicsNode.convertToWorldSpace(backgroundGround.position).y)")
//        println("Hero  \(gamePhysicsNode.convertToWorldSpace(hero.position).y)");
        heightLabel.string = String(Int(heightAboveGround));

        if (heightAboveGround > lastPlayerHeight){
            var change: CGFloat = heightAboveGround - lastPlayerHeight;
            lastPlayerHeight = heightAboveGround;
            println(heightAboveGround);

            println(change)
//            var bg1Pos: CGPoint = background.position;
//            var bg2Pos: CGPoint = background2.position;
//            bg1Pos.y -= change;
//            bg2Pos.y -= change;
//
//            if (bg1Pos.y < 0){
//                bg1Pos.y += background.contentSize.height;
//                bg2Pos.y += background2.contentSize.height;
//            }
//
//            bg1Pos.y = CGFloat(Int(bg1Pos.y));
//            bg2Pos.y = CGFloat(Int(bg2Pos.y));
//
//            background.position = bg1Pos;
//            background2.position = bg2Pos;

            for platform in platforms.reverse(){
                platform.position.y -= change;
            }
////
//            if (hero.position.y > 200){
//                hero.position.y = 200;
//            }

//            backgroundGround.position.y -= change;

        }

//        var heightChange = CGFloat(Int(hero.position.y)) - lastPlayerHeight;
//        var heightToMove:CGFloat  = 0;
//        heightLabel.string = String(Int(backgroundGround.position.y * -1));
//
//        //Only move the camera if the player has gone upwards
//        if heightChange > 0{
//            lastPlayerHeight = hero.position.y;
//            heightToMove = heightChange ;
//            println(heightToMove);
//            var bg1Pos: CGPoint = background.position;
//            var bg2Pos: CGPoint = background2.position;
//            bg1Pos.y -= heightToMove;
//            bg2Pos.y -= heightToMove;
//
//            if (bg1Pos.y < 0){
//                bg1Pos.y += background.contentSize.height;
//                bg2Pos.y += background2.contentSize.height;
//            }
//
//            bg1Pos.y = CGFloat(Int(bg1Pos.y));
//            bg2Pos.y = CGFloat(Int(bg2Pos.y));
//
//            background.position = bg1Pos;
//            background2.position = bg2Pos;
//
//
//            backgroundGround.position.y = backgroundGround.position.y - heightToMove;
//            for platform in platforms.reverse(){
//                platform.position.y = platform.position.y - heightToMove;
//            }
//            hero.position.y -= heightToMove;
//            println("Hero position \(hero.position.y)");
//
//            maxScore = hero.position.y + backgroundGround.position.y;
//
//        }
    }


    override func update(delta: CCTime){

        let velocityY = clampf(Float(hero.physicsBody.velocity.y), -Float(CGFloat.max), maxVerticalVelocity);
        hero.physicsBody.velocity = ccp(hero.physicsBody.velocity.x, CGFloat(velocityY));



        for platform in platforms.reverse(){
            let platformWorldPosition = gamePhysicsNode.convertToWorldSpace(platform.position);
            let platformScreenPosition = convertToNodeSpace(platformWorldPosition);


            //obstacle nearly complete its move across the screen?
            if ((platformScreenPosition.x < -75 && platform.MoveRight_Left)
                || (platformScreenPosition.x > backgroundWidth - 75) && !platform.MoveRight_Left){

                    if (!platform.PlatformDead){
                        //Generate a new platform when near the edge of the screen
                        spawnNewPlatform();

                        //Mark so we dont create another new platform
                        platform.PlatformDead = true;
                    }

                    //Only remove when off the screen
                    if ((platformScreenPosition.x < -platformWidth && platform.MoveRight_Left)
                        || (platformScreenPosition.x > backgroundWidth + platformWidth) && !platform.MoveRight_Left){
                        platform.removeFromParent();
                        platforms.removeAtIndex(find(platforms, platform)!);
                    }
            }
        }
    }

    func spawnNewPlatform() {
        println("New Platform");
        var prevPlatformPos = firstPlatformPosition;
        if (platforms.count > 0){
            prevPlatformPos = platforms.last!.position.x;
        }

        //create and add a new obstacle

        var moveRight_Left = (generateRandomNumber(100) % 2 == 0) ? true : false;
        let newPlatform: NewPlatform!

        if (moveRight_Left){
            newPlatform = CCBReader.load("NewPlatform-Left") as! NewPlatform;
        }else{
            newPlatform = CCBReader.load("NewPlatform") as! NewPlatform;
        }


        resizeSprite(newPlatform, width: platformWidth, height: platformHeight);
        generateRandomPlatformPosition(newPlatform, Right_Left: moveRight_Left);

        var positionTo = (newPlatform.MoveRight_Left ? -platformWidth : backgroundWidth + platformWidth);
        var repositionCamera =  CCActionMoveTo(duration: platformMoveSpeed, position:  ccp(positionTo, newPlatform.position.y));
        newPlatform.runAction(repositionCamera);
        newPlatform.physicsBody.collisionType = "platform";
        platformLayer.addChild(newPlatform);
        platforms.append(newPlatform);
        println(newPlatform.position.y);
    }

    //Returns a random number upto the maxNumber
    func generateRandomNumber(maxNumber: UInt32)->UInt32{
        let randomPrecision: UInt32 = maxNumber;
        return(arc4random_uniform(randomPrecision));
    }

    func generateRandomPlatformPosition(sprite: NewPlatform, Right_Left: Bool){
        var currentPlayerHeight: CGFloat = 200;
        let randomHeight = arc4random_uniform(newPlatformTopArea) + newPlatformMinHeight;

        sprite.MoveRight_Left = Right_Left;

        let yPos = CGFloat(randomHeight);

        let xPos: CGFloat = sprite.MoveRight_Left ? backgroundWidth + platformWidth : -platformWidth;
        sprite.position = ccp(xPos, yPos);
    }



    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero: CCNode!, platform: CCNode!) -> Bool {

        if(hero.position.y > platform.position.y){
            //If the hero is already above the object, collide

            currentJumps = 0; //Reset the jump counter
            return true;
        }else{
            //Else let the hero pass 'through' the object
            return false;
        }
    }


    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        var touchLocation = touch.locationInNode(self);
        //TODO:- Should the user be able to jump straight up?
        
        if (currentJumps < maxJumps){
            if (touchLocation.x < backgroundWidthHalf){
                //Move left
                hero.physicsBody.applyImpulse(ccp(-horizontalImpulse, verticalImpulse)); //This differs depending on the size (mass) of the object
            }else{
                //move right
                hero.physicsBody.applyImpulse(ccp(horizontalImpulse, verticalImpulse)); //This differs depending on the size (mass) of the object
            }
            currentJumps++;
        }else{
            //Animation for the player not being able to fly any more?
        }
        
//        var frame = CCSpriteFrame(imageNamed: "Resources/Dave_Rotated.png") as CCSpriteFrame
//        hero.spriteFrame = frame;
        
        
    }
    
    
    func resizeSprite(sprite: NewPlatform, width: CGFloat, height: CGFloat){
        sprite.scaleX = (Float)(width / sprite.contentSize.width);
        sprite.scaleY = (Float)(height / sprite.contentSize.height);
    }
    
}
