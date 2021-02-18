//
//  Chat.swift
//  Chat
//
//  Created by Mahyar Zhiani on 5/21/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import Foundation
import FanapPodAsyncSDK
import CoreData
import Alamofire
import SwiftyJSON
import Sentry
import Each


public class Chat {
    
    // MARK: - Chat Private initializer
    private init() {}
	
	
    private static var instance: Chat?
    
    open class var sharedInstance: Chat {
        if instance == nil {
            instance = Chat()
        }
        return instance!
    }
    
    // MARK: - properties that save callbacks on themselves
    // property to hold array of request that comes from client, but they have not completed yet (response didn't come yet)
    // the keys are uniqueIds of the requests
    static var map          = [String: CallbackProtocol]()
    static var mentionMap   = [String: CallbackProtocol]()
    static var spamMap      = [String: [CallbackProtocol]]()
    
    // property to hold array of Sent, Deliver and Seen requests that comes from client, but they have not completed yet, and response didn't come yet.
    // the keys are uniqueIds of the requests
    static var mapOnSent    = [String: CallbackProtocolWith3Calls]()
    static var mapOnDeliver = [String: [[String: CallbackProtocolWith3Calls]]]()
    static var mapOnSeen    = [String: [[String: CallbackProtocolWith3Calls]]]()
    
    // property to hold Sent callbecks to implement later, on somewhere else on the program
    public var userInfoCallbackToUser                    : callbackTypeAlias?
    public var getContactsCallbackToUser                 : callbackTypeAlias?
    public var threadsCallbackToUser                     : callbackTypeAlias?
    public var getAllUnreadMessagesCountCallbackToUser   : callbackTypeAlias?
    public var getHistoryCallbackToUser                  : callbackTypeAlias?
    public var getMentionListCallbackToUser              : callbackTypeAlias?
    public var threadParticipantsCallbackToUser          : callbackTypeAlias?
    public var createThreadCallbackToUser                : callbackTypeAlias?
    public var closeThreadCallbackToUser                 : callbackTypeAlias?
    public var addParticipantsCallbackToUser             : callbackTypeAlias?
    public var removeParticipantsCallbackToUser          : callbackTypeAlias?
    public var sendCallbackToUserOnSent                  : callbackTypeAlias?
    public var sendCallbackToUserOnDeliver               : callbackTypeAlias?
    public var sendCallbackToUserOnSeen                  : callbackTypeAlias?
    public var editMessageCallbackToUser                 : callbackTypeAlias?
    public var deleteMessageCallbackToUser               : callbackTypeAlias?
    public var muteThreadCallbackToUser                  : callbackTypeAlias?
    public var unmuteThreadCallbackToUser                : callbackTypeAlias?
    public var updateThreadInfoCallbackToUser            : callbackTypeAlias?
    public var blockCallbackToUser                       : callbackTypeAlias?
    public var unblockUserCallbackToUser                 : callbackTypeAlias?
    public var getBlockedListCallbackToUser              : callbackTypeAlias?
    public var leaveThreadCallbackToUser                 : callbackTypeAlias?
    public var spamPvThreadCallbackToUser                : callbackTypeAlias?
    public var getMessageSeenListCallbackToUser          : callbackTypeAlias?
    public var getMessageDeliverListCallbackToUser       : callbackTypeAlias?
    public var clearHistoryCallbackToUser                : callbackTypeAlias?
    public var setRoleToUserCallbackToUser               : callbackTypeAlias?
    public var removeRoleFromUserCallbackToUser          : callbackTypeAlias?
    public var pinThreadCallbackToUser                   : callbackTypeAlias?
    public var unpinThreadCallbackToUser                 : callbackTypeAlias?
    public var pinMessageCallbackToUser                  : callbackTypeAlias?
    public var unpinMessageCallbackToUser                : callbackTypeAlias?
    public var getContactNotSeenDurationCallbackToUser   : callbackTypeAlias?
    public var getCurrentUserRolesCallbackToUser         : callbackTypeAlias?
    public var updateChatProfileCallbackToUser           : callbackTypeAlias?
    public var joinPublicThreadCallbackToUser            : callbackTypeAlias?
    public var isPublicThreadNameAvailableCallbackToUser : callbackTypeAlias?
    public var statusPingCallbackToUser                  : callbackTypeAlias?
    
    // Bot callBacks
    public var addBotCommandCallbackToUser               : callbackTypeAlias?
    public var createBotCallbackToUser                   : callbackTypeAlias?
    public var startBotCallbackToUser                    : callbackTypeAlias?
    public var stopBotCallbackToUser                     : callbackTypeAlias?
        
    var sendRequestQueue:       [(type: Int, content: String)]          = []
    public var uploadRequest:   [(upload: Request, uniqueId: String)]   = []
    public var downloadRequest: [(download: Request, uniqueId: String)] = []
	var callbacksManager = CallbacksManager()
    var isChatReady = false {
        didSet {
            if isChatReady {
                for item in sendRequestQueue {
                    sendRequestToAsync(type: item.type, content: item.content)
                }
            }
        }
    }
    
    // the delegate property that the user class should make itself to be implment this delegate.
    // At first, the class sould confirm to ChatDelegates, and then implement the ChatDelegates methods
    public weak var delegate: ChatDelegates?{
        didSet{
            if(!isCreateObjectFuncCalled){
                _ = LogWithSwiftyBeaver(withLevel: .verbose)
                log.verbose("Please call createChatObject func before set delegate")
            }
        }
    }
    
    
    // create cache instance to use cache...
    static let cacheDB = Cache()
    
    var isCreateObjectFuncCalled = false
    
    // MARK: - setup properties
    var chatFullStateObject      	: ChatFullStateModel?
    
    var asyncClient              	: Async?
    var deviceId                 	: String?
    var peerId                   	: Int?
    var oldPeerId                	: Int?
    var userInfo                 	: User?
    
    var getHistoryCount          	: Int      = 50
    var getUserInfoRetry         	: Int      = 5
    var getUserInfoRetryCount    	: Int      = 0
    var chatPingMessageInterval  	: Int      = 20
    
    var lastReceivedMessageTime  	: Date?
    var lstRcvdMsgTimer          	: Each?
    var lastSentMessageTime      	: Date?
    var lstSntMsgTimer           	: Each?
    
    var createChatModel:CreateChatModel?
    
    
    public func createChatObject(object:CreateChatModel){
        isCreateObjectFuncCalled = true
        createChatModel = object
        initialize()
    }

    @available(*,deprecated, message: "use createChatObject(object:CreateChatModel) this method removed in future realese")
    public func createChatObject(socketAddress:             String,
                                 ssoHost:                   String,
                                 platformHost:              String,
                                 fileServer:                String,
                                 serverName:                String,
                                 token:                     String,
                                 mapApiKey:                 String?,
                                 mapServer:                 String,
                                 typeCode:                  String?,
                                 enableCache:               Bool,
                                 cacheTimeStampInSec:       Int?,
                                 msgPriority:               Int?,
                                 msgTTL:                    Int?,
                                 httpRequestTimeout:        Int?,
                                 actualTimingLog:           Bool?,
                                 wsConnectionWaitTime:      Double,
                                 connectionRetryInterval:   Int,
                                 connectionCheckTimeout:    Int,
                                 messageTtl:                Int,
                                 getDeviceIdFromToken:      Bool,
                                 captureLogsOnSentry:       Bool,
                                 maxReconnectTimeInterval:  Int?,
                                 reconnectOnClose:          Bool,
                                 localImageCustomPath:      URL?,
                                 localFileCustomPath:       URL?,
                                 deviecLimitationSpaceMB:   Int64?,
                                 showDebuggingLogLevel:     ConsoleLogLevel?) {
        createChatModel = CreateChatModel(socketAddress: socketAddress,
                        serverName: serverName,
                        token: token,
                        ssoHost: ssoHost,
                        platformHost: platformHost,
                        fileServer: fileServer,
                        mapApiKey: mapApiKey,
                        mapServer: mapServer,
                        typeCode: typeCode,
                        enableCache: enableCache,
                        cacheTimeStampInSec: cacheTimeStampInSec ?? (2 * 24) * (60 * 60),
                        msgPriority: msgPriority ?? 1,
                        msgTTL: msgTTL ?? 10,
                        httpRequestTimeout: httpRequestTimeout ?? 20,
                        actualTimingLog: actualTimingLog ?? false,
                        wsConnectionWaitTime: wsConnectionWaitTime,
                        connectionRetryInterval: connectionRetryInterval,
                        connectionCheckTimeout: connectionCheckTimeout,
                        messageTtl: messageTtl,
                        captureLogsOnSentry: captureLogsOnSentry,
                        maxReconnectTimeInterval: maxReconnectTimeInterval ?? 60,
                        reconnectOnClose: reconnectOnClose,
                        localImageCustomPath: localImageCustomPath,
                        localFileCustomPath: localFileCustomPath,
                        deviecLimitationSpaceMB: deviecLimitationSpaceMB ?? 100,
                        getDeviceIdFromToken : getDeviceIdFromToken,
                        showDebuggingLogLevel: showDebuggingLogLevel?.logLevel() ?? LogLevel.error
        )
        initialize()
    }
    
    func initialize(){
        if createChatModel?.captureLogsOnSentry == true {
            startCrashAnalytics()
        }
        
        if createChatModel?.getDeviceIdFromToken == false{
            getDeviceIdAndCreateAsync()
        }else{
            CreateAsync()
        }
        
        _ = DiskStatus.checkIfDeviceHasFreeSpace(needSpaceInMB: createChatModel?.deviecLimitationSpaceMB ?? 100, turnOffTheCache: true, errorDelegate: delegate)
    }
    
    @available(*,deprecated, renamed: "dispose")
    public func disposeChatObject() {
        dispose()
    }
    
    public func dispose() {
        stopAllChatTimers()
        asyncClient?.disposeAsyncObject()
        asyncClient = nil
        Chat.instance = nil
        print("Disposed Singleton instance")
    }
    
    private func startCrashAnalytics() {
        // Config for Sentry 4.3.1
        do {
            Client.shared = try Client(dsn: "https://5e236d8a40be4fe99c4e8e9497682333:5a6c7f732d5746e8b28625fcbfcbe58d@chatsentryweb.sakku.cloud/4")
            try Client.shared?.startCrashHandler()
        } catch let error {
            print("\(error)")
        }
        
        // Config for Sentry 5.0.5
        //        SentrySDK.start(options: [
        //            "dsn": "https://a06c7828c36d47c7bbb24605ba5d0d26@o376741.ingest.sentry.io/5198368",
        //            "debug": true // Helpful to see what's going on. (Enabled debug when first installing is always helpful)
        //        ])
        //        let event = Event(level: SentryLevel.error)
        //        event.message = "Test Sentry on Sakku"
        //        SentrySDK.capture(event: event)
        //        print("send message to sentry")
    }
    
    var isTypingCount = 0
    var sendIsTypingMessageTimer: (timer: RepeatingTimer?, onThread: Int)? {
        didSet {
            isTypingCount = 0
            if (sendIsTypingMessageTimer != nil) {
                sendIsTypingMessageTimer?.timer?.eventHandler = {
                    if (self.isTypingCount < 30) {
                        self.isTypingCount += 1
                        DispatchQueue.main.async {
                            let signalMessageInput = SendSignalMessageRequestModel(signalType:  SignalMessageType.IS_TYPING,
                                                                                   threadId:    self.sendIsTypingMessageTimer!.onThread,
                                                                                   uniqueId:    nil)
                            self.sendSignalMessage(input: signalMessageInput)
                        }
                    } else {
                        self.sendIsTypingMessageTimer!.timer?.suspend()
                        self.sendIsTypingMessageTimer = nil
                    }
                }
                sendIsTypingMessageTimer?.timer?.resume()
            }
        }
    }
    
    // MARK: - Timers
    var getUserInfoTimer: RepeatingTimer? {
        didSet {
            if (getUserInfoTimer != nil) {
                log.verbose("getUserInfoTimer valueChanged: \n staus = \(self.getUserInfoTimer!.state) - timeInterval = \(self.getUserInfoTimer!.timeInterval) \n isChatReady = \(isChatReady)", context: "Chat")
                self.getUserInfoTimer?.suspend()
                
                if !isChatReady {
                    DispatchQueue.global().async {
                        self.getUserInfoTimer?.eventHandler = {
                            if (self.getUserInfoRetryCount < self.getUserInfoRetry) {
                                DispatchQueue.main.async {
                                    self.makeChatReady()
                                }
                                self.getUserInfoTimer?.suspend()
                            }
                        }
                        self.getUserInfoTimer?.resume()
                    }
                }
            } else {
                log.verbose("getUserInfoTimer valueChanged to nil. \n isChatReady = \(isChatReady)", context: "Chat")
            }
        }
    }
    
    func lastReceivedMessageTimer(interval: TimeInterval) {
        guard let createChatModel = createChatModel else{return}
        self.lstRcvdMsgTimer = Each(interval).seconds
        lastReceivedMessageTime = Date()
        self.lstRcvdMsgTimer!.perform {
            if let lastReceivedMessageTimeBanged = self.lastReceivedMessageTime {
                let elapsed = Int(Date().timeIntervalSince(lastReceivedMessageTimeBanged))
                if (elapsed >= createChatModel.connectionCheckTimeout) {
                    DispatchQueue.main.async {
                        self.asyncClient?.asyncReconnectSocket()
                    }
                    self.lstRcvdMsgTimer!.restart()
                }
            }
            return .continue
        }
    }
    
    func lastSentMessageTimer(interval: TimeInterval) {
        lstSntMsgTimer = Each(interval).seconds
        lastSentMessageTime = Date()
        lstSntMsgTimer!.perform {
            if let lastSendMessageTimeBanged = self.lastSentMessageTime {
                let elapsed = Int(Date().timeIntervalSince(lastSendMessageTimeBanged))
                if (elapsed >= self.chatPingMessageInterval) && (self.isChatReady == true) {
                    DispatchQueue.main.async {
                        self.ping()
                    }
                    self.lstSntMsgTimer!.restart()
                }
            }
            return .continue
        }
    }
    
    // MARK: - create Async with the parameters
    public func CreateAsync() {
        guard let createChatModel = createChatModel else{return}
        asyncClient = Async(socketAddress:              createChatModel.socketAddress,
                            serverName:                 createChatModel.serverName,
                            deviceId:                   deviceId,
                            appId:                      nil,
                            peerId:                     nil,
                            messageTtl:                 createChatModel.messageTtl,
                            connectionRetryInterval:    createChatModel.connectionRetryInterval,
                            maxReconnectTimeInterval:   createChatModel.maxReconnectTimeInterval,
                            reconnectOnClose:           createChatModel.reconnectOnClose,
                            showDebuggingLogLevel:      createChatModel.showDebuggingLogLevel)
        asyncClient?.delegate = self
        asyncClient?.createSocket()
    }
    
    public func setGetUserInfoRetryCount(value: Int) {
        getUserInfoRetryCount = value
    }
    public func getGetUserInfoRetryCount() -> Int {
        return getUserInfoRetryCount
    }
    public func getGetUserInfoRetry() -> Int {
        return getUserInfoRetry
    }
	

}
