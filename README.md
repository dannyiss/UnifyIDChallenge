ReadMe: UnifyID iOS Challenge

Download the files and set up the pods
-  pod 'CameraManager', '~> 3.1'
-  pod 'KeychainAccess'

Install using Terminal: install pods
Then open the XCode Project using open UnifyID.xcworkspace

Build on either a Simulator or Device

Tested Devices:

iPhone 7 Plus: iOS 10.2
iPhone 7: iOS 10.2


Camera Manager is used to handle all the image side of the program.
KeychainAccess is a wrapper used to be able to store and retrieve Keychain data
easily as well as some other features that could be used such as locking files with TouchID

Further Considerations

Issues
-UI Layout Issues for smaller devices

Future Ideas
-Using an External API such as Microsoft Cognitive Services: Face API to do Face Detection and retrieve the Results.
