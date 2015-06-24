import Foundation

class MainScene: CCNode, CCPhysicsCollisionDelegate {
    
    //MARK:- SpriteBuilder Objects
    weak var hero: CCSprite!;
    weak var background: CCNode!;
    weak var gamePhysicsNode: CCPhysicsNode!;
    weak var platform: CCNode!;
    weak var platformLayer : CCNode!;
    
    
    //MARK:- Game variables
    var backgroundWidth: CGFloat!;
    var backgroundWidthHalf: CGFloat!;
    var platforms: [CCNode] = [];
    let firstPlatformPosition : CGFloat = 280;
    let distanceBetweenPlatforms : CGFloat = 160;
    
    //MARK:- Game constants / Settings
    let verticalImpulse: CGFloat = 1500;
    let horizontalImpulse: CGFloat = 200;
    let blockMoveSpeed: CGFloat = 100;
    let maxVerticalVelocity: Float = 200;
    

    func didLoadFromCCB() {
        userInteractionEnabled = true;
        backgroundWidth = background.contentSize.width;
        backgroundWidthHalf = backgroundWidth/2;
        
        
        gamePhysicsNode.collisionDelegate = self;
        gamePhysicsNode.debugDraw = true; //TODO:- Remove Debug
        
        //spawnNewPlatform();
    }
    
    override func update(delta: CCTime){
        let velocityY = clampf(Float(hero.physicsBody.velocity.y), -Float(CGFloat.max), maxVerticalVelocity);
        hero.physicsBody.velocity = ccp(hero.physicsBody.velocity.x, CGFloat(velocityY));
        
        platform.position = ccp(platform.position.x + blockMoveSpeed * CGFloat(delta), platform.position.y);
        
        for platform in platforms.reverse(){
            let platformWorldPosition = gamePhysicsNode.convertToWorldSpace(platform.position);
            let platformScreenPosition = convertToNodeSpace(platformWorldPosition);
            
            //obstacle moved past the bottom of the screen?
            if (platformScreenPosition.x < (-platform.contentSize.width) || platformScreenPosition.x > (-platform.contentSize.width)){
                println("Remove from parent")
                platform.removeFromParent();
                platforms.removeAtIndex(find(platforms, platform)!);
                
                //for each removed obstacle, add a new one
                //spawnNewPlatform();
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
        let platform = CCBReader.load("platform") as! Platform;
        platform.position = ccp(0, prevPlatformPos + distanceBetweenPlatforms);
        platform.position.x = 300;
        platform.position.y = 300;
        platformLayer.addChild(platform);
        platforms.append(platform);
    }
    
    func check(delta: CCTime){
        println("check");
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero: CCNode!, platform: CCNode!) -> Bool {
        if(hero.position.y > platform.position.y){
            //If the hero is already above the object, collide
            return true;
        }else{
            //Else let the hero pass 'through' the object
            return false;
        }
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        var touchLocation = touch.locationInNode(self);
        //TODO:- Should the user be able to jump straight up?
        
        if (touchLocation.x < backgroundWidthHalf){
            //Move left
            hero.physicsBody.applyImpulse(ccp(-horizontalImpulse, verticalImpulse)); //This differs depending on the size (mass) of the object
        }else{
            //move right
            hero.physicsBody.applyImpulse(ccp(horizontalImpulse, verticalImpulse)); //This differs depending on the size (mass) of the object
        }
        
    }
    
}
