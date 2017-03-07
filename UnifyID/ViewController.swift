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
    let cameraManager = CameraManager()
    let keychain = Keychain(service: "com.UnifyID.facial.UnifyID")
    var time: Timer = Timer()
    var timeLimit: Int = 0
    
    @IBOutlet weak var frontCamera: UIButton!
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var displayView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var localImage: Data? = nil
        do{
            try localImage = keychain[data: "photo"]!
        } catch let error{
            print("error: \(error)")
        }
        if localImage != nil{
        displayView.image = UIImage(data: localImage!, scale: 1.0)
        }
        cameraManager.cameraDevice = .front
        cameraManager.cameraOutputMode = .stillImage
        cameraManager.cameraOutputQuality = .medium
        cameraManager.addPreviewLayerToView(self.cameraView)
        cameraManager.writeFilesToPhoneLibrary = false
        frontCamera.addTarget(self, action: #selector(self.getPictures), for: .touchUpInside)
               
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPictures(){
        print("Here")

        time = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.takePhotos), userInfo: nil, repeats: true)
        
    }
    
    func takePhotos()
    {
        //Goes up to 9, due to the selector queuing up another instance of takePhotos, thus in total 10 are run.
        if self.timeLimit == 9
        {
            time.invalidate()
            self.timeLimit = 0
            displayPhoto()
        }
        else
        {
        cameraManager.capturePictureWithCompletion({ (image, error) -> Void in
                //print("photo taken")
                self.keychain[data: "photo"] = UIImagePNGRepresentation(image!)
                self.timeLimit += 1
                //print(self.timeLimit)
        })
        }
    }
    
    func displayPhoto()
    {
        displayView.image = UIImage(data:keychain[data: "photo"]!, scale: 1.0)
    }


}

