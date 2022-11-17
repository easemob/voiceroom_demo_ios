//
//  VoiceRoomAlertViewController.swift
//  VoiceRoomBaseUIKit
//
//  Created by 朱继超 on 2022/8/30.
//
import Foundation
import UIKit

public class PresentationSegue: UIStoryboardSegue {
    
    public override func perform() {
        guard let destination = destination as? PresentationViewController else {
            fatalError("destination must comfirm to protocol PresentedViewType")
        }
        source.presentViewController(destination)
    }
    
}
