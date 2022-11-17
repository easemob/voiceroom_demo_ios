//
//  VRDisclaimerViewController.swift
//  EasemobVoice_iOS
//
//  Created by 朱继超 on 2022/9/17.
//

import UIKit
import ZSwiftBaseLib

public class VRDisclaimerViewController: VRBaseViewController,UITextViewDelegate {
    
    let attributeText = NSAttributedString {
        AttributedText(LanguageManager.localValue(key: "[Easemob Chat Room Demo]")).font(.systemFont(ofSize: 16, weight: .semibold)).foregroundColor(Color(0x040925)).lineSpacing(6)
        AttributedText(LanguageManager.localValue(key: "('this Product') is a test product provided by easemob. This Product is available for our current and potential customers only, and for them to test the functionality and quality of this Product. This Product is provided neither for commercial nor for public use. easemob enjoys the copyright and ownership of this product. You shall not modify, consolidate, compile, adjust, reverse engineer, sub-license, transfer, sell this Product or infringe the legitimate interests of easemob in any way.\n\n\n")).font(.systemFont(ofSize: 16, weight: .regular)).lineSpacing(6).foregroundColor(Color(0x040925))
        AttributedText(LanguageManager.localValue(key: "If you’d like to test this Product, you’re welcome to download, install and use it. Easemob hereby grants you a world-wide and royalty-free license to use this Product. This product is provided 'as is' without any express or implicit warranty, including but not limited to guarantees of suitability, suitability for specific purposes, and non-infringement. Whether it is due to any contract, infringement or other forms of conduct related to this Product or the use of this Product or otherwise, Easemob shall not be liable for any claims, damages or liabilities arising out of or related to your use of this Product.\n\n\n")).font(.systemFont(ofSize: 16, weight: .regular)).lineSpacing(6).foregroundColor(Color(0x040925))
        AttributedText(LanguageManager.localValue(key: "It’s your freedom to choose to test this Product or not. But if you decide to do so, and if you download, install, or use this Product, it means that you confirm and agree that under no circumstances shall Easemob be liable for any form of loss or injury caused to yourself or others when you use this Product for any reason, in any manner.\n\n\n")).font(.systemFont(ofSize: 16, weight: .regular)).lineSpacing(6).foregroundColor(Color(0x040925))
        AttributedText(LanguageManager.localValue(key: "If you have any query, please feel free to contact")).font(.systemFont(ofSize: 16, weight: .regular)).lineSpacing(6).foregroundColor(Color(0x040925))
        Link("support@easemob.com", url: URL(string: "mailto:support@easemob.com")!).foregroundColor(Color(0x1561f3)).lineSpacing(6).font(.systemFont(ofSize: 16, weight: .regular)).underline(.single,color: Color(0x1561f3))
        AttributedText(".\n\n\n\n\n").font(.systemFont(ofSize: 16, weight: .regular)).foregroundColor(Color(0x040925))
    }
    
    lazy var background: UIImageView = {
        UIImageView(frame: self.view.frame).image(UIImage("roomList")!)
    }()
    
    let container = UIView(frame: CGRect(x: 0, y: ZNavgationHeight, width: ScreenWidth, height: ScreenHeight - ZNavgationHeight)).backgroundColor(.white)
    
    lazy var textView: UITextView = {
        UITextView(frame: CGRect(x: 24, y: ZNavgationHeight+20, width: ScreenWidth-48, height: ScreenHeight - ZNavgationHeight - 20 - CGFloat(ZBottombarHeight))).attributedText(self.attributeText).isEditable(false).backgroundColor(.clear).delegate(self)
    }()
    

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.linkTextAttributes = [.foregroundColor:UIColor(0x1561f3)]
        self.view.addSubViews([self.background,self.container,self.textView])
        self.textView.showsVerticalScrollIndicator = false
        // Do any additional setup after loading the view.
        self.view.bringSubviewToFront(self.navigation)
        self.navigation.title.text = LanguageManager.localValue(key: "Disclaimer for demo")
    }

}
