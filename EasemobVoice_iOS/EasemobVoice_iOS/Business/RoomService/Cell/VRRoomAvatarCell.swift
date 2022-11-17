//
//  VRRoomAvatarCell.swift
//  EasemobVoice_iOS
//
//  Created by 朱继超 on 2022/9/18.
//

import UIKit
import ZSwiftBaseLib

public class VRRoomAvatarCell: UICollectionViewCell {
    
    
    lazy var avatar: UIImageView = {
        UIImageView(frame: CGRect(x: 10, y: 10, width: self.frame.width-20, height: self.frame.height-20)).contentMode(.scaleAspectFill)
    }()
    
    lazy var symbol: UIImageView = {
        UIImageView(frame: CGRect(x: 10, y: 10, width: 24, height: 24)).contentMode(.scaleAspectFill).image(UIImage(named: "check 2")!)
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .white
        self.contentView.addSubViews([self.avatar,self.symbol])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    public override func layoutSubviews() {
//        super.layoutSubviews()
//        self.avatar.frame =  CGRect(x: 10, y: 10, width: self.frame.width-20, height: self.frame.height-20)
//        let space = sqrt(pow(self.avatar.frame.width/2.0, 2)/2.0)
//        self.symbol.center = CGPoint(x: self.avatar.center.x+space, y: self.avatar.center.y+space)
//    }
    
   func refresh(item: VRAvatar?) {
        if let item = item {
            self.avatar.image = UIImage(named: item.portrait)
            var rect = CGRect(x: 10, y: 10, width: self.frame.width-20, height: self.frame.height-20)
            self.symbol.isHidden = !item.selected
            if item.selected {
                rect = CGRect(x: 5, y: 5, width: self.frame.width-10, height: self.frame.height-10)
                self.avatar.layerProperties(UIColor(0x009FFF), 4)
                self.avatar.alpha = 1
            } else {
                self.avatar.layerProperties(.white, 4)
                self.avatar.alpha = 0.5
            }
            self.avatar.cornerRadius(rect.width/2.0)
            self.avatar.frame = rect
            if item.selected {
                let space = sqrt(pow(rect.width/2.0, 2)/2.0)
                self.symbol.center = CGPoint(x: self.avatar.center.x+space, y: self.avatar.center.y+space)
            }
        }
    }
    
}

public class VRAvatar {
    public var portrait = ""
    public var selected = false
}
