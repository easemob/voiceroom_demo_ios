//
//  VRUserProfileViewController.swift
//  VoiceRoomBaseUIKit
//
//  Created by 朱继超 on 2022/8/25.
//

import UIKit
import ZSwiftBaseLib

public final class VRUserProfileViewController: VRBaseViewController {
    
    var avatarChange: (() -> ())?
    
    @UserDefault("VoiceRoomUserName", defaultValue: "") var userName
    
    @UserDefault("VoiceRoomUserAvatar", defaultValue: "") var userAvatar
        
    lazy var background: UIImageView = {
        UIImageView(frame: self.view.frame).image(UIImage("roomList")!)
    }()
    
    lazy var userInfo: VRUserInfoView = {
        VRUserInfoView(frame: CGRect(x: 20, y: ZNavgationHeight+10, width: ScreenWidth-40, height: (110/335.0)*(ScreenWidth - 40))).cornerRadius(10).isUserInteractionEnabled(true)
    }()
    
    lazy var disclaimerView: VoiceRoomDisclaimerView = {
        VoiceRoomDisclaimerView(frame: CGRect(x: 20, y: self.userInfo.frame.maxY+20, width: ScreenWidth-40, height: 80)).cornerRadius(10)
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubViews([self.background,self.userInfo,self.disclaimerView])
        self.view.bringSubviewToFront(self.navigation)
        self.navigation.title.text = LanguageManager.localValue(key: "Profile")
        self.disclaimerView.tapClosure = { [weak self] in
            self?.pushDisclaimer()
        }
        self.userInfo.editFinished = { [weak self] in
            guard let `self` = self else { return }
            if self.userName != $0,!$0.isEmpty {
                self.changeUserName(userName: $0)
            }
        }
        self.userInfo.changeClosure = { [weak self] in
            self?.showAlert()
        }
    }

}

extension VRUserProfileViewController {
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func pushDisclaimer() {
        self.navigationController?.pushViewController(VRDisclaimerViewController(), animated: true)
    }
    
    private func showAlert() {
        self.endEdit()
        let avatar = VRAvatarChooseViewController(collectionViewLayout: UICollectionViewLayout())
        let tmp = VoiceRoomUserView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 535),controllers: [avatar],titles: [LanguageManager.localValue(key: "Change Profile Picture")], position: .left).cornerRadius(20, [.topLeft,.topRight], .white, 0)
        let vc = VoiceRoomAlertViewController(compent: PresentedViewComponent(contentSize: CGSize(width: ScreenWidth, height: 535)), custom: tmp)
        avatar.selectedClosure = { [weak self] in
            self?.changeUserAvatar(avatar: $0)
        }
        self.presentViewController(vc)
    }
    
    private func changeUserName(userName: String) {
        VoiceRoomBusinessRequest.shared.sendPOSTRequest(api: .login(()), params: ["deviceId":UIDevice.current.deviceUUID,"portrait":VoiceRoomUserInfo.shared.user?.portrait ?? "avatar1","name":userName],classType:VRUser.self) { [weak self] user, error in
            if error == nil {
                self?.userName = userName
                self?.endEdit()
                VoiceRoomUserInfo.shared.user = user
                VoiceRoomBusinessRequest.shared.userToken = user?.authorization ?? ""
                self?.userInfo.userName.text = user?.name ?? ""
                self?.view.makeToast("Change success!".localized())
            } else {
                self?.view.makeToast("\(error?.localizedDescription ?? "")")
            }
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEdit()
    }
    
    private func endEdit() {
        self.view.endEditing(true)
        self.userInfo.endEditing(true)
        self.userInfo.userName.isEnabled = false
    }
    
    private func changeUserAvatar(avatar: String) {
        VoiceRoomBusinessRequest.shared.sendPOSTRequest(api: .login(()), params: ["deviceId":UIDevice.current.deviceUUID,"portrait":avatar,"name":VoiceRoomUserInfo.shared.user?.name ?? "1238"],classType:VRUser.self) { [weak self] user, error in
            if error == nil {
                guard let `self` = self else { return }
                self.userAvatar = avatar
                VoiceRoomUserInfo.shared.user = user
                VoiceRoomBusinessRequest.shared.userToken = user?.authorization ?? ""
                self.view.makeToast("Change success!".localized())
                self.userInfo.avatar.image = UIImage(named: VoiceRoomUserInfo.shared.user?.portrait ?? self.userAvatar)
                if self.avatarChange != nil {
                    self.avatarChange!()
                }
            } else {
                self?.view.makeToast("\(error?.localizedDescription ?? "")")
            }
        }
    }
}
