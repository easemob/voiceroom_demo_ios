//
//  VoiceRoomDisclaimerView.swift
//  EasemobVoice_iOS
//
//  Created by 朱继超 on 2022/9/17.
//

import UIKit
import ZSwiftBaseLib

public final class VoiceRoomDisclaimerView: UIView,UITextFieldDelegate {
    
    var tapClosure: (() -> ())?
    
    lazy var avatar: UIImageView = {
        UIImageView(frame: CGRect(x: 20, y: self.frame.height/2.0-12, width: 24, height: 24)).image(UIImage(named: "candle")!).contentMode(.scaleAspectFit)
    }()
    
    lazy var content: UILabel = {
        UILabel(frame: CGRect(x: self.avatar.frame.maxX + 15, y: self.frame.height/2.0-10, width: self.frame.width - self.avatar.frame.maxX - 60, height: 20)).font(.systemFont(ofSize: 18, weight: .regular)).textColor(UIColor(0x040925)).text(LanguageManager.localValue(key: "Disclaimer for demo"))
    }()
    
    lazy var indicator: UIButton = {
        UIButton(type: .custom).frame(CGRect(x: self.frame.width-35, y: self.frame.height/2.0-10, width: 20, height: 20)).image("arrow_right 1", .normal).isUserInteractionEnabled(false)
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        let gradient = CAGradientLayer()
            .colors([UIColor(red: 0.998, green: 0.998, blue: 0.998, alpha: 1).cgColor,
            UIColor(red: 0.95, green: 0.976, blue: 1, alpha: 1).cgColor,
            UIColor(red: 0.977, green: 0.989, blue: 1, alpha: 1).cgColor])
            .locations([0, 0.51, 1])
            .startPoint(CGPoint(x: 0.25, y: 0.5))
            .endPoint(CGPoint(x: 0.75, y: 0.5))
            .frame(self.bounds)
        self.layer.addSublayer(gradient)
        self.addSubViews([self.avatar,self.content,self.indicator])
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editAction)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func editAction() {
        if self.tapClosure != nil {
            self.tapClosure!()
        }
    }
}
