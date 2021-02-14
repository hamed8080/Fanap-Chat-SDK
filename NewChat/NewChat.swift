//
//  NewChat.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/13/21.
//

import Foundation
import FanapPodAsyncSDK

typealias MyCallback<T> = (T)->()

class NewChat {
	
	private init(){}
	public static var shared = NewChat()
	
	private var callbacks:[String:(Any)->()] = [:]
	var createChatModel:CreateChatModel?
	var isCreateObjectFuncCalled = false
	var asyncClient              	: Async?
	
	public weak var delegate: ChatDelegates?{
		didSet{
			if(!isCreateObjectFuncCalled){
				print("Please call createChatObject func before set delegate")
			}
		}
	}
	
	
	public func createChatObject(object:CreateChatModel){
		createChatModel = object
		initialize(getDeviceIdFromToken: object.getDeviceIdFromToken)
	}
	
	func initialize(getDeviceIdFromToken:Bool){
		if createChatModel?.captureLogsOnSentry == true {
			//startCrashAnalytics()
		}
	}
	
	public func getBlockedContacts(_ blockedContactRequest : BlockedListRequest,
								   typeCode:String? = nil,
								   uniqueId:String? = nil,
								   completion:@escaping MyCallback<BlockedContacts>,
								   uniqueIdResult:((String)->())? = nil){
		
		sendAsyncMessage(request: blockedContactRequest,callback: completion, uniqueId:"test")
	}
	
	public func sendAsyncMessage<I , O>(request:I, callback:@escaping MyCallback<O>, uniqueId: String){
		addToCallbacks(callback , uniqueId: uniqueId)
	}
	
	private func addToCallbacks<R>(_ callback:@escaping MyCallback<R> , uniqueId:String){
		callbacks[uniqueId] = callback as? (Any)->()
	}
	
	private func getCallback<T>(uniqueId:String) -> MyCallback<T>?{
		return callbacks[uniqueId]
	}
	
	public func CreateAsync() {
		guard let createChatModel = createChatModel else{return}
		asyncClient = Async(socketAddress:               createChatModel.socketAddress,
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
	
}

class BlockedContacts{
	public var contentCount :       Int            = 0
	public var hasNext      :            Bool      = false
	public var nextOffset   :         Int          = 0
	public var blockedList  :        [BlockedUser] = []
}
