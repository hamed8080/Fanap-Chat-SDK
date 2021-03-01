import FanapPodAsyncSDK
import Sentry
import Foundation
import Alamofire
import SwiftyJSON


struct Notifyable{
	var onSent: ((Any)->())? = nil
	var onDelivered: ((Any)->())? = nil
	var onSeen: ((Any)->())? = nil
}

public struct ChatResponse{
	public var result:Any?
	public var cacheResponse:Any?
	public var error:ChatError?
}

//this extension merged after removed all deprecated method in Chat class
public extension Chat {
	
    
//    func getContacts(request: GetContactsRequest,uniqueId:String? = nil,fromCache:Bool? = nil,uniqeIdResult:((String)->())? = nil ,typeCode:String? = nil,completion:@escaping (ChatResponse)->()){
//        prepareToSendAsync(req:request,clientSpecificUniqueId:uniqueId,typeCode: typeCode, messageType: .GET_CONTACTS, completion: completion)
//    }
	
	//**************************** Intitializers ****************************
	func createChatObject(object:CreateChatModel){
		isCreateObjectFuncCalled = true
		createChatModel = object
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
	
	func dispose() {
		stopAllChatTimers()
		asyncClient?.disposeAsyncObject()
		asyncClient = nil
		Chat.instance = nil
		print("Disposed Singleton instance")
	}
	//**************************** Intitializers ****************************
	
    
	func request(_ builder :RequestBuilder ,
				 typeCode:String? = nil,
				 uniqueId:String? = nil,
				 getCacheResponse: Bool?   = false,
				 completion: @escaping (ChatResponse)->(),
				 onSent: ((Any)->())? = nil,
				 onDelivered: ((Any)->())? = nil,
				 onSeen: ((Any)->())? = nil,
				 uniqueIdResult:((String)->())? = nil){
		
		guard let createChatModel = createChatModel else{return}
		
		let tuple :(request:Encodable? ,messageType:NewChatMessageVOTypes)
		var subjectId:Int? = nil
		var plainText = false
		
		switch builder {
			case .GetContacts(req: let req ):
				tuple = (req , .GET_CONTACTS)
				break
			case .GetBlockedContacts(req: let req):
				tuple = (req , .GET_BLOCKED)
				break
			case .AddContact(req: let req):
				let url = "\(createChatModel.platformHost)\(SERVICES_PATH.ADD_CONTACTS.rawValue)"
				let headers: HTTPHeaders    = ["_token_": createChatModel.token, "_token_issuer_": "1"]
				restApiRequest(req, decodeType: ContactResponse.self,url: url , headers: headers , typeCode: typeCode, completion: completion)
				return
			case .AddContacts(req: let req):
				let url = "\(createChatModel.platformHost)\(SERVICES_PATH.ADD_CONTACTS.rawValue)"
				let headers: HTTPHeaders    = ["_token_": createChatModel.token, "_token_issuer_": "1"]
				restApiRequest(req, decodeType: ContactResponse.self,  url: url , method: .post, headers: headers , typeCode: typeCode, completion: completion)
				return
			case .ContactNotSeenDuration(req: let req):
				tuple = (req , .GET_NOT_SEEN_DURATION)
				break
			case .RemoveContact(req: let req):
				let url = "\(createChatModel.platformHost)\(SERVICES_PATH.REMOVE_CONTACTS.rawValue)"
				let headers: HTTPHeaders    = ["_token_": createChatModel.token, "_token_issuer_": "1"]
				restApiRequest(req, decodeType: RemoveContactResponse.self,  url: url , method: .post, headers: headers , typeCode: typeCode, completion: completion)
				return
			case .SearchContact(req: let req):
				tuple = (req , .GET_CONTACTS)
				break
			case .SyncContacts:
				SyncContactsRequestHandler.handle(self, completion: completion)
				return
			case .UpdateContact(req: let req):
				let url = "\(createChatModel.platformHost)\(SERVICES_PATH.UPDATE_CONTACTS.rawValue)"
				let headers: HTTPHeaders = ["_token_": createChatModel.token, "_token_issuer_": "1"]
				restApiRequest(req, decodeType: ContactResponse.self, url: url, method: .post ,headers: headers , typeCode: typeCode, completion: completion)
				return
			case .BlockContact(req: let req):
				tuple = (req , .BLOCK)
				break
			case .UnBlockContact(req: let req):
				tuple = (req , .UNBLOCK)
				break
			case .MapReverse(req: let req):
				guard let mapApiKey = createChatModel.mapApiKey else {return}
				let url = "\(createChatModel.mapServer)\(SERVICES_PATH.MAP_REVERSE.rawValue)"
				let headers:  HTTPHeaders = ["Api-Key":  mapApiKey]
				restApiRequest(req, decodeType: NewMapReverse.self, url: url ,headers: headers , typeCode: typeCode, completion: completion)
				return
			case .MapSearch(req: let req):
				guard let mapApiKey = createChatModel.mapApiKey else {return}
				let url = "\(createChatModel.mapServer)\(SERVICES_PATH.MAP_SEARCH.rawValue)"
				let headers:  HTTPHeaders = ["Api-Key":  mapApiKey]
				restApiRequest(req, decodeType: NewMapSearchResponse.self, url: url ,headers: headers , typeCode: typeCode, completion: completion)
				return
			case .MapRouting(req: let req):
				guard let mapApiKey = createChatModel.mapApiKey else {return}
				let url = "\(createChatModel.mapServer)\(SERVICES_PATH.MAP_ROUTING.rawValue)"
				let headers:  HTTPHeaders = ["Api-Key":  mapApiKey]
				restApiRequest(req, decodeType: NewMapRoutingResponse.self, url: url ,headers: headers , typeCode: typeCode, completion: completion)
				return
			case .MapStaticImage(req: let req):
				DownloadMapStaticImageRequestHandler.handle(req:req , createChatModel: createChatModel, completion: completion)
				return
			case .Threads(req: let req):
				tuple = (req , .GET_THREADS)
				break
			case .IsThreadNamePublic(req:let req):
				tuple = (req , .IS_NAME_AVAILABLE)
				break
			case .MuteThread(threadId:let threadId):
				tuple = (nil , .MUTE_THREAD)
				subjectId = threadId
				break
			case .UnMuteThread(threadId:let threadId):
				tuple = (nil , .UNMUTE_THREAD)
				subjectId = threadId
				break
			case .PinThread(threadId:let threadId):
				tuple = (nil , .PIN_THREAD)
				subjectId = threadId
				break
			case .UnPinThread(threadId:let threadId):
				tuple = (nil , .UNPIN_THREAD)
				subjectId = threadId
				break
			case .CreateThread(req: let req):
				tuple = (req , .CREATE_THREAD)
				break
			case .AddParticipant(threadId: let threadId , req: let req):
				tuple = ([req] , .ADD_PARTICIPANT)
				subjectId = threadId
				break
			case .AddParticipants(threadId:let threadId, req: let req):
				tuple = (req , .ADD_PARTICIPANT)
				subjectId = threadId
				break
			case .RemoveParticipant(threadId:let threadId, participantId: let participantId):
				tuple = ([participantId] , .REMOVE_PARTICIPANT)
				subjectId = threadId
				break
			case .RemoveParticipants(threadId:let threadId, participantIds: let participantIds):
				tuple = (participantIds , .REMOVE_PARTICIPANT)
				subjectId = threadId
				break
			case .JoinThread(uniqueName: let uniqueName):
				tuple = (uniqueName , .JOIN_THREAD)
				break
			case .CloseThread(threadId: let threadId):
				tuple = (nil , .CLOSE_THREAD)
				subjectId = threadId
				break
			case .UpdateThreadInfo(req: let req , uploadProgress: let uploadProgress):
				UpdateThreadInfoRequestHandler(self , req , uploadProgress , completion , uniqueId , uniqueIdResult , .UPDATE_THREAD_INFO , typeCode).handle()
				return
			case .CreateThreadWithMessage(req: let req):
				tuple = (req , .CREATE_THREAD)
				break
			case .LeaveThread(req: let req):
				tuple = (req , .LEAVE_THREAD)
				subjectId = req.threadId
				break
			case .CreateBot(botName: let botName):
				tuple = (botName , .CREATE_BOT)
				plainText = true
				break
			case .CreateBotCommand(req: let req):
				tuple = (req , .DEFINE_BOT_COMMAND)
				break
			case .StopBot(req: let req):
				tuple = (req , .STOP_BOT)
				subjectId = req.threadId
				break
			case .StartBot(req: let req):
				tuple = (req , .START_BOT)
				subjectId = req.threadId
				break
			case .UserInfo:
				tuple = (nil , .USER_INFO)
				break
			case .SetProfile(req: let req):
				tuple = (req , .SET_PROFILE)
				break
			case .SendStatusPing(req: let req):
				tuple = (req , .STATUS_PING)
				break
			case .ThreadParticipants(threadId: let threadId, _ : let req):
				tuple = (req , .THREAD_PARTICIPANTS)
				subjectId = threadId
				break
			case .PinMessage(_ : let req):
				tuple = (req ,  .PIN_MESSAGE)
				subjectId = req.messageId
				break
			case .UnPinMessage(_ : let req):
				tuple = (req , .UNPIN_MESSAGE)
				subjectId = req.messageId
				break
			case .ClearHistory(threadId:let threadId):
				tuple = (nil , .CLEAR_HISTORY)
				subjectId = threadId
				break
			case .DeleteMessage(req:let req):
				tuple = (req , .DELETE_MESSAGE)
				subjectId = req.messageId
				break
			case .BatchDeleteMessage(req:let req):
				tuple = (req , .DELETE_MESSAGE)
				req.uniqueIds.forEach { uniqueId in
					callbacksManager.addCallback(uniqueId: uniqueId, callback: completion)
				}
				break
			case .AllUnreadMessageCount(req:let req):
				tuple = (req , .ALL_UNREAD_MESSAGE_COUNT)
				break
			case .Mentions(req:let req):
				tuple = (req , .GET_HISTORY)
				subjectId = req.threadId
				break
			case .MessageDeliveredUsers(req:let req):
				tuple = (req , .GET_MESSAGE_DELEVERY_PARTICIPANTS)
				break
			case .MessageSeenByUsers(req:let req):
				tuple = (req , .GET_MESSAGE_SEEN_PARTICIPANTS)
				break
			case .NotifyDeliveredMessage(messageId:let messageId):
				tuple = ("\(messageId)" , .DELIVERY)
				plainText = true
				break
			case .NotifySeenMessage(messageId:let messageId):
				tuple = ("\(messageId)" , .SEEN)
				plainText = true
				break
            case .CurrentUserRoles(threadId:let threadId):
                tuple = (nil, .GET_CURRENT_USER_ROLES)
                subjectId = threadId
                break
		}
		prepareToSendAsync(req: tuple.request,
						   clientSpecificUniqueId: uniqueId,
						   typeCode: typeCode ,
						   subjectId: subjectId,
						   messageType: tuple.messageType,
						   uniqueIdResult: uniqueIdResult,
						   completion: completion,
						   onSent: onSent,
						   onDelivered: onDelivered,
						   onSeen: onSeen,
						   plainText: plainText
		)
		
	}
	
	// REST API Request
	private func restApiRequest<T:Decodable>(_ encodableRequest:Encodable? ,
											 decodeType:T.Type,
											 url:String,
											 method:HTTPMethod = .get,
											 headers:HTTPHeaders? = nil,
											 clientSpecificUniqueId:String? = nil ,
											 typeCode: String? ,
											 uniqueIdResult: ((String)->())? = nil,
											 completion:  @escaping ((ChatResponse)->())
	){
		Networking.request(decodeType,
						   from: url,
						   withMethod: method,
						   withHeaders: headers,
						   encodableRequest: encodableRequest,
						   completion: { [weak self] result in
							guard let weakSelf = self else{return}
							if let error = result.error {
								weakSelf.delegate?.chatError(errorCode: error.code ?? 0 ,
															 errorMessage: error.message ?? "",
															 errorResult: error.content)
							}
							completion(result)
						   })
	}
	
	// SOCKET Request
	private func prepareToSendAsync(req:Encodable? = nil ,
									clientSpecificUniqueId:String? = nil ,
									typeCode:String? = nil ,
									//this sometimes use to send threadId with subjectId Key must fix from server to get threadId
									subjectId:Int? = nil,
									messageType:NewChatMessageVOTypes ,
									uniqueIdResult:((String)->())? = nil,
									completion: @escaping ((ChatResponse)->()),
									onSent: ((Any)->())? = nil,
									onDelivered: ((Any)->())? = nil,
									onSeen: ((Any)->())? = nil,
									plainText:Bool = false){
		guard let createChatModel = createChatModel else {return}
		let uniqueId = clientSpecificUniqueId ?? UUID().uuidString
		uniqueIdResult?(uniqueId)
		let typeCode = typeCode ?? createChatModel.typeCode ?? "default"
		
		let chatMessage = NewSendChatMessageVO(chatMessageVOType:  messageType.rawValue,
											token:              createChatModel.token,
											content:            getContent(req , plainText),
											subjectId: subjectId,
											typeCode:           typeCode,
											uniqueId:           uniqueId,
											isCreateThreadAndSendMessage: true)
		
		guard let chatMessageContent = chatMessage.convertCodableToString() else{return}
		let asyncMessage = NewSendAsyncMessageVO(content:     chatMessageContent,
											  ttl: createChatModel.msgTTL,
											  peerName:     createChatModel.serverName,
											  priority:     createChatModel.msgPriority
		)
		
		
		callbacksManager.addCallback(uniqueId: uniqueId , callback: completion ,onSent: onSent , onDelivered: onDelivered , onSeen: onSeen)
		sendToAsync(asyncMessageVO: asyncMessage)
	}
	
	private func getContent(_ req:Encodable? , _ plainText:Bool)->String?{
		var content:String? = nil
		if !plainText && req != nil {
			content = req?.convertCodableToString()
		}else if plainText && req != nil , let stringValue = req as? String{
			content = stringValue
		}
		return content
	}
	
	internal func sendToAsync(asyncMessageVO:NewSendAsyncMessageVO){
		guard let content = asyncMessageVO.convertCodableToString() else { return }
		asyncClient?.pushSendData(type: asyncMessageVO.pushMsgType ?? 3, content: content)
		runSendMessageTimer()
	}
	
	internal func getDeviceIdAndCreateAsync(){
		guard let createChatModel = createChatModel else{return}
		let headers: HTTPHeaders = ["Authorization": "Bearer \(createChatModel.token)"]
		let url = createChatModel.ssoHost + SERVICES_PATH.SSO_DEVICES.rawValue
		Networking.request(ofType: DevicesResposne.self,
						   from: url,
						   withMethod: .get,
						   withHeaders: headers,
						   encodableRequest: nil
		) { [weak self] devicesResponse in
			if let device = devicesResponse?.devices?.first(where: {$0.current == true}){
				self?.createChatModel?.deviceId = device.uid
				self?.CreateAsync()
			}else{
				
			}
		}errorResult:{ responseModel in
			self.delegate?.chatError(errorCode: responseModel.errorCode, errorMessage: responseModel.errorMessage, errorResult: nil)
		}
	}
	
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

public enum NewChatMessageVOTypes :Int , Codable {
	case CREATE_THREAD                     = 1
	case MESSAGE                           = 2
	case SENT                              = 3
	case DELIVERY                          = 4//has request but no callback from server back
	case SEEN                              = 5
	case PING                              = 6
	case BLOCK                             = 7
	case UNBLOCK                           = 8
	case LEAVE_THREAD                      = 9
	case RENAME                            = 10// not implemented yet!
	case ADD_PARTICIPANT                   = 11
	case GET_STATUS                        = 12// not implemented yet!
	case GET_CONTACTS                      = 13
	case GET_THREADS                       = 14
	case GET_HISTORY                       = 15
	case CHANGE_TYPE                       = 16// not implemented yet!
	case REMOVED_FROM_THREAD               = 17
	case REMOVE_PARTICIPANT                = 18
	case MUTE_THREAD                       = 19
	case UNMUTE_THREAD                     = 20
	case UPDATE_THREAD_INFO                = 21
	case FORWARD_MESSAGE                   = 22
	case USER_INFO                         = 23
	case USER_STATUS                       = 24// not implemented yet!
	case GET_BLOCKED                       = 25
	case RELATION_INFO                     = 26// not implemented yet!
	case THREAD_PARTICIPANTS               = 27
	case EDIT_MESSAGE                      = 28
	case DELETE_MESSAGE                    = 29
	case THREAD_INFO_UPDATED               = 30
	case LAST_SEEN_UPDATED                 = 31
	case GET_MESSAGE_DELEVERY_PARTICIPANTS = 32
	case GET_MESSAGE_SEEN_PARTICIPANTS     = 33
	case IS_NAME_AVAILABLE                 = 34
	case JOIN_THREAD                       = 39
	case BOT_MESSAGE                       = 40// not implemented yet!
	case SPAM_PV_THREAD                    = 41
	case SET_RULE_TO_USER                  = 42
	case REMOVE_ROLE_FROM_USER             = 43
	case CLEAR_HISTORY                     = 44
	case SYSTEM_MESSAGE                    = 46
	case GET_NOT_SEEN_DURATION             = 47
	case PIN_THREAD                        = 48
	case UNPIN_THREAD                      = 49
	case PIN_MESSAGE                       = 50
	case UNPIN_MESSAGE                     = 51
	case SET_PROFILE                       = 52
	case GET_CURRENT_USER_ROLES            = 54
	case GET_REPORT_REASONS                = 56// not implemented yet!
	case REPORT_THREAD                     = 57
	case REPORT_USER                       = 58
	case REPORT_MESSAGE                    = 59
	case CONTACTS_LAST_SEEN                = 60
	case ALL_UNREAD_MESSAGE_COUNT          = 61
	case CREATE_BOT                        = 62
	case DEFINE_BOT_COMMAND                = 63
	case START_BOT                         = 64
	case STOP_BOT                          = 65
	case LOGOUT                            = 100
	case STATUS_PING                       = 101
	case CLOSE_THREAD                      = 102
	case ERROR                             = 999
}
