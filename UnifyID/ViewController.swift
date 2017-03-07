//
//  ViewController.swift
//  UnifyID
//
//  Created by Daniel Isserow on 3/7/17.
//  Copyright © 2017 Daniel Isserow. All rights reserved.
//

import UIKit
import CameraManager
import KeychainAccess


class ViewController: UIViewController {
    
    //Initial variables set for the camera and keychain to be accessible throughout the scope
    let cameraManager = CameraManager()
    let keychain = Keychain(service: "com.UnifyID.facial.UnifyID")
    var time: Timer = Timer()
    var timeLimit: Int = 0
    
    
    @IBOutlet weak var frontCamera: UIButton!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var displayView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //Grab the First Image that was Saved to showcase retrieving from keychain
        var localImage: Data? = nil
        if let test = keychain[data: "photo1"]
        {
            localImage = test
        }
        
        //Using an optional value so we know what to test for and if it exists set the UIImageView to localImage
        if localImage != nil{
        displayView.image = UIImage(data: localImage!, scale: 1.0)
        }
        
        //Settings for the cameraManager Used. Don't Save to library since we are savnig to keychain
        cameraManager.cameraDevice = .front
        cameraManager.cameraOutputMode = .stillImage
        cameraManager.cameraOutputQuality = .medium
        cameraManager.addPreviewLayerToView(self.cameraView)
        cameraManager.writeFilesToPhoneLibrary = false
        
        //Add event for getting the Pictures
        frontCamera.addTarget(self, action: #selector(self.getPictures), for: .touchUpInside)
               
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
     Set up a timer which runs on 0.5 intervals set the selector of function takePhotos() which repeats until it is invalidated.
     
     */
    func getPictures(){
        
        //Resets the timeLimit which lets us run for 10 * 0.5 seconds = 5 seconds
        timeLimit = 0
        time = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.takePhotos), userInfo: nil, repeats: true)
        
    }
    
    /**
      Takes the photos using the cameraManager and using the timeLimit variable lets you take 10 photos.
     
     */
    func takePhotos()
    {
        //Goes up to 9, due to the selector queuing up another instance of takePhotos, thus in total 10 are run.
        if self.timeLimit == 9
        {
            time.invalidate()
            displayPhoto()
        }
        else
        {
        //Stores the photos in the keychain with an increasing name for each photo, this could also be stored in another data structure of data if there was to be thousands of images.
        cameraManager.capturePictureWithCompletion({ (image, error) -> Void in
                self.timeLimit += 1
                self.keychain[data: "photo\(self.timeLimit)"] = UIImagePNGRepresentation(image!)
        })
        }
    }
    
    /**
      This is called to setup the final image taken to be shown in the displayView
     */
    func displayPhoto()
    {
        displayView.image = UIImage(data:keychain[data: "photo\(self.timeLimit)"]!, scale: 1.0)
    }

}

