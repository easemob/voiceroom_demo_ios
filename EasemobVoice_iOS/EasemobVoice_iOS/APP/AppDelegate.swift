//
//  AppDelegate.swift
//  EasemobVoice_iOS
//
//  Created by CP on 2022/9/5.
//

import UIKit
import ZSwiftBaseLib
import KakaJSON

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    @UserDefault("EaseMobVoiceChatRoomUser",defaultValue: Dictionary<String,Any>()) var userData

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        VoiceRoomIMManager.shared?.configIM(appkey: "Your easemob app key")
        let VC = UINavigationController(rootViewController: self.userData.count > 0 ? VRRoomsViewController():LoginViewController())
        VC.isNavigationBarHidden = true
        self.window?.rootViewController = VC
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        self.archiveUser()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        NotificationCenter.default.post(name: Notification.Name("terminate"), object: nil)
        VoiceRoomIMManager.shared?.userQuitRoom(completion: nil)
        self.archiveUser()
    }
    
    func archiveUser() {
        guard let user = VoiceRoomUserInfo.shared.user else { return }
        self.userData = user.kj.JSONObject()
    }

}

