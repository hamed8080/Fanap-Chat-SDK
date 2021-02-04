//
//  BotManagementMethods.swift
//  FanapPodChatSDK
//
//  Created by MahyarZhiani on 2/5/1399 AP.
//  Copyright © 1399 Mahyar Zhiani. All rights reserved.
//

import Foundation
import FanapPodAsyncSDK
import SwiftyJSON

// MARK: - Public Methods
// MARK: - Bot Management

extension Chat {
    
    // MARK: - Create Bot
    /// CreateBot:
    /// it will create a bot
    ///
    /// By calling this function, HTTP request of type (CREATE_BOT) will send throut Chat-SDK,
    /// then the response will come back as callbacks to client whose calls this function.
    ///
    /// Inputs:
    /// - you have to send your parameters as "CreateBotRequest" to this function
    ///
    /// Outputs:
    /// - It has 3 callbacks as responses.
    ///
    /// - parameters:
    ///     - inputModel:   (input) you have to send your parameters insid this model. (AddContactRequest)
    ///     - uniqueId:     (response) it will returns the request 'UniqueId' that will send to server. (String)
    ///     - completion:   (response) it will returns the response that comes from server to this request. (Any as! CreateBotResponse)
    public func createBot(inputModel createBotInput:  CreateBotRequest,
                          uniqueId:                 @escaping (String) -> (),
                          completion:               @escaping callbackTypeAlias) {
        guard let createChatModel = createChatModel else {return}
        log.verbose("Try to request to create bot with this parameters: \n \(createBotInput.botName)", context: "Chat")
        uniqueId(createBotInput.uniqueId)
        
        createBotCallbackToUser = completion
        
        let chatMessage = SendChatMessageVO(chatMessageVOType:  ChatMessageVOTypes.CREATE_BOT.intValue(),
											token:              createChatModel.token,
                                            content:            createBotInput.botName,
                                            typeCode:           createBotInput.typeCode ?? createChatModel.typeCode,
                                            uniqueId:           createBotInput.uniqueId,
                                            isCreateThreadAndSendMessage: true)
        
        let asyncMessage = SendAsyncMessageVO(content:      chatMessage.convertModelToString(),
                                              msgTTL:       createChatModel.msgTTL,
                                              peerName:     createChatModel.serverName,
                                              priority:     createChatModel.msgPriority)
        
        sendMessageWithCallback(asyncMessageVO:     asyncMessage,
                                callbacks:          [(CreateBotCallback(), createBotInput.uniqueId)],
                                sentCallback:       nil,
                                deliverCallback:    nil,
                                seenCallback:       nil)
    }
    
    
    
    // MARK: - Add Bot Commands
    /// AddBotCommand:
    /// it will add a bot command
    ///
    /// By calling this function, HTTP request of type (CONFIG_BOT_COMMAND) will send throut Chat-SDK,
    /// then the response will come back as callbacks to client whose calls this function.
    ///
    /// Inputs:
    /// - you have to send your parameters as "AddBotCommandRequest" to this function
    ///
    /// Outputs:
    /// - It has 3 callbacks as responses.
    ///
    /// - parameters:
    ///     - inputModel:   (input) you have to send your parameters insid this model. (AddBotCommandRequest)
    ///     - uniqueId:     (response) it will returns the request 'UniqueId' that will send to server. (String)
    ///     - completion:   (response) it will returns the response that comes from server to this request. (Any as! AddBotCommandResponse)
    public func addBotCommand(inputModel addBotCommandsInput:    AddBotCommandRequest,
                              uniqueId:         @escaping (String) -> (),
                              completion:       @escaping callbackTypeAlias) {
        guard let createChatModel = createChatModel else {return}
        log.verbose("Try to request to add bot command with this parameters: \n \(addBotCommandsInput.botName)", context: "Chat")
        uniqueId(addBotCommandsInput.uniqueId)
        
        addBotCommandCallbackToUser = completion
        
        let chatMessage = SendChatMessageVO(chatMessageVOType:  ChatMessageVOTypes.DEFINE_BOT_COMMAND.intValue(),
											token:              createChatModel.token,
											content:            "\(addBotCommandsInput.convertContentToJSON())",
                                            typeCode:           addBotCommandsInput.typeCode ?? createChatModel.typeCode,
                                            uniqueId:           addBotCommandsInput.uniqueId,
                                            isCreateThreadAndSendMessage: true)
        
        let asyncMessage = SendAsyncMessageVO(content:      chatMessage.convertModelToString(),
                                              msgTTL:       createChatModel.msgTTL,
                                              peerName:     createChatModel.serverName,
                                              priority:     createChatModel.msgPriority)
        
        sendMessageWithCallback(asyncMessageVO:     asyncMessage,
                                callbacks:          [(AddBotCommandCallback(), addBotCommandsInput.uniqueId)],
                                sentCallback:       nil,
                                deliverCallback:    nil,
                                seenCallback:       nil)
    }
    
    
    
    // MARK: - Start Bot
    /// StartBot:
    /// it will stat a bot on a thread
    ///
    /// By calling this function, HTTP request of type (START_BOT) will send throut Chat-SDK,
    /// then the response will come back as callbacks to client whose calls this function.
    ///
    /// Inputs:
    /// - you have to send your parameters as "StartStopBotRequest" to this function
    ///
    /// Outputs:
    /// - It has 3 callbacks as responses.
    ///
    /// - parameters:
    ///     - inputModel:   (input) you have to send your parameters insid this model. (StartStopBotRequest)
    ///     - uniqueId:     (response) it will returns the request 'UniqueId' that will send to server. (String)
    ///     - completion:   (response) it will returns the response that comes from server to this request. (Any as! StartStopBotResponse)
    public func startBot(inputModel startBotInput:  StartStopBotRequest,
                         uniqueId:      @escaping (String) -> (),
                         completion:    @escaping callbackTypeAlias) {
        guard let createChatModel = createChatModel else {return}
        log.verbose("Try to request to start bot with this parameters: \n botName = \(startBotInput.botName) \n threadId = \(startBotInput.threadId)", context: "Chat")
        uniqueId(startBotInput.uniqueId)
        
        startBotCallbackToUser = completion
        
        let chatMessage = SendChatMessageVO(chatMessageVOType:  ChatMessageVOTypes.START_BOT.intValue(),
											token:              createChatModel.token,
											content:            "\(startBotInput.convertContentToJSON())",
                                            subjectId:          startBotInput.threadId,
                                            typeCode:           startBotInput.typeCode ?? createChatModel.typeCode,
                                            uniqueId:           startBotInput.uniqueId,
                                            isCreateThreadAndSendMessage: true)
        
        let asyncMessage = SendAsyncMessageVO(content:      chatMessage.convertModelToString(),
                                              msgTTL:       createChatModel.msgTTL,
                                              peerName:     createChatModel.serverName,
                                              priority:     createChatModel.msgPriority)
        
        sendMessageWithCallback(asyncMessageVO:     asyncMessage,
                                callbacks:          [(StartBotCallback(), startBotInput.uniqueId)],
                                sentCallback:       nil,
                                deliverCallback:    nil,
                                seenCallback:       nil)
    }
    
    
    // MARK: - Stop Bot
    /// StopBot:
    /// it will stop a bot on a thread
    ///
    /// By calling this function, HTTP request of type (STOP_BOT) will send throut Chat-SDK,
    /// then the response will come back as callbacks to client whose calls this function.
    ///
    /// Inputs:
    /// - you have to send your parameters as "StartStopBotRequest" to this function
    ///
    /// Outputs:
    /// - It has 3 callbacks as responses.
    ///
    /// - parameters:
    ///     - inputModel:   (input) you have to send your parameters insid this model. (StartStopBotRequest)
    ///     - uniqueId:     (response) it will returns the request 'UniqueId' that will send to server. (String)
    ///     - completion:   (response) it will returns the response that comes from server to this request. (Any as! StartStopBotResponse)
    public func stopBot(inputModel stopBotInput:    StartStopBotRequest,
                        uniqueId:       @escaping (String) -> (),
                        completion:     @escaping callbackTypeAlias) {
        guard let createChatModel = createChatModel else {return}
        log.verbose("Try to request to stop bot with this parameters: \n botName = \(stopBotInput.botName) \n threadId = \(stopBotInput.threadId)", context: "Chat")
        uniqueId(stopBotInput.uniqueId)
        
        stopBotCallbackToUser = completion
        
        let chatMessage = SendChatMessageVO(chatMessageVOType:  ChatMessageVOTypes.STOP_BOT.intValue(),
											token:              createChatModel.token,
                                            content:            "\(stopBotInput.convertContentToJSON())",
                                            subjectId:          stopBotInput.threadId,
                                            typeCode:           stopBotInput.typeCode ?? createChatModel.typeCode,
                                            uniqueId:           stopBotInput.uniqueId,
                                            isCreateThreadAndSendMessage: true)
        
        let asyncMessage = SendAsyncMessageVO(content:      chatMessage.convertModelToString(),
                                              msgTTL:       createChatModel.msgTTL,
                                              peerName:     createChatModel.serverName,
                                              priority:     createChatModel.msgPriority)
        
        sendMessageWithCallback(asyncMessageVO:     asyncMessage,
                                callbacks:          [(StopBotCallback(), stopBotInput.uniqueId)],
                                sentCallback:       nil,
                                deliverCallback:    nil,
                                seenCallback:       nil)
    }
    
    
    
}
