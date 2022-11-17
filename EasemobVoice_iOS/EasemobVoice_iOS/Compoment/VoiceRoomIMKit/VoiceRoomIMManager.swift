//
//  VoiceRoomIMManager.swift
//  Pods-VoiceRoomIMKit_Tests
//
//  Created by 朱继超 on 2022/9/1.
//

import Foundation

import HyphenateChat
import KakaJSON
public let VoiceRoomGift = "chatroom_gift"//gift
public let VoiceRoomPraise = "chatroom_praise"//like 点赞
public let VoiceRoomInviteSite = "chatroom_inviteSiteNotify"//owner invite somebody to site
public let VoiceRoomApplySite = "chatroom_applySiteNotify"// user apply to some mic site
public let VoiceRoomDeclineApply = "chatroom_applyRefusedNotify"//owner refuse somebody apply
public let VoiceRoomUpdateRobotVolume = "chatroom_updateRobotVolume"
public let VoiceRoomJoinedMember = "chatroom_join"//Somebody join the room.

/// Description IM callback event
@objc public protocol VoiceRoomIMDelegate: NSObjectProtocol {
    
    /// Description you'll call login api,when you receive this message
    /// - Parameter code: EMErrorCode
    func chatTokenDidExpire(code: EMErrorCode)
    /// Description you'll call login api,when you receive this message
    /// - Parameter code: EMErrorCode
    func chatTokenWillExpire(code: EMErrorCode)
    
    /// Description Callback when yoi  receivie text message.
    /// - Parameters:
    ///   - roomId: HyphenateChat's chatroom id
    ///   - message: message instance  contain EMTextMessageBody.
    func receiveTextMessage(roomId: String,message: EMChatMessage)
    
    /// Description Callback when you receive a gift message
    /// - Parameters:
    ///   - roomId: HyphenateChat's chatroom id
    ///   - meta: Message instance, which contains EMCustomMessageBody, which contains transparent transmission dictionary and event type.
    func receiveGift(roomId: String, meta: [String:String]?)
    
    /// Description Callback for accepting application messages
    /// - Parameters:
    ///   - roomId: HyphenateChat's chatroom id
    ///   - meta: Transparent transmission information attached to the application message
    func receiveApplySite(roomId: String, meta: [String:String]?)
    
    /// Description Callback for accepting invitation messages
    /// - Parameters:
    ///   - roomId: HyphenateChat's chatroom id
    ///   - meta: Transparent transmission information attached to the invitation message
    func receiveInviteSite(roomId: String, meta: [String:String]?)
    
    /// Description Refuse invite
    /// - Parameters:
    ///   - roomId: HyphenateChat's chatroom id
    ///   - meta: Transparent transmission information attached to the invitation message
    func refuseInvite(roomId: String, meta: [String:String]?)
    
    /// Description User joins the chat room callback
    /// - Parameters:
    ///   - roomId: HyphenateChat's chatroom id
    ///   - username: userName
    ///   - ext: ext information
    func userJoinedRoom(roomId: String, username: String,ext: Dictionary<String,Any>?)
    
    /// Description Callback when chatroom's announcement changed.
    /// - Parameters:
    ///   - roomId: HyphenateChat's chatroom id
    ///   - content: changed context
    func announcementChanged(roomId: String, content: String)
    
    /// Description Callback when robot's volume changed.
    /// - Parameters:
    ///   - roomId: HyphenateChat's chatroom id
    ///   - volume: volume
    func voiceRoomUpdateRobotVolume(roomId: String, volume: String)
    
    /// Description Callback when you are kicked out of room
    /// - Parameters:
    ///   - roomId: HyphenateChat's chatroom id
    ///   - reason: The reason ,why you are kick out of room.
    func userBeKicked(roomId: String, reason: EMChatroomBeKickedReason)
    
    /// Description Callback,when mics info updated.
    /// - Parameters:
    ///   - roomId: HyphenateChat's chatroom id
    ///   - attributeMap: new attributes dictionary map
    ///   - fromId: This operator's id
    func roomAttributesDidUpdated(roomId: String, attributeMap: [String : String]?, from fromId: String)
    
    /// Description Callback,when mics info removed.
    /// - Parameters:
    ///   - roomId: HyphenateChat's chatroom id
    ///   - attributes: new Array<String> ,be removed
    ///   - fromId: This operator's id
    func roomAttributesDidRemoved(roomId: String, attributes: [String]?, from fromId: String)
    
    /// Description Callback,when somebody leave chatroom.
    /// - Parameters:
    ///   - roomId: HyphenateChat's chatroom id
    ///   - userName: userName
    func memberLeave(roomId: String,userName: String)
}

fileprivate let once = VoiceRoomIMManager()

@objc public class VoiceRoomIMManager:NSObject,EMChatManagerDelegate,EMChatroomManagerDelegate,EMClientDelegate {
    
    public var currentRoomId = ""
    
    @objc public static var shared: VoiceRoomIMManager? = once
    
    @objc public weak var delegate: VoiceRoomIMDelegate?
    
    /// Description Configure the necessary conditions for IMSDK
    /// - Parameter appkey: a application's key
    @objc public func configIM(appkey: String) {
        let options = EMOptions(appkey: appkey.isEmpty ? "easemob-demo#easeim":appkey)
        options.enableConsoleLog = true
        options.isAutoLogin = false
//        options.setValue(false, forKeyPath: "enableDnsConfig")
//        options.setValue(6717, forKeyPath: "chatPort")
//        options.setValue("52.80.99.104", forKeyPath: "chatServer")
//        options.setValue("http://a1-test.easemob.com", forKeyPath: "restServer")
        EMClient.shared().initializeSDK(with: options)
    }
    
    /// Description Login method
    /// - Parameters:
    ///   - userName:HyphenateChat's userName
    ///   - token: HyphenateChat's token
    ///   - completion: Login callback, return username and error message
    @objc public func loginIM(userName: String,token: String,completion: @escaping (String,EMError?)->Void) {
        if EMClient.shared().isLoggedIn {
            completion(EMClient.shared().currentUsername ?? "",nil)
        } else {
            EMClient.shared().login(withUsername: userName, token: token,completion: completion)
        }
    }
    
    /// Description Add chat room callback listener
    @objc public func addChatRoomListener() {
        EMClient.shared().add(self, delegateQueue: .main)
        EMClient.shared().chatManager?.add(self, delegateQueue: .main)
        EMClient.shared().roomManager?.add(self, delegateQueue: .main)
    }
    /// Description Remove chat room callback listener
    @objc public func removeListener() {
        EMClient.shared().roomManager?.remove(self)
        EMClient.shared().chatManager?.remove(self)
    }
    
    deinit {
        self.removeListener()
    }
}

public extension VoiceRoomIMManager {
    //MARK: - EMClientDelegate
    
    /// Description tokenDidExpire
    /// - Parameter aErrorCode: A error code.
    func tokenDidExpire(_ aErrorCode: EMErrorCode) {
        if self.delegate != nil,self.delegate!.responds(to: #selector(VoiceRoomIMDelegate.chatTokenDidExpire(code:))) {
            self.delegate?.chatTokenDidExpire(code: aErrorCode)
        }
    }
    /// Description tokenWillExpire
    /// - Parameter aErrorCode: A error code.
    func tokenWillExpire(_ aErrorCode: EMErrorCode) {
        if self.delegate != nil,self.delegate!.responds(to: #selector(VoiceRoomIMDelegate.chatTokenWillExpire(code:))) {
            self.delegate?.chatTokenWillExpire(code: aErrorCode)
        }
    }
    
    //MARK: - EMChatManagerDelegate
    
    /// Description Callback,when you receive messages
    /// - Parameter aMessages: Array<EMChatMessage> instance
    func messagesDidReceive(_ aMessages: [EMChatMessage]) {
        for message in aMessages {
            if message.body is EMTextMessageBody {
                if self.delegate != nil,self.delegate!.responds(to: #selector(VoiceRoomIMDelegate.receiveTextMessage(roomId:message:))) {
                    self.delegate?.receiveTextMessage(roomId: self.currentRoomId, message: message)
                }
                continue
            }
            if let body = message.body as? EMCustomMessageBody {
                if self.delegate != nil {
                    switch body.event {
                    case VoiceRoomGift:
                        if self.delegate!.responds(to: #selector(VoiceRoomIMDelegate.receiveGift(roomId:meta:))) {
                            self.delegate?.receiveGift(roomId: self.currentRoomId, meta: body.customExt)
                        }
                    case VoiceRoomInviteSite:
                        if self.delegate!.responds(to: #selector(VoiceRoomIMDelegate.receiveInviteSite(roomId:meta:))) {
                            self.delegate?.receiveInviteSite(roomId: self.currentRoomId, meta: body.customExt)
                        }
                    case VoiceRoomApplySite:
                        if self.delegate!.responds(to: #selector(VoiceRoomIMDelegate.receiveApplySite(roomId:meta:))) {
                            self.delegate?.receiveApplySite(roomId: self.currentRoomId, meta: body.customExt)
                        }
                    case VoiceRoomDeclineApply:
                        if self.delegate!.responds(to: #selector(VoiceRoomIMDelegate.refuseInvite(roomId:meta:))) {
                            self.delegate?.refuseInvite(roomId: self.currentRoomId, meta: body.customExt)
                        }
                    case VoiceRoomUpdateRobotVolume:
                        if self.delegate!.responds(to: #selector(VoiceRoomIMDelegate.voiceRoomUpdateRobotVolume(roomId:volume:))) {
                            self.delegate?.voiceRoomUpdateRobotVolume(roomId: self.currentRoomId, volume: body.customExt["volume"] ?? "")
                        }
                    case VoiceRoomJoinedMember:
                        if self.delegate!.responds(to: #selector(VoiceRoomIMDelegate.userJoinedRoom(roomId:username:ext:))) {
                            if let ext = body.customExt["room_user"], let user = model(from: ext, VRUser.self) {
                                self.delegate?.userJoinedRoom(roomId: message.to, username: user.name ?? "",ext: body.customExt)
                            }
                        }
                    default:
                        break
                    }
                }
            }
        }
    }
    //MARK: - EMChatroomManagerDelegate
    func chatroomAnnouncementDidUpdate(_ aChatroom: EMChatroom, announcement aAnnouncement: String?) {
        if self.delegate != nil,self.delegate!.responds(to: #selector(VoiceRoomIMDelegate.announcementChanged(roomId:content:))) {
            if let roomId = aChatroom.chatroomId,let announcement = aAnnouncement,roomId == self.currentRoomId  {
                self.delegate?.announcementChanged(roomId: roomId, content: announcement)
            }
        }
    }
    
    /// Description Callback,when you are kick out of chartroom.
    /// - Parameters:
    ///   - aChatroom: A chatroom instance.
    ///   - aReason: The reason,why you are kick out.
    func didDismiss(from aChatroom: EMChatroom, reason aReason: EMChatroomBeKickedReason) {
        if self.delegate != nil,self.delegate!.responds(to: #selector(VoiceRoomIMDelegate.userBeKicked(roomId:reason:))) {
            if let roomId = aChatroom.chatroomId,roomId == self.currentRoomId  {
                self.delegate?.userBeKicked(roomId: roomId, reason: aReason)
            }
        }
        switch aReason {
        case .beRemoved,.destroyed:
            if let roomId = aChatroom.chatroomId,roomId == self.currentRoomId  {
                self.currentRoomId = ""
            }
        default:
            break
        }
        self.removeListener()
        EMClient.shared().logout(false)
    }
    
    
    
    func chatroomAttributesDidUpdated(_ roomId: String, attributeMap: [String : String]?, from fromId: String) {
        if self.delegate != nil,self.delegate!.responds(to: #selector(VoiceRoomIMDelegate.roomAttributesDidUpdated(roomId:attributeMap:from:))),roomId == self.currentRoomId  {
            self.delegate?.roomAttributesDidUpdated(roomId: roomId, attributeMap: attributeMap, from: fromId)
        }
    }
    
    func chatroomAttributesDidRemoved(_ roomId: String, attributes: [String]?, from fromId: String) {
        if self.delegate != nil,self.delegate!.responds(to: #selector(VoiceRoomIMDelegate.roomAttributesDidRemoved(roomId:attributes:from:))),roomId == self.currentRoomId {
            self.delegate?.roomAttributesDidRemoved(roomId: roomId, attributes: attributes, from: fromId)
        }
    }
    
    /// Description Callback,when somebody leave chatroom
    /// - Parameters:
    ///   - aChatroom: A chatroom instance
    ///   - aUsername: userName
    func userDidLeave(_ aChatroom: EMChatroom, user aUsername: String) {
        if self.delegate != nil,self.delegate!.responds(to: #selector(VoiceRoomIMDelegate.memberLeave(roomId:userName:))),aChatroom.chatroomId == self.currentRoomId {
            self.delegate?.memberLeave(roomId: self.currentRoomId, userName: aUsername)
        }
    }
    
    //MARK: - Send
    
    /// Description The method,you can send text message.
    /// - Parameters:
    ///   - roomId: chatroom id
    ///   - text: Content that you want send.
    ///   - ext: ext information
    ///   - completion: The callback after sending the message, including the sent message and error information.
    @objc func sendMessage(roomId: String,text: String, ext: [AnyHashable : Any]?,completion: @escaping (EMChatMessage?,EMError?) -> (Void)) {
        let message = EMChatMessage(conversationID: roomId, body: EMTextMessageBody(text: text), ext: ext)
        message.chatType = .chatRoom
        EMClient.shared().chatManager?.send(message, progress: nil, completion: completion)
    }
    
    /// Description The method,you can send custom message.
    /// - Parameters:
    ///   - roomId: chatroom id
    ///   - event: Event type,which you define.
    ///   - customExt: ext information
    ///   - completion: The callback after sending the message, including the sent message and error information.
    @objc func sendCustomMessage(roomId: String,event: String,customExt: [String:String],completion: @escaping (EMChatMessage?,EMError?) -> (Void)) {
        let message = EMChatMessage(conversationID: roomId, body: EMCustomMessageBody(event: event, customExt: customExt), ext: nil)
        message.chatType = .chatRoom
        EMClient.shared().chatManager?.send(message, progress: nil, completion: completion)
    }
    
    @objc func joinedChatRoom(roomId: String,completion: @escaping ((EMChatroom?,EMError?)->())) {
        EMClient.shared().roomManager?.joinChatroom(roomId, completion: { room, error in
            if error == nil,let id = room?.chatroomId {
                self.currentRoomId = id
            }
            completion(room,error)
        })
    }
    
    @objc func userQuitRoom(completion: ((EMError?)->())?) {
        EMClient.shared().roomManager?.leaveChatroom(self.currentRoomId, completion: { error in
            if error == nil {
                EMClient.shared().roomManager?.remove(self)
                EMClient.shared().chatManager?.remove(self)
                self.currentRoomId = ""
            }
            if completion != nil {
                completion!(error)
            }
        })
        self.removeListener()
        EMClient.shared().logout(false)
    }
    
    func fetchMembersCount(roomId: String,completion: @escaping (Int) -> ()) {
        EMClient.shared().roomManager?.getChatroomSpecificationFromServer(withId: roomId, fetchMembers: true,completion: { room, error in
            completion(room?.occupantsCount ?? 0)
        })
    }
}
