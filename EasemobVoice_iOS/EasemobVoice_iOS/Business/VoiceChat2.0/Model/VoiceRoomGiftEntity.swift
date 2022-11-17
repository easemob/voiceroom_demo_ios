//
//  VoiceRoomGiftEntity.swift
//  VoiceRoomBaseUIKit
//
//  Created by 朱继超 on 2022/8/31.
//

import Foundation
import UIKit
import KakaJSON

@objc open class VoiceRoomGiftEntity: NSObject,Convertible,NSMutableCopying {
    
    public func mutableCopy(with zone: NSZone? = nil) -> Any {
        let model = VoiceRoomGiftEntity()
        model.gift_id = self.gift_id
        model.gift_count = self.gift_count
        model.gift_price = self.gift_price
        model.gift_name = self.gift_name
        model.portrait = self.portrait
        model.userName = self.userName
        model.selected = self.selected
        return model
    }
    
    var gift_id: String? = ""
    var gift_name: String? = ""
    var userName: String? = ""
    var gift_price: String? = ""
    var portrait: String? = ""
    var avatar: UIImage? {
        UIImage(named: self.portrait ?? "")
    }
    var gift_count: String? = "0"
    var selected = false
    
    required public override init() {
        
    }
    
    public func kj_modelKey(from property: Property) -> ModelPropertyKey {
        property.name
    }
}

open class VoiceRoomGiftCount {
    var number: Int
    var selected: Bool
    
    init(number: Int,selected: Bool) {
        self.number = number
        self.selected = selected
    }
}
