//
//  VRUserInfoView.swift
//  VoiceRoomBaseUIKit
//
//  Created by 朱继超 on 2022/8/25.
//

import UIKit
import ZSwiftBaseLib

public final class VRUserInfoView: UIView,UITextFieldDelegate {
    
    var editFinished: ((String)->())?
    
    var changeClosure: (()->())?
    
    lazy var avatar: UIImageView = {
        UIImageView(frame: CGRect(x: 20, y: self.frame.height/2.0-30, width: 60, height: 60)).image(UIImage(named: VoiceRoomUserInfo.shared.user?.portrait ?? "")!).contentMode(.scaleAspectFit).isUserInteractionEnabled(true)
    }()
    
    lazy var userName: UITextField = {
        UITextField(frame: CGRect(x: self.avatar.frame.maxX + 15, y: self.avatar.frame.minY+6, width: self.frame.width - self.avatar.frame.maxX - 60, height: 24)).font(.systemFont(ofSize: 18, weight: .semibold)).textColor(UIColor(0x000001)).text(VoiceRoomUserInfo.shared.user?.name ?? "").clearButtonMode(.whileEditing).backgroundColor(.clear).delegate(self)
    }()
    
    lazy var editName: UIButton = {
        let button = UIButton(type: .custom).frame(CGRect(x: self.frame.width-35, y: self.avatar.frame.minY+8, width: 20, height: 20)).addTargetFor(self, action: #selector(editAction), for: .touchUpInside)
        button.setImage(UIImage("bianji"), for: .normal)
        return button
    }()
    
    lazy var userId: UILabel = {
        UILabel(frame: CGRect(x: self.userName.frame.minX, y: self.userName.frame.maxY + 10, width: self.frame.width - self.userName.frame.minX - 15, height: 20)).font(.systemFont(ofSize: 12, weight: .regular)).textColor(UIColor(0x4d5055)).text("ID:\(VoiceRoomUserInfo.shared.user?.uid ?? "")")
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        let gradient = CAGradientLayer()
            .colors([UIColor(red: 0.998, green: 0.998, blue: 0.998, alpha: 1).cgColor,
            UIColor(red: 0.95, green: 0.976, blue: 1, alpha: 1).cgColor,
            UIColor(red: 0.977, green: 0.989, blue: 1, alpha: 1).cgColor])
            .locations([0, 0.51, 1])
            .startPoint(CGPoint(x: 0.25, y: 0.5))
            .endPoint(CGPoint(x: 0.75, y: 0.5))
            .frame(self.bounds)
        self.layer.addSublayer(gradient)
        self.addSubViews([self.avatar,self.userName,self.userId])
        self.userName.isEnabled = false
        self.userName.returnKeyType = .done
        self.avatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeAvatar)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension VRUserInfoView {
    
    @objc func editAction() {
        self.userName.isEnabled = !self.userName.isEnabled;
        if self.userName.isEnabled {
            self.userName.becomeFirstResponder()
        } else {
            self.userName.resignFirstResponder()
        }
    }
    
    @objc func changeAvatar() {
//        if self.changeClosure != nil {
//            self.changeClosure!()
//        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.userName.text = textField.text
        textField.resignFirstResponder()
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.userName.text = textField.text
        if self.editFinished != nil,let userName = textField.text {
            self.editFinished!(userName)
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as? NSString,text.length >= 16,string.isEmpty {
            textField.text = text.substring(to: 16)
            return false
        }
        return true
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        true
    }
    
    
}
