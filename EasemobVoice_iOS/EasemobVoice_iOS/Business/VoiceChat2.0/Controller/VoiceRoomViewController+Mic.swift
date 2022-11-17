//
//  VoiceRoomViewController+Mic.swift
//  EasemobVoice_iOS
//
//  Created by 朱继超 on 2022/11/10.
//

import Foundation

extension VoiceRoomViewController {
    
    //禁言指定麦位
    func mute(with index: Int) {
        guard let roomId = self.roomInfo?.room?.room_id else { return }
        VoiceRoomBusinessRequest.shared.sendPOSTRequest(api: .muteMic(roomId: roomId), params: ["mic_index": index]) { dic, error in
            if error == nil,dic != nil,let result = dic?["result"] as? Bool {
                if result {
                } else {
                }
            } else {
               // self.view.makeToast("\(error?.localizedDescription ?? "")",point: self.toastPoint, title: nil, image: nil, completion: nil)
            }
        }
    }
    
    //取消禁言指定麦位
    func unMute(with index: Int) {
        if let user = roomInfo?.mic_info?[index] {
            if user.status == 1 && index != 0 && self.isOwner {
                return
            }
        }
        guard let roomId = self.roomInfo?.room?.room_id else { return }
        VoiceRoomBusinessRequest.shared.sendDELETERequest(api: .unmuteMic(roomId: roomId, index: index), params: [:]) { dic, error in
            if error == nil,dic != nil,let result = dic?["result"] as? Bool {
                if result {
                    self.chatBar.refresh(event: .handsUp, state: .unSelected, asCreator: false)
                } else {
                }
            } else {
               // self.view.makeToast("\(error?.localizedDescription ?? "")",point: self.toastPoint, title: nil, image: nil, completion: nil)
            }
        }
    }
    
    //踢用户下麦
    func kickoff(with index: Int) {
        guard let roomId = self.roomInfo?.room?.room_id else { return }
        guard let mic: VRRoomMic = self.roomInfo?.mic_info![index] else {return}
        let dic: Dictionary<String, Any> = [
            "uid":mic.member?.uid ?? 0,
            "mic_index": index
        ]
        VoiceRoomBusinessRequest.shared.sendPOSTRequest(api: .kickMic(roomId: roomId), params: dic) { dic, error in
            if error == nil,dic != nil,let result = dic?["result"] as? Bool {
                if result {
                } else {
                }
            } else {
              //  self.view.makeToast("\(error?.localizedDescription ?? "")",point: self.toastPoint, title: nil, image: nil, completion: nil)
            }
        }
    }
    
    //锁麦
    func lock(with index: Int) {
        guard let roomId = self.roomInfo?.room?.room_id else { return }
        VoiceRoomBusinessRequest.shared.sendPOSTRequest(api: .lockMic(roomId: roomId), params: ["mic_index": index]) { dic, error in
            if error == nil,dic != nil,let result = dic?["result"] as? Bool {
                if result {
                } else {
                }
            } else {
               // self.view.makeToast("\(error?.localizedDescription ?? "")",point: self.toastPoint, title: nil, image: nil, completion: nil)
            }
        }
    }
    
    //取消锁麦
    func unLock(with index: Int) {
        guard let roomId = self.roomInfo?.room?.room_id else { return }
        VoiceRoomBusinessRequest.shared.sendDELETERequest(api: .unlockMic(roomId: roomId, index: index), params: [:]) { dic, error in
            if error == nil,dic != nil,let result = dic?["result"] as? Bool {
                if result {
                } else {
                }
            } else {
               // self.view.makeToast("\(error?.localizedDescription ?? "")",point: self.toastPoint, title: nil, image: nil, completion: nil)
            }
        }
    }
    
    //下麦
    func leaveMic(with index: Int) {
        self.chatBar.refresh(event: .mic, state: .selected, asCreator: false)
        guard let roomId = self.roomInfo?.room?.room_id else { return }
        VoiceRoomBusinessRequest.shared.sendDELETERequest(api: .leaveMic(roomId: roomId, index: index), params: [:]) { dic, error in
            if error == nil,dic != nil,let result = dic?["result"] as? Bool {
                if result {
                    self.rtckit.setClientRole(role: .audience)
                } else {
                }
            } else {
              //  self.view.makeToast("\(error?.localizedDescription ?? "")",point: self.toastPoint, title: nil, image: nil, completion: nil)
            }
        }
    }
    
    //mute自己
    func muteLocal(with index: Int) {
        guard let roomId = self.roomInfo?.room?.room_id else { return }
        VoiceRoomBusinessRequest.shared.sendPOSTRequest(api: .closeMic(roomId: roomId), params: ["mic_index": index]) { dic, error in
            if error == nil,dic != nil,let result = dic?["result"] as? Bool {
                if result {
                    self.chatBar.refresh(event: .mic, state: .selected, asCreator: false)
                    self.rtckit.muteLocalAudioStream(mute: true)
                } else {
                }
            } else {
//                self.view.makeToast("\(error?.localizedDescription ?? "")",point: self.toastPoint, title: nil, image: nil, completion: nil)
            }
        }
    }
    
    //unmute自己
    func unmuteLocal(with index: Int) {
        guard let roomId = self.roomInfo?.room?.room_id else { return }
        
        /**
         1.如果房主禁言了用户，用户没办法解除禁言
         2.如果客户mute了自己，房主没办法打开用户
         */
        if let mic = self.roomInfo?.mic_info?[index] {
            if mic.status == 2 && self.isOwner == false {
                self.view.makeToast("Banned".localized())
                return
            }
        }
        
        VoiceRoomBusinessRequest.shared.sendDELETERequest(api: .cancelCloseMic(roomId: roomId, index: index), params: [:]) { dic, error in
            if error == nil,dic != nil,let result = dic?["result"] as? Bool {
                if result {
                    self.chatBar.refresh(event: .mic, state: .unSelected, asCreator: false)
                    self.rtckit.muteLocalAudioStream(mute: false)
                } else {
                }
            } else {
//                self.view.makeToast("\(error?.localizedDescription ?? "")",point: self.toastPoint, title: nil, image: nil, completion: nil)
            }
        }
    }
    
    func changeMic(from: Int, to: Int) {
        
        if let mic: VRRoomMic = self.roomInfo?.mic_info?[to] {
            if mic.status == 3 || mic.status == 4 {
                self.view.makeToast("Mic Closed".localized())
                return
            }
        }
        
        guard let roomId = self.roomInfo?.room?.room_id else { return }
        let params: Dictionary<String, Int> = [
            "from": from,
            "to": to
        ]
        VoiceRoomBusinessRequest.shared.sendPOSTRequest(api: .exchangeMic(roomId: roomId), params: params) { dic, error in
            self.dismiss(animated: true)
            if error == nil,dic != nil,let result = dic?["result"] as? Bool {
                if result {
                    self.local_index = to
                   // self.micExchange(from, to: to)
                } else {
                }
            } else {
            }
        }
    }
    
    func micExchange(_ from: Int, to: Int) {
        //立即更新麦位位置
        guard let fromUser: VRRoomMic = self.roomInfo?.mic_info![from] else {return}
        fromUser.mic_index = to
        
        guard let toUser: VRRoomMic = self.roomInfo?.mic_info![to] else {return}
        toUser.mic_index = from
        
        self.roomInfo?.mic_info![from] = toUser
        self.roomInfo?.mic_info![to] = fromUser
        self.rtcView.updateUser(fromUser)
        self.rtcView.updateUser(toUser)
    }
    
    func showMuteView(with index: Int) {
        let isHairScreen = SwiftyFitsize.isFullScreen
        let muteView = VMMuteView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: isHairScreen ? 264~ : 264~ - 34))
        guard let mic_info = roomInfo?.mic_info?[index] else {return}
        muteView.isOwner = isOwner
        muteView.micInfo = mic_info
        muteView.resBlock = {[weak self] (state) in
            self?.dismiss(animated: true)
            if state == .leave {
                self?.leaveMic(with: index)
            } else if state == .mute {
                self?.muteLocal(with: index)
            } else {
                self?.unmuteLocal(with: index)
            }
        }
        let vc = VoiceRoomAlertViewController.init(compent: PresentedViewComponent(contentSize: CGSize(width: ScreenWidth, height: isHairScreen ? 264~ : 264~ - 34)), custom: muteView)
        self.presentViewController(vc)
    }
    
    func refuse() {
        if let roomId = self.roomInfo?.room?.room_id {
            VoiceRoomBusinessRequest.shared.sendGETRequest(api: .refuseInvite(roomId: roomId), params: [:]) { _, _ in
            }
        }
    }
    
    func agreeInvite() {
        if let roomId = self.roomInfo?.room?.room_id {
            VoiceRoomBusinessRequest.shared.sendPOSTRequest(api: .agreeInvite(roomId: roomId), params: [:]) { _, _ in
                
            }
        }
    }
    
}
