//
//  VoiceRoomEmojiManager.swift
//  VoiceRoomBaseUIKit
//
//  Created by 朱继超 on 2022/9/5.
//

import UIKit

fileprivate let manager = VoiceRoomEmojiManager()

@objc open class VoiceRoomEmojiManager: NSObject {
    
    @objc static let shared = manager
    
    @objc var emojiMap: Dictionary<String,UIImage> = ["U+1F600":UIImage(named:"U+1F600")!,"U+1F604":UIImage(named:"U+1F604")!,"U+1F609":UIImage(named:"U+1F609")!,"U+1F62E":UIImage(named:"U+1F62E")!,"U+1F92A":UIImage(named:"U+1F92A")!,"U+1F60E":UIImage(named:"U+1F60E")!,"U+1F971":UIImage(named:"U+1F971")!,"U+1F974":UIImage(named:"U+1F974")!,"U+263A":UIImage(named:"U+263A")!,"U+1F641":UIImage(named:"U+1F641")!,"U+1F62D":UIImage(named:"U+1F62D")!,"U+1F610":UIImage(named:"U+1F610")!,"U+1F607":UIImage(named:"U+1F607")!,"U+1F62C":UIImage(named:"U+1F62C")!,"U+1F913":UIImage(named:"U+1F913")!,"U+1F633":UIImage(named:"U+1F633")!,"U+1F973":UIImage(named:"U+1F973")!,"U+1F620":UIImage(named:"U+1F620")!,"U+1F644":UIImage(named:"U+1F644")!,"U+1F910":UIImage(named:"U+1F910")!,"U+1F97A":UIImage(named:"U+1F97A")!,"U+1F928":UIImage(named:"U+1F928")!,"U+1F62B":UIImage(named:"U+1F62B")!,"U+1F637":UIImage(named:"U+1F637")!,"U+1F912":UIImage(named:"U+1F912")!,"U+1F631":UIImage(named:"U+1F631")!,"U+1F618":UIImage(named:"U+1F618")!,"U+1F60D":UIImage(named:"U+1F60D")!,"U+1F922":UIImage(named:"U+1F922")!,"U+1F47F":UIImage(named:"U+1F47F")!,"U+1F92C":UIImage(named:"U+1F92C")!,"U+1F621":UIImage(named:"U+1F621")!,"U+1F44D":UIImage(named:"U+1F44D")!,"U+1F44E":UIImage(named:"U+1F44E")!,"U+1F44F":UIImage(named:"U+1F44F")!,"U+1F64C":UIImage(named:"U+1F64C")!,"U+1F91D":UIImage(named:"U+1F91D")!,"U+1F64F":UIImage(named:"U+1F64F")!,"U+2764":UIImage(named:"U+2764")!,"U+1F494":UIImage(named:"U+1F494")!,"U+1F495":UIImage(named:"U+1F495")!,"U+1F4A9":UIImage(named:"U+1F4A9")!,"U+1F48B":UIImage(named:"U+1F48B")!,"U+2600":UIImage(named:"U+2600")!,"U+1F31C":UIImage(named:"U+1F31C")!,"U+1F308":UIImage(named:"U+1F308")!,"U+2B50":UIImage(named:"U+2B50")!,"U+1F31F":UIImage(named:"U+1F31F")!,"U+1F389":UIImage(named:"U+1F389")!,"U+1F490":UIImage(named:"U+1F490")!]
    
    @objc var emojis: [String] = ["U+1F600","U+1F604","U+1F609","U+1F62E","U+1F92A","U+1F60E","U+1F971","U+1F974","U+263A","U+1F641","U+1F62D","U+1F610","U+1F607","U+1F62C","U+1F913","U+1F633","U+1F973","U+1F620","U+1F644","U+1F910","U+1F97A","U+1F928","U+1F62B","U+1F637","U+1F912","U+1F631","U+1F618","U+1F60D","U+1F922","U+1F47F","U+1F92C","U+1F621","U+1F44D","U+1F44E","U+1F44F","U+1F64C","U+1F91D","U+1F64F","U+2764","U+1F494","U+1F495","U+1F4A9","U+1F48B","U+2600","U+1F31C","U+1F308","U+2B50","U+1F31F","U+1F389","U+1F490"]
    
    /// Description Change emoji resource
    /// - Parameters:
    ///   - map: emoji map ,key is resource key,value is UIImage instance.
    ///   - emojis: emojis that map's keys.
    @objc func changeEmojisMap(map: Dictionary<String,UIImage>,emojis: [String]) {
        self.emojiMap = map
        self.emojis = emojis
    }
    
    @objc func convertEmoji(input: NSMutableAttributedString,ranges: [NSRange],symbol: String) -> NSMutableAttributedString {
        let text = NSMutableAttributedString(attributedString: input)
        for range in ranges.reversed() {
            if range.location != NSNotFound,range.length != NSNotFound {
                let value = self.emojiMap[symbol]
                let attachment = NSTextAttachment()
                attachment.image = value
                attachment.bounds = CGRect(x: 0, y: -1.5, width: 14, height: 14)
                text.replaceCharacters(in: range, with: NSAttributedString(attachment: attachment))
            }
        }
        return text
    }
}
