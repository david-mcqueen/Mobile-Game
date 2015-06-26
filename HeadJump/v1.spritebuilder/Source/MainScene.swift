import Foundation

class MainScene: CCNode, CCPhysicsCollisionDelegate {
    
    //MARK:- SpriteBuilder Objects
    weak var hero: CCSprite!;
    weak var background: CCNode!;
    weak var gamePhysicsNode: CCPhysicsNode!;
    weak var newPlatform: CCSprite!;
    weak var platformLayer : CCNode!;
    
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
    
    //MARK:- Game variables
    var platforms: [NewPlatform] = [];
    var lastPlatformPosition: CGFloat = 280;
    var currentJumps: Int = 0;
    

    func didLoadFromCCB() {
        userInteractionEnabled = true;
        backgroundWidth = background.contentSize.width;
        backgroundWidthHalf = backgroundWidth/2;
        backgroundHeight = background.contentSize.height;
        newPlatformTopArea = (UInt32)(backgroundHeight * newPlatformHeight);
        newPlatformMinHeight = (UInt32)(backgroundHeight * (1 - newPlatformHeight));
        
        
        gamePhysicsNode.collisionDelegate = self;
        gamePhysicsNode.debugDraw = false; //TODO:- Remove Debug
        
        spawnNewPlatform();
        spawnNewPlatform();
    }
    
    override func update(delta: CCTime){
        let velocityY = clampf(Float(hero.physicsBody.velocity.y), -Float(CGFloat.max), maxVerticalVelocity);
        hero.physicsBody.velocity = ccp(hero.physicsBody.velocity.x, CGFloat(velocityY));
        
        
        for platform in platforms.reverse(){
            platform.position = ccp(platform.position.x + blockMoveSpeed * CGFloat(delta) * (platform.MoveRight_Left ? -1 : 1), platform.position.y);
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
        
        newPlatform.physicsBody.collisionType = "platform";
        platformLayer.addChild(newPlatform);
        platforms.append(newPlatform);
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
