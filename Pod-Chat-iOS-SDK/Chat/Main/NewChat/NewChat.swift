//
//  NewChat.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/13/21.
//

import Foundation
import FanapPodAsyncSDK
import Alamofire
import SwiftyJSON

enum CallbackType : Int{
    case BlockedContacts = 0
}

class CallbacksManager{
    
    private var blockedContactsCallBacks : [String : (BlockedContacts)->()] = [:]
    
    func addCallback<T:Decodable>(type:CallbackType ,uniqueId:String , callBack:@escaping (T)->() ) {
        switch type {
        case .BlockedContacts:
            blockedContactsCallBacks[uniqueId] = (callBack as! (BlockedContacts) ->())
            break
        }
    }
}

public class NewChat {
   
	private init(){}
	public static var shared = NewChat()
	
    private var callbacks:[String:Any] = [:]
    
    
    //private var callbacks:Dictionary<String, MyCallback> = [:]

	var createChatModel:CreateChatModel?
	var isCreateObjectFuncCalled = false
	var asyncClient              	: Async?
    let asyncDelegate = AsyncDelegateImplementaion()
    var callbacksManager = CallbacksManager()
	
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
	
	private func initialize(getDeviceIdFromToken:Bool){
		if createChatModel?.captureLogsOnSentry == true {
			//startCrashAnalytics()
		}
        getDeviceId()
	}
	
    public func getBlockedContacts<T:BlockedContacts>(_ blockedContactRequest : BlockedListRequest,
								   typeCode:String? = nil,
								   uniqueId:String? = nil,
                                   completion: @escaping (T)->(),
								   uniqueIdResult:((String)->())? = nil){
		
        guard let createChatModel = createChatModel , let content = blockedContactRequest.convertCodableToString() else {return}
        callbacksManager.addCallback(type:.BlockedContacts , uniqueId: uniqueId ?? "test", callBack: completion)
//        blockedContactsCallbacks[uniqueId ?? "terst"] = completion
        let chatMessage = SendChatMessageVO(chatMessageVOType:  ChatMessageVOTypes.GET_BLOCKED.intValue(),
                                            token:              createChatModel.token,
                                            content:            "\(content)",
                                            typeCode:           typeCode ?? createChatModel.typeCode ?? "default",
                                            uniqueId:           uniqueId,
                                            isCreateThreadAndSendMessage: true)
        
        let asyncMessage = SendAsyncMessageVO(content:      chatMessage.convertModelToString(),
                                              msgTTL:       createChatModel.msgTTL,
                                              peerName:     createChatModel.serverName,
                                              priority:     createChatModel.msgPriority)
        let chatMessageVO = SendChatMessageVO(content: asyncMessage.content.convertToJSON())
        let contentToSend = asyncMessage.convertModelToString()
        
//        sendMessageWithCallback(asyncMessageVO:     asyncMessage,
//                                callbacks:          [(GetBlockedUsersCallbacks(parameters: chatMessage), unqId)],
//                                sentCallback:       nil,
//                                deliverCallback:    nil,
//                                seenCallback:       nil)
        
        //completion(BlockedContacts.init(),uniqueId)
        
//        sendAsyncMessage(request: blockedContactRequest,callback: completion, uniqueId:uniqueId ?? UUID().uuidString)
	}
	
//	private func sendAsyncMessage<I>(request:I, callback:@escaping MyCallback<Any>, uniqueId: String){
		//addToCallbacks(callback , uniqueId: uniqueId)
//	}
	
//	private func addToCallbacks(_ callback:@escaping MyCallback<AnyClass> , uniqueId:String){
//		callbacks[uniqueId] = callback
//	}
	
//	private func getCallback<T>(uniqueId:String) -> MyCallback<T>?{
//		return callbacks[uniqueId]
//	}
	
	private func CreateAsync() {
		guard let createChatModel = createChatModel else{return}
		asyncClient = Async(socketAddress:               createChatModel.socketAddress,
							serverName:                 createChatModel.serverName,
                            deviceId:                   createChatModel.deviceId,
							appId:                      nil,
							peerId:                     nil,
							messageTtl:                 createChatModel.messageTtl,
							connectionRetryInterval:    createChatModel.connectionRetryInterval,
							maxReconnectTimeInterval:   createChatModel.maxReconnectTimeInterval,
							reconnectOnClose:           createChatModel.reconnectOnClose,
							showDebuggingLogLevel:      createChatModel.showDebuggingLogLevel)
		asyncClient?.delegate = asyncDelegate
		asyncClient?.createSocket()
	}
    
    private func getDeviceId(){
        guard let createChatModel = createChatModel else{return}
        let headers: HTTPHeaders = ["Authorization": "Bearer \(createChatModel.token)"]
        let url = createChatModel.ssoHost + SERVICES_PATH.SSO_DEVICES.rawValue
        Networking.request(ofType: DevicesResposne.self,
                           from: url,
                           withMethod: .get,
                           withHeaders: headers,
                           encodableRequest: nil) { [weak self] devicesResponse in
            if let device = devicesResponse?.devices?.first(where: {$0.current == true}){
                self?.createChatModel?.deviceId = device.uid
            }
        }
    }
}

class AsyncDelegateImplementaion:AsyncDelegates{
    
    func asyncSendMessage(params: Any) {
        
    }
    
    func asyncConnect(newPeerID: Int) {
        
    }
    
    func asyncDisconnect() {
        
    }
    
    func asyncReconnect(newPeerID: Int) {
        
    }
    
    func asyncReceiveMessage(params: JSON) {
        
    }
    
    func asyncReady() {
        
    }
    
    func asyncStateChanged(socketState: SocketStateType, timeUntilReconnect: Int, deviceRegister: Bool, serverRegister: Bool, peerId: Int) {
        
    }
    
    func asyncError(errorCode: Int, errorMessage: String, errorEvent: Any?) {
        
    }
    
}

public class BlockedContacts : Decodable{
	public var contentCount : Int               = 0
	public var hasNext      : Bool              = false
	public var nextOffset   : Int               = 0
	public var blockedList  : [BlockedUser]     = []
}

class DevicesResposne : Codable{
    let devices: [Device]?
    let offset : Int?
    let size   : Int?
    let total  : Int?
}
class Device : Codable {
    var agent          : String?
    var browser        : String?
    var current        : Bool?
    var deviceType     : String?
    var id             : Int?
    var ip             : String?
    var language       : String?
    var lastAccessTime : Int?
    var os             : String?
    var osVersion      : String?
    var uid            : String?
}
