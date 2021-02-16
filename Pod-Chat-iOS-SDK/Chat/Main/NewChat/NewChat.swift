import FanapPodAsyncSDK
import Sentry
import Foundation
import Alamofire
import SwiftyJSON

public enum CallbackType{
	case BlockedContacts
}
public struct ChatError:Decodable{
	let code:Int?
	let message:String?
	let content:String?
}
public class ChatResponse<T>{
	public var result:T?
	public var error:ChatError?
}
class CallbacksManager{
	
	var errorCallbacks :[String :(ChatError)->()] = [:]
	var blockedContactsCallBacks : [String : (BlockedContacts)->()] = [:]
	var contactsCallBacks : [String : (Contact , ChatError)->()] = [:]
	
	var callbacks:[String:(ChatResponse<Any>)->()] = [:]
	
	func addCallback<T:Decodable>(type:CallbackType , uniqueId:String , callback:((T)->())? ,errorResult: ((ChatError)->())? = nil) {
		
		
		if let errorResult = errorResult{
			errorCallbacks[uniqueId] = errorResult
		}
		guard let callback = callback else {return}
		switch type {
			case .BlockedContacts:
				blockedContactsCallBacks[uniqueId] = (callback as! (BlockedContacts) ->())
				break
		}
	}
	
	func addTest(completion:@escaping (ChatResponse<Any>)->()){
		callbacks["hsd"] = completion
	}
	
	func removeError(uniqueId:String ){
		errorCallbacks.removeValue(forKey: uniqueId)
	}
}

public class NewChat {
   
	private init(){}
	public static var shared = NewChat()

	var createChatModel:CreateChatModel?
	var isCreateObjectFuncCalled = false
	var asyncClient              	: Async?
	lazy var asyncDelegate:AsyncDelegateImplementaion = { return AsyncDelegateImplementaion(self) }()
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
		if createChatModel?.getDeviceIdFromToken == false{
			CreateAsync()
		}
	}
	
    public func getBlockedContacts<T:BlockedContacts>(_ blockedContactRequest : BlockedListRequest,
								   typeCode:String? = nil,
								   uniqueId:String? = nil,
                                   completion: @escaping (T)->(),
								   uniqueIdResult:((String)->())? = nil,
								   errorResult:((ChatError)->())? = nil
								   ){
		
        guard let createChatModel = createChatModel else {return}
		let unqId = uniqueId ?? UUID().uuidString
		uniqueIdResult?(unqId)
		let typeCode = typeCode ?? createChatModel.typeCode ?? "default"
		prepareToSendAsync(req: blockedContactRequest,
						   uniqueId: unqId,
						   typeCode: typeCode ,
						   messgaeType: ChatMessageVOTypes.GET_BLOCKED,
						   callBackType: .BlockedContacts,
						   completion: completion,
						   errorResult:errorResult
						   )
	}
	
	public func addtest(completions:@escaping (ChatResponse<BlockedContacts>)->()){
		callbacksManager.addTest(completion: completions)
	}
	
	
	private func prepareToSendAsync<T:Encodable , D:Decodable>(req:T ,
															   uniqueId:String ,
															   typeCode:String ,
															   messgaeType:ChatMessageVOTypes ,
															   callBackType: CallbackType,
															   completion: ((D)->())? = nil,
															   errorResult:((ChatError)->())? = nil
	){
		
		guard let content = req.convertCodableToString() , let createChatModel = createChatModel else {return}
		let chatMessage = NewSendChatMessageVO(chatMessageVOType:  messgaeType.intValue(),
											token:              createChatModel.token,
											content:            "\(content)",
											typeCode:           typeCode,
											uniqueId:           uniqueId,
											isCreateThreadAndSendMessage: true)
		
		let asyncMessage = NewSendAsyncMessageVO(content:      chatMessage.convertCodableToString() ?? "",
											  ttl:       createChatModel.msgTTL,
											  peerName:     createChatModel.serverName,
											  priority:     createChatModel.msgPriority
											  )
		
		
		callbacksManager.addCallback(type:callBackType , uniqueId: uniqueId , callback: completion , errorResult: errorResult)
		sendToAsync(asyncMessageVO: asyncMessage)
	}
	
	private func sendToAsync(asyncMessageVO:NewSendAsyncMessageVO){
		guard let content = asyncMessageVO.convertCodableToString() else { return }
		asyncClient?.pushSendData(type: asyncMessageVO.pushMsgType, content: content)
//		runSendMessageTimer()
	}
	
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
    
	let chat:NewChat
	
	init(_ chat:NewChat) {
		self.chat = chat
	}
    func asyncSendMessage(params: Any) {
        print("asyncSendMessage is sended with data: \(params)")
    }
    
    func asyncConnect(newPeerID: Int) {
		print("async Connected with peerId: \(newPeerID)")
    }
    
    func asyncDisconnect() {
		print("async disconnected")
    }
    
    func asyncReconnect(newPeerID: Int) {
		print("async reconnected")
    }
    
    func asyncReceiveMessage(params: JSON) {
		print("async recivedMeaage with data \(params)")
		if let data = try? params.rawData(){
			ReciveMessageFactory.invokeCallback(data: data , chat: chat)
		}
    }
    
    func asyncReady() {
        print("async Ready called")
    }
    
    func asyncStateChanged(socketState: SocketStateType, timeUntilReconnect: Int, deviceRegister: Bool, serverRegister: Bool, peerId: Int) {
        print("asyncStateChanged called sockeState: \(socketState)")
    }
    
    func asyncError(errorCode: Int, errorMessage: String, errorEvent: Any?) {
        print("asyncError called - errorCode:\(errorCode) - errorMessage:\(errorMessage) - errorEvent : \(errorEvent ?? "")")
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

struct NewSendChatMessageVO:Encodable {
	
	let chatMessageVOType    : Int
	let token               : String
	var content            : String? = nil
	var messageType:        Int? = nil
	var metadata:           String? = nil
	var repliedTo:          Int?    = nil
	var systemMetadata:     String?  = nil
	var subjectId:          Int?    = nil
	var tokenIssuer:        Int?    = nil
	var typeCode:           String? = nil
	var uniqueId:           String? = nil
	var uniqueIds:          [String]? = nil
	var isCreateThreadAndSendMessage: Bool = false
	
	private enum CodingKeys : String ,CodingKey{
		case type
		case tokenIssuer
		case token
		
		case content
		case messageType
		case metadata
		case repliedTo
		case subjectId
		case systemMetadata
		case typeCode
		case uniqueId
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try? container.encodeIfPresent(chatMessageVOType, forKey: .type)
		try? container.encodeIfPresent(token, forKey: .token)
		try? container.encodeIfPresent(tokenIssuer ?? 1, forKey: .tokenIssuer)
		try? container.encodeIfPresent(content, forKey: .content)
		try? container.encodeIfPresent(messageType, forKey: .messageType)
		try? container.encodeIfPresent(metadata, forKey: .metadata)
		try? container.encodeIfPresent(repliedTo, forKey: .repliedTo)
		try? container.encodeIfPresent(subjectId, forKey: .subjectId)
		try? container.encodeIfPresent(systemMetadata, forKey: .systemMetadata)
		try? container.encodeIfPresent(typeCode, forKey: .typeCode)
		if let uniqueIds = uniqueIds {
			try? container.encodeIfPresent("\(uniqueIds)", forKey: .uniqueId)
		}else{
			try? container.encodeIfPresent(uniqueId, forKey: .uniqueId)
		}
	}
	
}

struct NewSendAsyncMessageVO :Encodable {
	var content     :        String
	let ttl         :         Int
	let peerName    :       String
	let priority    :       Int
	var pushMsgType :     Int = 3
	
	
	private enum CodingKeys: String , CodingKey{
		case content
		case peerName
		case priority
		case ttl
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try? container.encodeIfPresent(content, forKey: .content)
		try? container.encodeIfPresent(peerName, forKey: .peerName)
		try? container.encodeIfPresent(priority, forKey: .priority)
		try? container.encodeIfPresent(ttl, forKey: .ttl)
	}
}


class ReciveMessageFactory{
	
	class func invokeCallback(data:Data , chat:NewChat) {
		guard let asyncMessage = try? JSONDecoder().decode(AsyncMessage.self, from: data) else {return}
		guard let chatMessageData  = asyncMessage.content.data(using: .utf8) else{return}
		guard let chatMessage =  try? JSONDecoder().decode(NewChatMessage.self, from: chatMessageData) else{return}
		print("asyncMessage decoded: \(chatMessage)")
		
		switch chatMessage.type {
			
			case .ADD_PARTICIPANT:
				break
			case .ALL_UNREAD_MESSAGE_COUNT:
				break
			case .BLOCK:
				break
			case .BOT_MESSAGE:
				break
			case .CHANGE_TYPE:
				break
			case .CLEAR_HISTORY:
				break
			case .CLOSE_THREAD:
				break
			case .CONTACTS_LAST_SEEN:
				break
			case .CONTACT_SYNCED:
				break
			case .CREATE_BOT:
				break
			case .CREATE_THREAD:
				break
			case .DEFINE_BOT_COMMAND:
				break
			case .DELETE_MESSAGE:
				break
			case .DELIVERY:
				break
			case .EDIT_MESSAGE:
				break
			case .ERROR:
				ErrorResponseHandler.handle(chat, chatMessage , asyncMessage)
				break
			case .FORWARD_MESSAGE:
				break
			case .GET_BLOCKED:
				break
			case .GET_CONTACTS:
				break
			case .GET_CURRENT_USER_ROLES:
				break
			case .GET_HISTORY:
				break
			case .GET_MESSAGE_DELEVERY_PARTICIPANTS:
				break
			case .GET_MESSAGE_SEEN_PARTICIPANTS:
				break
			case .GET_NOT_SEEN_DURATION:
				break
			case .GET_REPORT_REASONS:
				break
			case .GET_STATUS:
				break
			case .GET_THREADS:
				break
			case .IS_NAME_AVAILABLE:
				break
			case .JOIN_THREAD:
				break
			case .LAST_SEEN_UPDATED:
				break
			case .LEAVE_THREAD:
				break
			case .LOGOUT:
				break
			case .MESSAGE:
				break
			case .MUTE_THREAD:
				break
			case .PING:
				break
			case .PIN_MESSAGE:
				break
			case .PIN_THREAD:
				break
			case .RELATION_INFO:
				break
			case .REMOVED_FROM_THREAD:
				break
			case .REMOVE_PARTICIPANT:
				break
			case .REMOVE_ROLE_FROM_USER:
				break
			case .RENAME:
				break
			case .REPORT_MESSAGE:
				break
			case .REPORT_THREAD:
				break
			case .REPORT_USER:
				break
			case .SEEN:
				break
			case .SENT:
				break
			case .SET_PROFILE:
				break
			case .SET_RULE_TO_USER:
				break
			case .SPAM_PV_THREAD:
				break
			case .START_BOT:
				break
			case .STATUS_PING:
				break
			case .STOP_BOT:
				break
			case .SYSTEM_MESSAGE:
				break
			case .THREAD_INFO_UPDATED:
				break
			case .THREAD_PARTICIPANTS:
				break
			case .UNBLOCK:
				break
			case .UNMUTE_THREAD:
				break
			case .UNPIN_MESSAGE:
				break
			case .UNPIN_THREAD:
				break
			case .UPDATE_THREAD_INFO:
				break
			case .USER_INFO:
				break
			case .USER_STATUS:
				break
			@unknown default :
				print("a message recived with unknowned type value. investigate to fix or leave that.")
		}
		
	}
}

struct NewChatMessage : Decodable {
	
	var code           	: Int?
	let content        	: String?
	let contentCount   	: Int?
	var message        	: String?
	let messageType    	: Int
	let subjectId      	: Int?
	let time           	: Int
	let type           	: NewChatMessageVOTypes
	let uniqueId       	: String
	var messageId      	: Int? = nil
	var participantId  	: Int? = nil
	
	private enum CodingKeys:String , CodingKey{
		case code
		case content
		case contentCount
		case message
		case messageType
		case subjectId
		case time
		case type
		case uniqueId
		case messageId
		case participantId
	}
	
	init(from decoder: Decoder) throws {
		let container 	= try 	decoder.container(keyedBy: CodingKeys.self)
		code 			= try? 	container.decode(Int.self, forKey: .code)
		content 			= try? 	container.decode(String.self, forKey: .content)
		contentCount 		= try? 	container.decode(Int.self, forKey: .contentCount)
		message 			= try? 	container.decode(String.self, forKey: .message)
		messageType 		= try 	container.decode(Int.self, forKey: .messageType)
		subjectId 		= try? 	container.decode(Int.self, forKey: .subjectId)
		time 			= try 	container.decode(Int.self, forKey: .time)
		type 			= try 	container.decode(NewChatMessageVOTypes.self, forKey: .type)
		uniqueId 			= try 	container.decode(String.self, forKey: .uniqueId)
		messageId 		= try? 	container.decode(Int.self, forKey: .messageId)
		participantId 	= try? 	container.decode(Int.self, forKey: .participantId)
		if let content = content{
			let jsonContent = JSON(parseJSON: content)
			if(participantId == nil){
				participantId = jsonContent["participantId"].int
			}
			if(messageId == nil){
				participantId = jsonContent["messageId"].int
			}
		}
		
	}
}

enum NewChatMessageVOTypes :Int , Codable {
	case CREATE_THREAD                     = 1  // 1
	case MESSAGE        	                  =  2                  // 2
	case SENT                              = 3                  // 3
	case DELIVERY                          = 4                  // 4
	case SEEN                              = 5                   // 5
	case PING                              = 6                  // 6
	case BLOCK                             = 7                // 7
	case UNBLOCK                           = 8                   // 8
	case LEAVE_THREAD                      = 9                // 9
	case RENAME                            = 10                 // 10    // not implemented yet!
	case ADD_PARTICIPANT                   = 11              // 11
	case GET_STATUS                        = 12              // 12    // not implemented yet!
	case GET_CONTACTS                      = 13              // 13
	case GET_THREADS                       = 14              // 14
	case GET_HISTORY                       = 15            // 15
	case CHANGE_TYPE                       = 16            // 16    // not implemented yet!
	case REMOVED_FROM_THREAD               = 17           // 17
	case REMOVE_PARTICIPANT                = 18          // 18
	case MUTE_THREAD                       = 19            // 19
	case UNMUTE_THREAD                     = 20           // 20
	case UPDATE_THREAD_INFO                = 21        // 21
	case FORWARD_MESSAGE                   = 22        // 22
	case USER_INFO                         = 23         // 23
	case USER_STATUS                       = 24           // 24    // not implemented yet!
	case GET_BLOCKED                       = 25             // 25
	case RELATION_INFO                     = 26         // 26    // not implemented yet!
	case THREAD_PARTICIPANTS               = 27       // 27
	case EDIT_MESSAGE                      = 28       // 28
	case DELETE_MESSAGE                    = 29      // 29
	case THREAD_INFO_UPDATED               = 30    // 30
	case LAST_SEEN_UPDATED                 = 31  // 31
	case GET_MESSAGE_DELEVERY_PARTICIPANTS = 32 // 32
	case GET_MESSAGE_SEEN_PARTICIPANTS     = 33  // 33
	case IS_NAME_AVAILABLE                 = 34   // 34
	case JOIN_THREAD                       = 39   // 39
	case BOT_MESSAGE                       = 40  // 40    // not implemented yet!
	case SPAM_PV_THREAD                    = 41  // 41
	case SET_RULE_TO_USER                  = 42 // 42
	case REMOVE_ROLE_FROM_USER             = 43 // 43
	case CLEAR_HISTORY                     = 44  // 44
	case SYSTEM_MESSAGE                    = 46  // 46
	case GET_NOT_SEEN_DURATION             = 47 // 47
	case PIN_THREAD                        = 48   // 48
	case UNPIN_THREAD                      = 49   // 49
	case PIN_MESSAGE                       = 50  // 50
	case UNPIN_MESSAGE                     = 51  // 51
	case SET_PROFILE                       = 52   // 52
	case GET_CURRENT_USER_ROLES            = 54 // 54
	case GET_REPORT_REASONS                = 56 // 56
	case REPORT_THREAD                     = 57  // 57
	case REPORT_USER                       = 58   // 58
	case REPORT_MESSAGE                    = 59   // 59
	case CONTACTS_LAST_SEEN                = 60  // 60
	case ALL_UNREAD_MESSAGE_COUNT          = 61 // 61
	case CREATE_BOT                        = 62   // 62
	case DEFINE_BOT_COMMAND                = 63  // 63
	case START_BOT                         = 64  // 64
	case STOP_BOT                          = 65  // 65
	case CONTACT_SYNCED                    = 90  // 90
	case LOGOUT                            = 100   // 100
	case STATUS_PING                       = 101  // 101
	case CLOSE_THREAD                      = 102  // 102
	case ERROR                             = 999   // 999
}
