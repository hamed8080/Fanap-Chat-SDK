//
//  ParticipantManagementMethods.swift
//  FanapPodChatSDK
//
//  Created by MahyarZhiani on 2/3/1399 AP.
//  Copyright © 1399 Mahyar Zhiani. All rights reserved.
//

import Foundation
import FanapPodAsyncSDK

// MARK: - Public Methods -
// MARK: - Participant Management

extension Chat {
    
    
    // MARK: - Add ThreadParticipants
    /// AddParticipants:
    /// add participant to a specific thread.
    ///
    /// By calling this function, a request of type 11 (ADD_PARTICIPANT) will send throut Chat-SDK,
    /// then the response will come back as callbacks to client whose calls this function.
    ///
    /// Inputs:
    /// - you have to send your parameters as "AddParticipantsRequest" to this function
    ///
    /// Outputs:
    /// - It has 2 callbacks as responses.
    ///
    /// - parameter inputModel: (input) you have to send your parameters insid this model. (AddParticipantsRequest)
    /// - parameter uniqueId:   (response) it will returns the request 'UniqueId' that will send to server. (String)
    /// - parameter completion: (response) it will returns the response that comes from server to this request. (Any as! AddParticipantModel)
    public func addParticipants(inputModel addParticipantsInput:   AddParticipantsRequest,
                                uniqueId:       @escaping (String) -> (),
                                completion:     @escaping callbackTypeAlias) {
        guard let createChatModel = createChatModel else {return}
        log.verbose("Try to request to add participants with this parameters: \n \(addParticipantsInput)", context: "Chat")
        uniqueId(addParticipantsInput.uniqueId)
        
        addParticipantsCallbackToUser = completion
        
        let chatMessage = SendChatMessageVO(chatMessageVOType:  ChatMessageVOTypes.ADD_PARTICIPANT.intValue(),
											token:              createChatModel.token, content:            "\(addParticipantsInput.convertContentToJSONArray())",
											subjectId:          addParticipantsInput.threadId,
                                            typeCode:           addParticipantsInput.typeCode ?? createChatModel.typeCode,
                                            uniqueId:           addParticipantsInput.uniqueId,
                                            isCreateThreadAndSendMessage: true)
        
        let asyncMessage = SendAsyncMessageVO(content:      chatMessage.convertModelToString(),
                                              msgTTL:       createChatModel.msgTTL,
                                              peerName:     createChatModel.serverName,
                                              priority:     createChatModel.msgPriority)
        
        sendMessageWithCallback(asyncMessageVO:     asyncMessage,
                                callbacks:          [(AddParticipantsCallback(parameters: chatMessage), addParticipantsInput.uniqueId)],
                                sentCallback:       nil,
                                deliverCallback:    nil,
                                seenCallback:       nil)
    }
    
    
    // MARK: - Get My User Roles
    /// GetCurrentUserRoles:
    /// get my own roles on specific thread
    ///
    /// By calling this function, a request of type 53 (Get_Current_User_Roles) will send throut Chat-SDK,
    /// then the response will come back as callbacks to client whose calls this function.
    ///
    /// Inputs:
    /// - you have to send your parameters as "GetCurrentUserRolesRequest" to this function
    ///
    /// Outputs:
    /// - It has 3 callbacks as responses.
    ///
    /// - parameter inputModel:         (input) you have to send your parameters insid this model. (GetCurrentUserRolesRequest)
    /// - parameter getCacheResponse:   (input) specify if you want to get cache response for this request (Bool?)
    /// - parameter uniqueId:       (response) it will returns the request 'UniqueId' that will send to server. (String)
    /// - parameter completion:     (response) it will returns the response that comes from server to this request. (Any as! GetCurrentUserRolesModel)
    /// - parameter cacheResponse:  (response) there is another response that comes from CacheDB to the user, if user has set 'enableCache' vaiable to be true. (GetCurrentUserRolesModel)
    public func getCurrentUserRoles(inputModel getCurrentUserRolesInput:    GetCurrentUserRolesRequest,
                                    getCacheResponse:   Bool?,
                                    uniqueId:           @escaping (String) -> (),
                                    completion:         @escaping callbackTypeAlias,
                                    cacheResponse:      @escaping (GetCurrentUserRolesModel) -> () ) {
        guard let createChatModel = createChatModel else {return}
        uniqueId(getCurrentUserRolesInput.uniqueId)
        getCurrentUserRolesCallbackToUser = completion
        
        let chatMessage = SendChatMessageVO(chatMessageVOType:  ChatMessageVOTypes.GET_CURRENT_USER_ROLES.intValue(),
											token:              createChatModel.token, subjectId:          getCurrentUserRolesInput.threadId,
                                            typeCode:           getCurrentUserRolesInput.typeCode ?? createChatModel.typeCode,
                                            uniqueId:           getCurrentUserRolesInput.uniqueId,
                                            isCreateThreadAndSendMessage: true)
        
        let asyncMessage = SendAsyncMessageVO(content:      chatMessage.convertModelToString(),
                                              msgTTL:       createChatModel.msgTTL,
                                              peerName:     createChatModel.serverName,
                                              priority:     createChatModel.msgPriority)
        
        sendMessageWithCallback(asyncMessageVO:     asyncMessage,
                                callbacks:          [(GetCurrentUserRolesCallbacks(), getCurrentUserRolesInput.uniqueId)],
                                sentCallback:       nil,
                                deliverCallback:    nil,
                                seenCallback:       nil)
        
        // if cache is enabled by user, it will return cache result to the user
        if (getCacheResponse ?? createChatModel.enableCache) {
            if let cacheCurrentUserRoles = Chat.cacheDB.retrieveCurrentUserRoles(onThreadId: getCurrentUserRolesInput.threadId) {
                cacheResponse(cacheCurrentUserRoles)
            }
        }
        
    }
    
    
    // MARK: - Get ThreadParticipants
    /// GetThreadParticipants:
    /// get all participants in a specific thread.
    ///
    /// By calling this function, a request of type 27 (THREAD_PARTICIPANTS) will send throut Chat-SDK,
    /// then the response will come back as callbacks to client whose calls this function.
    ///
    /// Inputs:
    /// - you have to send your parameters as "GetThreadParticipantsRequest" to this function
    ///
    /// Outputs:
    /// - It has 3 callbacks as responses.
    ///
    /// - parameter inputModel:         (input) you have to send your parameters insid this model. (GetThreadParticipantsRequest)
    /// - parameter getCacheResponse:   (input) specify if you want to get cache response for this request (Bool?)
    /// - parameter uniqueId:           (response) it will returns the request 'UniqueId' that will send to server. (String)
    /// - parameter completion:         (response) it will returns the response that comes from server to this request. (Any as! GetThreadParticipantsModel)
    /// - parameter cacheResponse:      (response) there is another response that comes from CacheDB to the user, if user has set 'enableCache' vaiable to be true. (GetThreadParticipantsModel)
    public func getThreadParticipants(inputModel getThreadParticipantsInput:    GetThreadParticipantsRequest,
                                      getCacheResponse:                         Bool?,
                                      uniqueId:             @escaping (String) -> (),
                                      completion:           @escaping callbackTypeAlias,
                                      cacheResponse:        @escaping (GetThreadParticipantsModel) -> ()) {
        guard let createChatModel = createChatModel else {return}
        log.verbose("Try to request to get thread participants with this parameters: \n \(getThreadParticipantsInput)", context: "Chat")
        uniqueId(getThreadParticipantsInput.uniqueId)
        
        threadParticipantsCallbackToUser = completion
        
        let chatMessage = SendChatMessageVO(chatMessageVOType:  ChatMessageVOTypes.THREAD_PARTICIPANTS.intValue(),
											token:              createChatModel.token,
											content:            "\(getThreadParticipantsInput.convertContentToJSON())",
                                            subjectId:          getThreadParticipantsInput.threadId,
                                            typeCode:           getThreadParticipantsInput.typeCode ?? createChatModel.typeCode,
                                            uniqueId:           getThreadParticipantsInput.uniqueId,
                                            isCreateThreadAndSendMessage: true)
        
        let asyncMessage = SendAsyncMessageVO(content:      chatMessage.convertModelToString(),
                                              msgTTL:       createChatModel.msgTTL,
                                              peerName:     createChatModel.serverName,
                                              priority:     createChatModel.msgPriority)
        
        sendMessageWithCallback(asyncMessageVO:     asyncMessage,
                                callbacks:          [(GetThreadParticipantsCallbacks(parameters: chatMessage), getThreadParticipantsInput.uniqueId)],
                                sentCallback:       nil,
                                deliverCallback:    nil,
                                seenCallback:       nil)
        
        // if cache is enabled by user, it will return cache result to the user
        if (getCacheResponse ?? createChatModel.enableCache) {
            if let cacheThreadParticipants = Chat.cacheDB.retrieveThreadParticipants(admin:     getThreadParticipantsInput.admin,
                                                                                     ascending: true,
                                                                                     count:     getThreadParticipantsInput.count ?? 50,
                                                                                     offset:    getThreadParticipantsInput.offset ?? 0,
                                                                                     threadId:  getThreadParticipantsInput.threadId,
                                                                                     timeStamp: createChatModel.cacheTimeStampInSec) {
                cacheResponse(cacheThreadParticipants)
            }
        }
        
    }
    
    
    // MARK: - Remove ThreadParticipants
    /// RemoveParticipants:
    /// remove participants from a specific thread.
    ///
    /// By calling this function, a request of type 18 (REMOVE_PARTICIPANT) will send throut Chat-SDK,
    /// then the response will come back as callbacks to client whose calls this function.
    ///
    /// Inputs:
    /// - you have to send your parameters as "RemoveParticipantsRequest" to this function
    ///
    /// Outputs:
    /// - It has 2 callbacks as responses.
    ///
    /// - parameter inputModel: (input) you have to send your parameters insid this model. (RemoveParticipantsRequest)
    /// - parameter uniqueId:   (response) it will returns the request 'UniqueId' that will send to server. (String)
    /// - parameter completion: (response) it will returns the response that comes from server to this request. (Any as! RemoveParticipantModel)
    public func removeParticipants(inputModel removeParticipantsInput: RemoveParticipantsRequest,
                                   uniqueId:        @escaping (String) -> (),
                                   completion:      @escaping callbackTypeAlias) {
        guard let createChatModel = createChatModel else {return}
        log.verbose("Try to request to remove participants with this parameters: \n \(removeParticipantsInput)", context: "Chat")
        uniqueId(removeParticipantsInput.uniqueId)
        
        removeParticipantsCallbackToUser = completion
        
        let chatMessage = SendChatMessageVO(chatMessageVOType:  ChatMessageVOTypes.REMOVE_PARTICIPANT.intValue(),
											token:              createChatModel.token,
                                            content:            "\(removeParticipantsInput.participantIds)",
                                            subjectId:          removeParticipantsInput.threadId,
                                            typeCode:           removeParticipantsInput.typeCode ?? createChatModel.typeCode,
                                            uniqueId:           removeParticipantsInput.uniqueId,
                                            isCreateThreadAndSendMessage: true)
        
        let asyncMessage = SendAsyncMessageVO(content:      chatMessage.convertModelToString(),
                                              msgTTL:       createChatModel.msgTTL,
                                              peerName:     createChatModel.serverName,
                                              priority:     createChatModel.msgPriority)
        
        sendMessageWithCallback(asyncMessageVO:     asyncMessage,
                                callbacks:          [(RemoveParticipantsCallback(parameters: chatMessage), removeParticipantsInput.uniqueId)],
                                sentCallback:       nil,
                                deliverCallback:    nil,
                                seenCallback:       nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Get/Set/Remove AdminRole
    
    /// SetRole:
    /// set role to User
    ///
    /// By calling this function, a request of type 42 (SET_RULE_TO_USER) will send throut Chat-SDK,
    /// then the response will come back as callbacks to client whose calls this function.
    ///
    /// Inputs:
    /// - you have to send your parameters as "RoleRequestModel" to this function
    ///
    /// Outputs:
    /// - It has 3 callbacks as responses.
    ///
    /// - parameter inputModel:     (input) you have to send your parameters insid this model. (RoleRequestModel)
    /// - parameter uniqueId:       (response) it will returns the request 'UniqueId' that will send to server. (String)
    /// - parameter completion:     (response) it will returns the response that comes from server to this request. (Any as! UserRolesModel)
    /// - parameter cacheResponse:  (response) there is another response that comes from CacheDB to the user, if user has set 'enableCache' vaiable to be true. (UserRolesModel)
    public func setRole(inputModel setRoleInput: RoleRequestModel,
                        uniqueId:       @escaping (String) -> (),
                        completion:     @escaping callbackTypeAlias) {
        guard let createChatModel = createChatModel else {return}
        uniqueId(setRoleInput.uniqueId)
        setRoleToUserCallbackToUser = completion
        
        let chatMessage = SendChatMessageVO(chatMessageVOType:  ChatMessageVOTypes.SET_RULE_TO_USER.intValue(),
											token:              createChatModel.token,
                                            content:            "\(setRoleInput.convertContentToJSON())",
                                            subjectId:          setRoleInput.threadId,
                                            typeCode:           setRoleInput.typeCode ?? createChatModel.typeCode,
                                            uniqueId:           setRoleInput.uniqueId,
                                            isCreateThreadAndSendMessage: true)
        
        let asyncMessage = SendAsyncMessageVO(content:      chatMessage.convertModelToString(),
                                              msgTTL:       createChatModel.msgTTL,
                                              peerName:     createChatModel.serverName,
                                              priority:     createChatModel.msgPriority)
        
        sendMessageWithCallback(asyncMessageVO:     asyncMessage,
                                callbacks:          [(SetRoleToUserCallback(parameters: chatMessage), setRoleInput.uniqueId)],
                                sentCallback:       nil,
                                deliverCallback:    nil,
                                seenCallback:       nil)
    }
    
    
    
    /// RemoveRole:
    /// remove role from User
    ///
    /// By calling this function, a request of type 43 (REMOVE_RULE_FROM_USER) will send throut Chat-SDK,
    /// then the response will come back as callbacks to client whose calls this function.
    ///
    /// Inputs:
    /// - you have to send your parameters as "[RoleRequestModel]" to this function
    ///
    /// Outputs:
    /// - It has 3 callbacks as responses.
    ///
    /// - parameter inputModel:     (input) you have to send your parameters insid this model. ([RoleRequestModel])
    /// - parameter uniqueId:       (response) it will returns the request 'UniqueId' that will send to server. (String)
    /// - parameter completion:     (response) it will returns the response that comes from server to this request. (Any as! UserRolesModel)
    /// - parameter cacheResponse:  (response) there is another response that comes from CacheDB to the user, if user has set 'enableCache' vaiable to be true. (UserRolesModel)
    public func removeRole(inputModel removeRoleInput: RoleRequestModel,
                           uniqueId:        @escaping (String) -> (),
                           completion:      @escaping callbackTypeAlias) {
        guard let createChatModel = createChatModel else {return}
        uniqueId(removeRoleInput.uniqueId)
        removeRoleFromUserCallbackToUser = completion
        
        let chatMessage = SendChatMessageVO(chatMessageVOType:  ChatMessageVOTypes.REMOVE_ROLE_FROM_USER.intValue(),
											token:              createChatModel.token,
                                            content:            "\(removeRoleInput.convertContentToJSON())",
                                            subjectId:          removeRoleInput.threadId,
                                            typeCode:           removeRoleInput.typeCode ?? createChatModel.typeCode,
                                            uniqueId:           removeRoleInput.uniqueId,
                                            isCreateThreadAndSendMessage: true)
        
        let asyncMessage = SendAsyncMessageVO(content:      chatMessage.convertModelToString(),
                                              msgTTL:       createChatModel.msgTTL,
                                              peerName:     createChatModel.serverName,
                                              priority:     createChatModel.msgPriority)
        
        sendMessageWithCallback(asyncMessageVO:     asyncMessage,
                                callbacks:          [(SetRoleToUserCallback(parameters: chatMessage), removeRoleInput.uniqueId)],
                                sentCallback:       nil,
                                deliverCallback:    nil,
                                seenCallback:       nil)
    }
    
    
    /// setAuditor:
    /// setRoleTo a User on a peer to peer thread
    ///
    /// By calling this function, a request of type 42 (SET_RULE_TO_USER) will send throut Chat-SDK,
    /// then the response will come back as callbacks to client whose calls this function.
    ///
    /// Inputs:
    /// - you have to send your parameters as "AddRemoveAuditorRequestModel" to this function
    ///
    /// Outputs:
    /// - It has 3 callbacks as responses.
    ///
    /// - parameter inputModel:     (input) you have to send your parameters insid this model. (AddRemoveAuditorRequestModel)
    /// - parameter uniqueId:       (response) it will returns the request 'UniqueId' that will send to server. (String)
    /// - parameter completion:     (response) it will returns the response that comes from server to this request. (Any as! UserRolesModel)
    /// - parameter cacheResponse:  (response) there is another response that comes from CacheDB to the user, if user has set 'enableCache' vaiable to be true. (UserRolesModel)
    public func setAuditor(inputModel setAuditorInput:  AddRemoveAuditorRequestModel,
                           uniqueId:        @escaping (String) -> (),
                           completion:      @escaping callbackTypeAlias) {
        
        let setRoleModel = SetRemoveRoleModel(userId:   setAuditorInput.userId,
                                              roles:    setAuditorInput.roles)
        let setRoleInputModel = RoleRequestModel(userRoles: [setRoleModel],
                                                 threadId:  setAuditorInput.threadId,
                                                 typeCode:  setAuditorInput.typeCode,
                                                 uniqueId:  setAuditorInput.uniqueId)
        
        setRole(inputModel: setRoleInputModel, uniqueId: { (setRoleUniqueId) in
            uniqueId(setRoleUniqueId)
        }, completion: { (theServerResponse) in
            completion(theServerResponse)
        })
    }
    
    
    
    /// removeAuditorFromThread:
    /// removeRole From a User on a peer to peer thread
    ///
    /// By calling this function, a request of type 42 (SET_RULE_TO_USER) will send throut Chat-SDK,
    /// then the response will come back as callbacks to client whose calls this function.
    ///
    /// Inputs:
    /// - you have to send your parameters as "AddRemoveAuditorRequestModel" to this function
    ///
    /// Outputs:
    /// - It has 3 callbacks as responses.
    ///
    /// - parameter inputModel:     (input) you have to send your parameters insid this model. (AddRemoveAuditorRequestModel)
    /// - parameter uniqueId:       (response) it will returns the request 'UniqueId' that will send to server. (String)
    /// - parameter completion:     (response) it will returns the response that comes from server to this request. (Any as! UserRolesModel)
    /// - parameter cacheResponse:  (response) there is another response that comes from CacheDB to the user, if user has set 'enableCache' vaiable to be true. (UserRolesModel)
    public func removeAuditor(inputModel removeAuditorInput:    AddRemoveAuditorRequestModel,
                              uniqueId:         @escaping (String) -> (),
                              completion:       @escaping callbackTypeAlias) {
        
        let removeRoleModel = SetRemoveRoleModel(userId:     removeAuditorInput.userId,
                                                 roles:      removeAuditorInput.roles)
        let removeRoleInputModel = RoleRequestModel(userRoles:  [removeRoleModel],
                                                    threadId:   removeAuditorInput.threadId,
                                                    typeCode:   removeAuditorInput.typeCode,
                                                    uniqueId:   removeAuditorInput.uniqueId)
        
        removeRole(inputModel: removeRoleInputModel, uniqueId: { (removeRoleUniqueId) in
            uniqueId(removeRoleUniqueId)
        }, completion: { (theServerResponse) in
            completion(theServerResponse)
        })
        
    }
    
    
    
    
    
}
