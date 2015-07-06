import Foundation

class MainScene: CCNode, CCPhysicsCollisionDelegate {
    
    func play(){
        println("Play pressed");
        var gamePlayScene: CCScene = CCBReader.loadAsScene("GamePlay");
        CCDirector.sharedDirector().replaceScene(gamePlayScene);
    }
    
}
