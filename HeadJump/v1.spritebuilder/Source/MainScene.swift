import Foundation

class MainScene: CCNode, CCPhysicsCollisionDelegate {
    
    //MARK:- SpriteBuilder Objects
    weak var hero: CCSprite!;
    weak var background: CCNode!;
    weak var background2: CCNode!;
    weak var gamePhysicsNode: CCPhysicsNode!;
    weak var newPlatform: CCSprite!;
    weak var platformLayer : CCNode!;
    weak var contentNode: CCNode!
    
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
    let platformWidth: CGFloat = 100;
    let platformHeight: CGFloat = 30;
    let firstPlatformPosition : CGFloat = 280;
    let distanceBetweenPlatforms : CGFloat = 160;
    var newPlatformMinHeight: UInt32!; //The min height a new platform can appear
    var newPlatformTopArea: UInt32!;
    let distanceFromEdgeToTriggerNewPlatform = 75;
    let playerDistanceFromCameraBottom: CGFloat = 0.3; //The % distance of screen height from bottom
    var playerHeightPosCamera: CGFloat!;
    var platformMoveSpeed = 5.0;
    
    //MARK:- Game variables
    var platforms: [NewPlatform] = [];
    var lastPlatformPosition: CGFloat = 280;
    var currentJumps: Int = 0;
    var lastPlayerHeight: CGFloat = 0.0;
    

    func didLoadFromCCB() {
        userInteractionEnabled = true;
        backgroundWidth = background.contentSize.width;
        backgroundWidthHalf = backgroundWidth/2;
        backgroundHeight = background.contentSize.height;
        newPlatformTopArea = (UInt32)(backgroundHeight * newPlatformHeight);
        newPlatformMinHeight = (UInt32)(backgroundHeight * (1 - newPlatformHeight));
        playerHeightPosCamera = backgroundHeight * playerDistanceFromCameraBottom;
        
        gamePhysicsNode.collisionDelegate = self;
        gamePhysicsNode.debugDraw = true; //TODO:- Remove Debug
        
        spawnNewPlatform();
        spawnNewPlatform();
    }
    
    
    //Updated when Physics updates
    override func fixedUpdate(delta: CCTime) {
        
    }
    
    
    override func update(delta: CCTime){
        let velocityY = clampf(Float(hero.physicsBody.velocity.y), -Float(CGFloat.max), maxVerticalVelocity);
        hero.physicsBody.velocity = ccp(hero.physicsBody.velocity.x, CGFloat(velocityY));
        
        var heightChange = hero.position.y - lastPlayerHeight;
        var heightToMove:CGFloat  = 0;
        
        //Only move the camera if the player has done upwards
        if heightChange > 0{
            heightToMove = heightChange;
            println(heightToMove);
            var bg1Pos: CGPoint = background.position;
            var bg2Pos: CGPoint = background2.position;
            bg1Pos.y -= heightToMove;
            bg2Pos.y -= heightToMove;
            
            if (bg1Pos.y < 0){
                bg1Pos.y += background.contentSize.height;
                bg2Pos.y += background2.contentSize.height;
            }
            
            bg1Pos.y = CGFloat(Int(bg1Pos.y));
            bg2Pos.y = CGFloat(Int(bg2Pos.y));
            
            background.position = bg1Pos;
            background2.position = bg2Pos;
            
            lastPlayerHeight = hero.position.y;
            
        }
        
        for platform in platforms.reverse(){
            let platformWorldPosition = gamePhysicsNode.convertToWorldSpace(platform.position);
            let platformScreenPosition = convertToNodeSpace(platformWorldPosition);
            
            platform.position.y = platform.position.y - heightToMove;
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
                    if ((platformScreenPosition.x < -100 && platform.MoveRight_Left)
                        || (platformScreenPosition.x > backgroundWidth + 100) && !platform.MoveRight_Left){
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
        
        let newPlatform: NewPlatform = CCBReader.load("NewPlatform") as! NewPlatform;
        
        resizeSprite(newPlatform, width: platformWidth, height: platformHeight);
        generateRandomPlatformPosition(newPlatform);
        
        var positionTo = (newPlatform.MoveRight_Left ? -100 : backgroundWidth + 100);
        var repositionCamera =  CCActionMoveTo(duration: platformMoveSpeed, position:  ccp(positionTo, newPlatform.position.y));
        newPlatform.runAction(repositionCamera);
        newPlatform.physicsBody.collisionType = "platform";
        platformLayer.addChild(newPlatform);
        platforms.append(newPlatform);
        println(newPlatform.position.y);
    }
    
    func generateRandomPlatformPosition(sprite: NewPlatform){
        let randomPrecision: UInt32 = 100;
        let random = arc4random_uniform(randomPrecision);
        var currentPlayerHeight: CGFloat = 200;
        let randomHeight = arc4random_uniform(newPlatformTopArea) + newPlatformMinHeight;
        
        sprite.MoveRight_Left = (random % 2 == 0) ? true : false; //Even number move right to left
        
        let yPos = CGFloat(randomHeight);
        
        let xPos: CGFloat = sprite.MoveRight_Left ? backgroundWidth + 100 : -100;
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
        
        
    }
    
    
    func resizeSprite(sprite: NewPlatform, width: CGFloat, height: CGFloat){
        sprite.scaleX = (Float)(width / sprite.contentSize.width);
        sprite.scaleY = (Float)(height / sprite.contentSize.height);
    }
    
}
