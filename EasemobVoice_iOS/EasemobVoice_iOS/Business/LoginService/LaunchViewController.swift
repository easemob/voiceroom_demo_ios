//
//  LauchViewController.swift
//  EasemobVoice_iOS
//
//  Created by CP on 2022/9/6.
//

import UIKit
import ZSwiftBaseLib
import ProgressHUD
import KakaJSON

final class LaunchViewController: UIViewController {
    
    @UserDefault("VoiceRoomFirstLaunch", defaultValue: false) var first
    
    @UserDefault("VoiceRoomUserName", defaultValue: "") var userName
    
    @UserDefault("VoiceRoomUserAvatar", defaultValue: "") var userAvatar
    
    @UserDefault("EaseMobVoiceChatRoomUser",defaultValue: Dictionary<String,Any>()) var userData
    
    var name: String {
        var firstName = ["李","王","张","刘","陈","杨","赵","黄","周","吴","徐","孙","胡","朱","高","林","何","郭","马","罗"]
        var lastName = ["小明","小虎","小芳","小红","小雨","小雪","小鹏","小双","小彤","小晗","阿花","阿杰","阿鹏","阿飞","阿青","阿永","阿超","阿伟","阿信","阿华"]
        if NSLocale.preferredLanguages.first!.hasPrefix("en") {
            firstName = ["James","Robert","John","Michael","David","William","Richard","Joseph","Thomas","Charles","Mary","Patricia","Jennifer","Linda","Elizabeth","Barbara","Susan","Jessica","Sarah","Karen"]
            lastName = [" Smith"," Johnson"," Brown"," Jones"," Garcia"," Miller"," Davis"," Rodriguez"," Martinez"," Hernandez"," Lopez"," Gonzalez"," Wilson"," Anderson"," Taylor"," Moore"," Jackson"," Martin"," Lee"," Perez"]
        }
        return (firstName.randomElement() ?? "") + (lastName.randomElement() ?? "")
    }
    
    var avatars: [String] {
        ["avatar1","avatar2","avatar3","avatar4","avatar5","avatar6","avatar7","avatar8","avatar9","avatar10","avatar11","avatar12","avatar13","avatar14","avatar15","avatar16","avatar17","avatar18"]
    }
    
    lazy var background: UIImageView = {
        UIImageView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)).image(UIImage(named: "roomList")!).contentMode(.scaleAspectFill)
    }()
    
    lazy var icon: UIImageView = {
        UIImageView(frame: CGRect(x: ScreenWidth/2.0-60, y: 221, width: 120, height: 120)).image(UIImage(named: "Easechat_icon")!)
    }()
    
    lazy var appName: UIImageView = {
        UIImageView(frame: CGRect(x: 72.5, y: self.icon.frame.maxY+13, width: ScreenWidth - 145, height: 35)).image(UIImage(named: "easemobchatroom")!).contentMode(.scaleAspectFit)
    }()
    
    lazy var cryptRight: UILabel = {
        UILabel(frame: CGRect(x: 20, y: ScreenHeight - 80, width: ScreenWidth - 40, height: 20)).font(.systemFont(ofSize: 13, weight: .regular)).text("Powered by Easemob").textColor(UIColor(0x6C7192)).textAlignment(.center)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        VoiceRoomUserInfo.shared.user = model(from: self.userData, VRUser.self)
        self.view.addSubViews([self.background,self.icon,self.appName,self.cryptRight])
        self.perform(#selector(entryHome), with: nil, afterDelay: 1)
    }
    
}

extension LaunchViewController {

    @objc func entryHome() {
        let vc = VRRoomsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showFailed() {
        let alert = VoiceRoomApplyAlert(frame: CGRect(x: 35, y: 0, width: ScreenWidth-70, height: (205/375.0)*ScreenWidth),content: "Login failed,Please retry.",cancel: "Cancel",confirm: "Confirm",position: .center).backgroundColor(.white).cornerRadius(20)
        var component = PresentedViewComponent(contentSize: CGSize(width: ScreenWidth, height: (205/375.0)*ScreenWidth))
        component.destination = .center
        let vc = VoiceRoomAlertViewController(compent: component, custom: alert)
        alert.actionEvents = { [weak self] in
            if $0 == 31 {
            }
            vc.dismiss(animated: true)
        }
        self.presentViewController(vc)
    }
}
