//
//  LoginViewController.swift
//  EasemobVoice_iOS
//
//  Created by 朱继超 on 2022/11/9.
//

import UIKit
import ZSwiftBaseLib
import KakaJSON
import ProgressHUD

final class LoginViewController: UIViewController {
    
    let regular = "^((1[1-9][0-9])|(14[5|7])|(15([0-3]|[5-9]))|(17[013678])|(18[0,5-9]))d{8}$"
    
    var code = ""
        
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
    
    lazy var appName: UILabel = {
        UILabel(frame: CGRect(x: 30, y: 187, width: ScreenWidth - 60, height: 35)).font(.systemFont(ofSize: 24, weight: .medium)).textColor(UIColor(0x009FFF)).text("Login Easemob Chat Room".localized())
    }()
    
    lazy var phoneNumber: UITextField = {
        UITextField(frame: CGRect(x: 30, y: self.appName.frame.maxY+22, width: ScreenWidth-60, height: 48)).delegate(self).tag(11).textColor(UIColor(0x3C4267)).font(.systemFont(ofSize: 18, weight: .regular)).placeholder("Mobile Number".localized()).leftView(UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 48)), .always).backgroundColor(.white).cornerRadius(24).clearButtonMode(.whileEditing)
    }()
    
    lazy var pinCode: UITextField = {
        UITextField(frame: CGRect(x: 30, y: self.phoneNumber.frame.maxY+24, width: ScreenWidth-60, height: 48)).delegate(self).tag(12).textColor(UIColor(0x3C4267)).font(.systemFont(ofSize: 18, weight: .regular)).placeholder("Verification Code".localized()).leftView(UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 48)), .always).backgroundColor(.white).cornerRadius(24)
    }()
    
    lazy var right: UIButton = {
        UIButton(type: .custom).frame(CGRect(x: 0, y: 0, width: 104, height: 48)).title("Get Code".localized(), .normal).textColor(UIColor(0x009FFF), .normal).textColor(UIColor(0x979CBB), .disabled).addTargetFor(self, action: #selector(getPinCode), for: .touchUpInside).font(.systemFont(ofSize: 14, weight: .medium)).backgroundColor(.white)
    }()
    
    lazy var login: UIButton = {
        UIButton(type: .custom).frame(CGRect(x: 30, y: self.pinCode.frame.maxY+24, width: ScreenWidth - 60, height: 48)).cornerRadius(24).title(LanguageManager.localValue(key: "Login".localized()), .normal).textColor(.white, .normal).font(.systemFont(ofSize: 16, weight: .semibold)).addTargetFor(self, action: #selector(loginAction), for: .touchUpInside).setGradient([UIColor(red: 0.13, green: 0.608, blue: 1, alpha: 1),UIColor(red: 0.204, green: 0.366, blue: 1, alpha: 1)], [CGPoint(x: 0, y: 0),CGPoint(x: 0, y: 1)])
    }()
    
    lazy var loginContainer: UIView = {
        UIView(frame: CGRect(x: 30, y: self.pinCode.frame.maxY+24, width: ScreenWidth - 60, height: 48)).backgroundColor(.white)
    }()
    
    lazy var agree: UIButton = {
        UIButton(type: .custom).frame(CGRect(x: 38, y: self.login.frame.maxY+20, width: 16, height: 16)).image("selected", .selected).image("unselected", .normal).addTargetFor(self, action: #selector(agreeAction(sender:)), for: .touchUpInside)
    }()
    
    lazy var protocolContainer: UITextView = {
        UITextView(frame: CGRect(x: self.agree.frame.maxX+8, y: self.login.frame.maxY+10, width: ScreenWidth-76-50, height: 58)).attributedText(self.protocolContent).isEditable(false).backgroundColor(.clear)
    }()
    
    var count = 60
    
    lazy var timer: GCDTimer? = {
        GCDTimerMaker.exec({
            self.timerFire()
        }, interval: 1, repeats: true)
    }()
    
    var protocolContent: NSAttributedString = NSAttributedString {
        AttributedText("By joining, you agree to our Terms of ".localized()).font(.systemFont(ofSize: 12, weight: .regular)).foregroundColor(Color(0x3C4267)).lineSpacing(5)
        Link("Service".localized(), url: URL(string: "https://www.easemob.com/terms/im")!).foregroundColor(Color(0x009FFF)).font(.systemFont(ofSize: 12, weight: .medium)).underline(.single,color: Color(0x009FFF)).lineSpacing(5)
        AttributedText(" and ".localized()).foregroundColor(Color(0x009FFF)).font(.systemFont(ofSize: 12, weight: .regular)).foregroundColor(Color(0x3C4267)).lineSpacing(5)
        Link("Privacy Policy".localized(), url: URL(string: "https://www.easemob.com/protocol")!).foregroundColor(Color(0x009FFF)).font(.systemFont(ofSize: 12, weight: .medium)).underline(.single,color: Color(0x009FFF)).lineSpacing(5)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: - you can replace request host call this.
//        VoiceRoomBusinessRequest.shared.changeHost(host: "")
        self.protocolContainer.linkTextAttributes = [.foregroundColor:UIColor(0x009FFF)]
        self.view.addSubViews([self.background,self.appName,self.phoneNumber,self.pinCode,self.loginContainer,self.login,self.agree,self.protocolContainer])
        self.fieldSetting()
        // Do any additional setup after loading the view.
        self.setContainerShadow()
    }
    
    func fieldSetting() {
        self.phoneNumber.tintColor = UIColor(0x009FFF)
        self.pinCode.tintColor = UIColor(0x009FFF)
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 104, height: 48)).backgroundColor(.white)
        rightView.addSubview(self.right)
        self.pinCode.rightView = rightView
        self.pinCode.rightViewMode = .always
        self.pinCode.keyboardType = .numberPad
        self.phoneNumber.keyboardType = .numberPad
    }
    
    func setContainerShadow() {
        self.loginContainer.layer.cornerRadius = 24
        self.loginContainer.layer.shadowRadius = 8
        self.loginContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.loginContainer.layer.shadowColor = UIColor(red: 0, green: 0.55, blue: 0.98, alpha: 0.2).cgColor
        self.loginContainer.layer.shadowOpacity = 1
    }

}

extension LoginViewController: UITextFieldDelegate {
    
    @objc func timerFire() {
        DispatchQueue.main.async {
            self.count -= 1
            if self.count <= 0 {
                self.timer?.suspend()
                self.getAgain()
            } else { self.startCountdown() }
        }
    }
    
    func getAgain() {
        self.right.isEnabled = true
        self.right.setTitle("Get Code".localized(), for: .normal)
        self.count = 60
    }
    
    func startCountdown() {
        self.right.isEnabled = false
        self.right.setTitle("Get After".localized()+"(\(self.count)s)", for: .disabled)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
    }
    
    @objc func loginAction() {
        self.view.endEditing(true)
        if self.phoneNumber.text?.count ?? 0 != 11,!(self.phoneNumber.text ?? "").z.isMatchRegular(expression: self.regular) {
            self.view.makeToast("Please enter the correct mobile number.".localized())
            return
        }
        if self.pinCode.text?.count ?? 0 != 6 {
            self.view.makeToast("Please enter verification code".localized())
            return
        }
        if !self.agree.isSelected {
            self.view.makeToast("Please confirm Service & Policy".localized())
            return
        }
        var userRandomName = "123"
        var avatar = "avatar1"
        if self.userData.count <= 0 {
            userRandomName = self.name
            avatar = self.avatars.randomElement() ?? avatar
            self.userName = userRandomName
            self.userAvatar = avatar
        } else {
            userRandomName = self.userName
            avatar = self.userAvatar
        }
        VoiceRoomBusinessRequest.shared.sendPOSTRequest(api: .login(()), params: ["deviceId":UIDevice.current.deviceUUID,"portrait":self.userAvatar,"name":self.userName,"phone":self.phoneNumber.text ?? "","verify_code":self.pinCode.text ?? ""],classType:VRUser.self) { [weak self] user, error in
            ProgressHUD.dismiss()
            if error == nil,user != nil {
                VoiceRoomUserInfo.shared.user = user
                VoiceRoomBusinessRequest.shared.userToken = user?.authorization ?? ""
                self?.entryHome()
                guard let object = user else { return }
                self?.userData = object.kj.JSONObject()
            } else {
                self?.view.makeToast("Please enter the correct mobile number.".localized())
            }
        }
    }
    
    @objc func getPinCode() {
        self.view.endEditing(true)
        if self.phoneNumber.text?.count ?? 0 != 11,!(self.phoneNumber.text ?? "").z.isMatchRegular(expression: self.regular) {
            self.view.makeToast("Please enter the correct mobile number.".localized())
            return
        }
        self.timer?.resume()
        VoiceRoomBusinessRequest.shared.sendPOSTRequest(api: .verificationCode(()), params: ["phone_number":self.phoneNumber.text ?? ""]) { result, error in
            if error == nil {
                guard let sendSuccess = result?["result"] as? Bool,sendSuccess else { return }
                self.view.makeToast("发送成功", point: self.view.center, title: nil, image: nil, completion: nil)
            } else {
                self.view.makeToast("Please enter the correct mobile number.".localized())
            }
        }
    }
    
    @objc func agreeAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @objc func entryHome() {
        let vc = VRRoomsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
