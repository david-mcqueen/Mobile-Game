import Foundation

class MainScene: CCNode {
    
    //MARK:- SpriteBuilder Objects

    weak var hero: CCSprite!;
    weak var background: CCNode!;
    
    //MARK:- Game variables
    var backgroundWidth: CGFloat!;
    var backgroundWidthHalf: CGFloat!;
    
    //MARK:- Game constants / Settings
    let verticalImpulse: CGFloat = 1500;
    let horizontalImpulse: CGFloat = 200;
    let scrollSpeed: CGFloat = 150;
    

    func didLoadFromCCB() {
        userInteractionEnabled = true;
        backgroundWidth = background.contentSize.width;
        backgroundWidthHalf = backgroundWidth/2;
    }
    
    override func update(delta: CCTime){
        
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        var touchLocation = touch.locationInNode(self);
        println(touchLocation);
        println(background.contentSize.width/2);
        if (touchLocation.x < backgroundWidthHalf){
            //Move left
            hero.physicsBody.applyImpulse(ccp(-horizontalImpulse, verticalImpulse)); //This differs depending on the size (mass) of the object
            
        }else{
            //move right
            hero.physicsBody.applyImpulse(ccp(horizontalImpulse, verticalImpulse)); //This differs depending on the size (mass) of the object
        }
        
    }
    
}
