import Foundation

class MainScene: CCNode, CCPhysicsCollisionDelegate {
    
    //MARK:- SpriteBuilder Objects
    weak var hero: CCSprite!;
    weak var background: CCNode!;
    weak var gamePhysicsNode: CCPhysicsNode!;
    weak var platform: CCNode!;
    weak var newPlatform: CCSprite!;
    weak var platformLayer : CCNode!;
    
    
    //MARK:- Game variables
    var backgroundWidth: CGFloat!;
    var backgroundWidthHalf: CGFloat!;
    var platforms: [CCNode] = [];
    let firstPlatformPosition : CGFloat = 280;
    let distanceBetweenPlatforms : CGFloat = 160;
    let platformWidth: CGFloat = 100;
    let platformHeight: CGFloat = 30;
    let maxJumps: Int = 300; //The # of jumps before needing to land on a platform
    var currentJumps: Int = 0;
    
    //MARK:- Game constants / Settings
    let verticalImpulse: CGFloat = 1500;
    let horizontalImpulse: CGFloat = 200;
    let blockMoveSpeed: CGFloat = 0;
    let maxVerticalVelocity: Float = 200;
    

    func didLoadFromCCB() {
        userInteractionEnabled = true;
        backgroundWidth = background.contentSize.width;
        backgroundWidthHalf = backgroundWidth/2;
        
        
        gamePhysicsNode.collisionDelegate = self;
        gamePhysicsNode.debugDraw = false; //TODO:- Remove Debug
        
        spawnNewPlatform();
    }
    
    override func update(delta: CCTime){
        let velocityY = clampf(Float(hero.physicsBody.velocity.y), -Float(CGFloat.max), maxVerticalVelocity);
        hero.physicsBody.velocity = ccp(hero.physicsBody.velocity.x, CGFloat(velocityY));
        
        platform.position = ccp(platform.position.x + blockMoveSpeed * CGFloat(delta), platform.position.y);
        
        for platform in platforms.reverse(){
            platform.position = ccp(platform.position.x + blockMoveSpeed * CGFloat(delta), platform.position.y);
            let platformWorldPosition = gamePhysicsNode.convertToWorldSpace(platform.position);
            let platformScreenPosition = convertToNodeSpace(platformWorldPosition);
            
            //obstacle moved past the bottom of the screen?
            if (platformScreenPosition.x < -100 || platformScreenPosition.x > backgroundWidth + 100){
                println("Remove from parent")
                platform.removeFromParent();
                platforms.removeAtIndex(find(platforms, platform)!);
                
                //for each removed obstacle, add a new one
                spawnNewPlatform();
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
        
        let platform: CCSprite = CCBReader.load("Platform") as! CCSprite;
        
        platform.position = ccp(0, prevPlatformPos + distanceBetweenPlatforms);
        platform.position.x = 100;
        platform.position.y = 400;
        resizeSprite(platform, width: platformWidth, height: platformHeight);
        
        gamePhysicsNode.addChild(platform);
        platforms.append(platform);
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
    
    
    func resizeSprite(sprite: CCSprite, width: CGFloat, height: CGFloat){
        sprite.scaleX = (Float)(width / sprite.contentSize.width);
        sprite.scaleY = (Float)(height / sprite.contentSize.height);
    }
    
}
