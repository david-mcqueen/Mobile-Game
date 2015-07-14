import Foundation

class MainScene: CCNode, CCPhysicsCollisionDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagePicker: UIImagePickerController!
    
    
    func play(){
        println("Play pressed");
        var gamePlayScene: CCScene = CCBReader.loadAsScene("GamePlay");
        CCDirector.sharedDirector().replaceScene(gamePlayScene);
    }
    
    
    func camera(){
        //Open the camera, take a photo of the user, save the image, and add as the hero image
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        imagePicker.allowsEditing = true;
        imagePicker.cameraCaptureMode = .Photo;
      
        var cameraOverlayView: UIView!;
        
        imagePicker.cameraOverlayView = CameraOverlayView(frame: UIViewController().view.bounds)
        /*
            Access the Library
            imagePicker.sourceType = .PhotoLibrary
        
            OR
        
            imagePicker.sourceType = .SavedPhotosAlbum
        
        
            OR access the camera
        
            imagePicker.sourceType = .Camera
            imagePicker.cameraCaptureMode = .Photo;
        */
        
        
        
        CCDirector.sharedDirector().presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
//        if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true){
//            if paths.count > 0 {
//                if let dirPath = paths[0] as? String {
//                    let readPath = dirPath.stringByAppendingPathComponent("Image.png")
////                    let image = UIImage(named: readPath)
//                    let writePath = dirPath.stringByAppendingPathComponent("Image2.png")
////                    UIImagePNGRepresentation(image).writeToFile(writePath, atomically: true)
//                   
//                }
//            }
//            
//        }
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil) //Save the image to camera roll
        
        // Save.image("myImageKey", image)
        Save.image("myImageKey", image);
        
    }
    
    
    func toDo(){
        
        
        /*
        **  Allow the user to select a photo from the library
        **  Save the photo to the users photo stream, if they have take the photo with camera
        **  Save the photo to internal app memory, so that it can be used for the sprite
        **  user not allowing access to the camera
        **
        */
    }
    
}
