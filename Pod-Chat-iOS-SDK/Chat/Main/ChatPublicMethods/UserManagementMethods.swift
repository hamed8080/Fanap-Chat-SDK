//
//  UserManagementMethods.swift
//  FanapPodChatSDK
//
//  Created by Mahyar Zhiani on 3/21/1398 AP.
//  Copyright © 1398 Mahyar Zhiani. All rights reserved.
//

import Foundation
import FanapPodAsyncSDK
import SwiftyJSON

// MARK: - Public Methods
// MARK: - User Management

extension Chat {
    
    /*
     This function will retuen peerId of the current user if it exists, else it would return 0
     */
    public func getPeerId() -> Int {
        if let id = peerId {
            return id
        } else {
            return 0
        }
    }
    
    /*
     This function will return the current user info if it exists, otherwise it would return nil!
     */
    public func getCurrentUser() -> User? {
        if let myUserInfo = userInfo {
            return myUserInfo
        } else {
            return nil
        }
    }
    
    
    /// GetUserInfo:
    /// this function will return UserInfo
    ///
    /// By calling this function, a request of type 23 (USER_INFO) will send throut Chat-SDK,
    /// then the response will come back as callbacks to client whose calls this function.
    ///
    /// Inputs:
    /// - this method doesn't need any input
    ///
    /// Outputs:
    /// - It has 3 callbacks as responses
    ///
    /// - parameter getCacheResponse:   (input) specify if you want to get cache response for this request (Bool?)
    /// - parameter uniqueId:           (response) it will returns the request 'UniqueId' that will send to server. (String)
    /// - parameter completion:         (response) it will returns the response that comes from server to this request. (Any as! UserInfoModel)
    /// - parameter cacheResponse:      (response) there is another response that comes from CacheDB to the user, if user has set 'enableCache' vaiable to be true. (UserInfoModel)
    public func getUserInfo(getCacheResponse:   Bool?,
                            uniqueId:       @escaping ((String) -> ()),
                            completion:     @escaping callbackTypeAlias,
                            cacheResponse:  @escaping ((UserInfoModel) -> ())) {
        guard let createChatModel = createChatModel else {return}
        log.verbose("Try to request to get user info", context: "Chat")
        let theUniqueId = generateUUID()
        uniqueId(theUniqueId)
        
        userInfoCallbackToUser = completion
        
        let chatMessage = SendChatMessageVO(chatMessageVOType:  ChatMessageVOTypes.USER_INFO.intValue(),
                                            token:              createChatModel.token,
                                            typeCode:           createChatModel.typeCode,
                                            uniqueId:           theUniqueId)
		guard let content = chatMessage.convertCodableToString() else{return}
        let asyncMessage = SendAsyncMessageVO(content:      content,
                                              msgTTL:       createChatModel.msgTTL,
											  ttl: createChatModel.msgTTL,
                                              peerName:     createChatModel.serverName,
                                              priority:     createChatModel.msgPriority)
        
        sendMessageWithCallback(asyncMessageVO:     asyncMessage,
                                callbacks:          [(GetUserInfoCallback(), theUniqueId)],
                                sentCallback:       nil,
                                deliverCallback:    nil,
                                seenCallback:       nil)
        
        // if cache is enabled by user, first return cache result to the user
        if (getCacheResponse ?? createChatModel.enableCache) {
            if let cacheUserInfoResult = Chat.cacheDB.retrieveUserInfo() {
                cacheResponse(cacheUserInfoResult)
            }
        }
        
    }
    
    /// SetProfile:
    /// this function will set Bio and Metadata to the user, and it will save on the UserInfo model
    ///
    /// By calling this function, a request of type 52 (SET_PROFILE) will send throut Chat-SDK,
    /// then the response will come back as callbacks to client whose calls this function.
    ///
    /// Inputs:
    /// - you have to send your parameters as "UpdateChatProfileRequest" to this function
    ///
    /// Outputs:
    /// - It has 2 callbacks as responses
    ///
    /// - parameter uniqueId:   (response) it will returns the request 'UniqueId' that will send to server. (String)
    /// - parameter completion: (response) it will returns the response that comes from server to this request. (Any as! ProfileModel)
    public func setProfile(inputModel setProfileInput:  UpdateChatProfileRequest,
                           uniqueId:                    @escaping ((String) -> ()),
                           completion:                  @escaping callbackTypeAlias) {
        guard let createChatModel = createChatModel else {return}
        log.verbose("Try to request to set Profile", context: "Chat")
        
        uniqueId(setProfileInput.uniqueId)
        updateChatProfileCallbackToUser = completion
        
        let chatMessage = SendChatMessageVO(chatMessageVOType:  ChatMessageVOTypes.SET_PROFILE.intValue(),
											token:              createChatModel.token,
											content:            setProfileInput.convertContentToJSON().toString(),
                                            typeCode:           setProfileInput.typeCode ?? createChatModel.typeCode,
                                            uniqueId:           setProfileInput.uniqueId)
		guard let content = chatMessage.convertCodableToString() else{return}
        let asyncMessage = SendAsyncMessageVO(content:      content,
                                              msgTTL:       createChatModel.msgTTL,
											  ttl: createChatModel.msgTTL,
                                              peerName:     createChatModel.serverName,
                                              priority:     createChatModel.msgPriority)
        
        sendMessageWithCallback(asyncMessageVO:     asyncMessage,
                                callbacks:          [(UpdateChatProfileCallback(), setProfileInput.uniqueId)],
                                sentCallback:       nil,
                                deliverCallback:    nil,
                                seenCallback:       nil)
        
    }
    
    
	/// SendStatusPing:
	///
	///
	/// By calling this function, a request of type 101 (STATUS_PING) will send throut Chat-SDK,
	/// then the response will come back as callbacks to client whose calls this function.
	///
	/// Inputs:
	/// - you have to send your parameters as "StatusPingRequest" to this function
	///
	/// Outputs:
	/// - It has 3 callbacks as responses.
	///
	/// - parameter inputModel:         (input) you have to send your parameters insid this model. (StatusPingRequest)
	//    /// - parameter uniqueId:           (response) it will returns the request 'UniqueId' that will send to server. (String)
	//    /// - parameter completion:         (response) it will returns the response that comes from server to this request. (Any as! )
	public func sendStatusPing(inputModel statusPingInput: StatusPingRequest) {
		//                               uniqueId:                @escaping (String) -> (),
		//                               completion:              @escaping callbackTypeAlias) {
		guard let createChatModel = createChatModel else {return}
		log.verbose("Try to send Status Ping with this parameters: \n threadId = \(statusPingInput.threadId ?? 2) \n contactId = \(statusPingInput.contactId ?? 3)", context: "Chat")
		//        uniqueId(statusPingInput.uniqueId)
		//
		//        statusPingCallbackToUser = completion
		
		let chatMessage = SendChatMessageVO(chatMessageVOType:  ChatMessageVOTypes.STATUS_PING.intValue(),
											token:              createChatModel.token,
											content:            "\(statusPingInput.convertContentToJSON())",
											typeCode:           statusPingInput.typeCode ?? createChatModel.typeCode,
											uniqueId:           statusPingInput.uniqueId,
											isCreateThreadAndSendMessage: true)
		guard let content = chatMessage.convertCodableToString() else{return}
		let asyncMessage = SendAsyncMessageVO(content:     content,
											  msgTTL:       createChatModel.msgTTL,
											  ttl: createChatModel.msgTTL,
											  peerName:     createChatModel.serverName,
											  priority:     createChatModel.msgPriority)
		
		sendMessageWithCallback(asyncMessageVO:     asyncMessage,
								callbacks:          nil,//[(StatusPingCallback(), statusPingInput.uniqueId)],
								sentCallback:       nil,
								deliverCallback:    nil,
								seenCallback:       nil)
	}
	
	
    /// DeleteUserInfoFromCache:
    /// this function will delete the UserInfo data from cahce database
    ///
    /// Inputs:
    /// - this method does not any input to send
    ///
    /// Outputs:
    /// - this method does not any output
    public func deleteUserInfoFromCache() {
        Chat.cacheDB.deleteUserInfo(isCompleted: nil)
    }
    
    
    // this function will generate a UUID to use in your request if needed (specially for uniqueId)
    // and it will return the UUID as String
    public func generateUUID() -> String {
        let myUUID = NSUUID().uuidString
        return myUUID
    }
    
    
    // this function will return Chate State as JSON
    public func getChatState() -> ChatFullStateModel? {
        return chatFullStateObject
    }
    
    // if your socket connection is disconnected you can reconnect it by calling this function
    public func reconnect() {
        asyncClient?.asyncReconnectSocket()
    }
    
    /// SetToken:
    /// by using this method you can set token to use on your requests
    ///
    /// Inputs:
    /// - this method gets 'newToken' as 'String' value
    ///
    /// Outputs:
    /// - this method does not any output
    public func setToken(newToken: String) {
        createChatModel?.token = newToken
    }
    
    // log out from async
    /// LogOut:
    /// by calling this metho, you  will delete all cache data and then logout from async
    ///
    /// Inputs:
    /// - this method does not any input
    ///
    /// Outputs:
    /// - this method does not any output
    public func logOut() {
        deleteCache()
        stopAllChatTimers()
        asyncClient?.disposeAsyncObject()
    }
    
    
    public func disconnectChat() {
        stopAllChatTimers()
        asyncClient?.disposeAsyncObject()
    }
    
}
