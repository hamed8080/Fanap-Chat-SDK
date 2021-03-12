import FanapPodAsyncSDK
import Sentry
import Foundation
import Alamofire
import SwiftyJSON


public struct ChatResponse{
	public var result:Any?
	public var cacheResponse:Any?
	public var error:ChatError?
}

public typealias CompletionType<T>     = ( T? , ChatError? )->()
public typealias CacheResponseType<T>  = ( T? , ChatError? )->()
public typealias UniqueIdResultType    = ( (String)->() )?
public typealias UniqueIdsResultType   = ( ([String])->() )?
public typealias UploadProgressType    = (Float) -> ()
public typealias OnSeenType            = ((SeenMessageResponse? , ChatError?) -> ())?
public typealias OnDeliveryType        = ((DeliverMessageResponse? , ChatError? ) -> ())?
public typealias OnSentType            = ((SentMessageResponse?, ChatError?) -> ())?

//this extension merged after removed all deprecated method in Chat class
public extension Chat {
	
	//**************************** Intitializers ****************************
	func createChatObject(object:CreateChatModel){
		isCreateObjectFuncCalled = true
		createChatModel = object
        initAllOldProperties()
		initialize()
	}
    
    private func initAllOldProperties(){
        if let model = createChatModel{
            self.debuggingLogLevel                    = model.showDebuggingLogLevel
            self.captureSentryLogs                    = model.captureLogsOnSentry
            if captureSentryLogs {
                startCrashAnalytics()
            }
            
            self.socketAddress                        = model.socketAddress
            self.ssoHost                              = model.ssoHost
            self.platformHost                         = model.platformHost
            self.fileServer                           = model.fileServer
            self.serverName                           = model.serverName
            self.token                                = model.token
            self.enableCache                          = model.enableCache
            self.mapServer                            = model.mapServer
            
            cacheTimeStamp                            =  model.cacheTimeStampInSec
            if let mapApiKey                          = model.mapApiKey{
                self.mapApiKey                        = mapApiKey
            }
            
            if let typeCode                           = model.typeCode{
                self.generalTypeCode                  = typeCode
            }
            self.msgPriority                          = model.msgPriority
            self.msgTTL                               = model.msgTTL
            self.httpRequestTimeout                   = model.httpRequestTimeout
            self.actualTimingLog                      = model.actualTimingLog
            self.deviecLimitationSpaceMB              = model.deviecLimitationSpaceMB
            self.wsConnectionWaitTime                 = model.wsConnectionWaitTime
            self.connectionRetryInterval              = model.connectionRetryInterval
            self.connectionCheckTimeout               = model.connectionCheckTimeout
            self.messageTtl                           = model.messageTtl
            self.reconnectOnClose                     = model.reconnectOnClose
            self.maxReconnectTimeInterval             = model.maxReconnectTimeInterval
            
            self.SERVICE_ADDRESSES.SSO_ADDRESS        = ssoHost
            self.SERVICE_ADDRESSES.PLATFORM_ADDRESS   = platformHost
            self.SERVICE_ADDRESSES.FILESERVER_ADDRESS = fileServer
            self.SERVICE_ADDRESSES.MAP_ADDRESS        = mapServer
            
            self.localImageCustomPath                 = model.localImageCustomPath
            self.localFileCustomPath                  = model.localFileCustomPath
        }
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
	
	func getContacts(_ request:ContactsRequest,completion:@escaping CompletionType<[Contact]>,cacheResponse:CacheResponseType<[Contact]>? = nil,uniqueIdResult: UniqueIdResultType = nil){
		GetContactsRequestHandler.handle(request,self, completion , cacheResponse , uniqueIdResult)
	}
	
	func getBlockedContacts(_ request:BlockedListRequest , completion:@escaping CompletionType<[BlockedUser]>,uniqueIdResult: UniqueIdResultType = nil){
		GetBlockedContactsRequestHandler.handle(request,self,completion , uniqueIdResult)
	}
	
	func addContact(_ request:NewAddContactRequest,completion:@escaping CompletionType<[Contact]>, uniqueIdResult: UniqueIdResultType? = nil){
        AddContactRequestHandler.handle(req: request, chat: self, completion: completion)
	}
	
	func addContacts(_ request:[NewAddContactRequest],completion:@escaping CompletionType<[Contact]>,uniqueIdResult: UniqueIdResultType? = nil){
		AddContactsRequestHandler.handle(req: request, chat: self, completion: completion)
	}
	
	func contactNotSeen(_ request:NotSeenDurationRequest,completion:@escaping CompletionType<[UserLastSeenDuration]>,uniqueIdResult: UniqueIdResultType = nil){
		NotSeenContactRequestHandler.handle(request, self, completion)
	}
	
	func removeContact(_ request:NewRemoveContactsRequest,completion:@escaping CompletionType<Bool>,uniqueIdResult: UniqueIdResultType = nil){
		RemoveContactRequestHandler.handle(req: request, chat: self, typeCode: request.typeCode, completion: completion)
	}
	
	func searchContacts(_ request:ContactsRequest, completion:@escaping CompletionType<[Contact]>, cacheResponse: CacheResponseType<[Contact]>? = nil, uniqueIdResult: UniqueIdResultType = nil){
        getContacts(request, completion: completion, cacheResponse:cacheResponse, uniqueIdResult: uniqueIdResult)
	}
	
	func syncContacts(completion:@escaping CompletionType<[Contact]>, uniqueIdsResult: UniqueIdsResultType = nil){
		SyncContactsRequestHandler.handle(self, completion: completion,uniqueIdsResult: uniqueIdsResult)
	}
	
    func updateContact(_ req: UpdateContactRequest, completion: @escaping CompletionType<[Contact]>, uniqueIdsResult:UniqueIdResultType = nil ){
		UpdateContactRequestHandler.handle(req: req, chat: self, completion: completion)
	}
	
	func blockContact(_ request:NewBlockRequest,completion:@escaping CompletionType<BlockedUser>,uniqueIdResult: UniqueIdResultType = nil){
		BlockContactRequestHandler.handle(request,self,completion , uniqueIdResult)
	}
	
	func unBlockContact(_ request:NewUnBlockRequest,completion:@escaping CompletionType<BlockedUser>,uniqueIdResult:UniqueIdResultType = nil){
		UnBlockContactRequestHandler.handle(request,self,completion , uniqueIdResult)
	}
	
    func mapReverse(_ request:NewMapReverseRequest,completion:@escaping CompletionType<NewMapReverse>,uniqueIdResult: UniqueIdResultType = nil){
		MapReverseRequestHandler.handle(req: request, chat: self, uniqueIdResult:uniqueIdResult, completion: completion)
	}
	
	func mapSearch(_ request:NewMapSearchRequest,completion:@escaping CompletionType<[NewMapItem]>,uniqueIdResult: UniqueIdResultType = nil){
		MapSearchRequestHandler.handle(req: request, chat: self, completion: completion)
	}
	
	func mapRouting(_ request:NewMapRoutingRequest,completion:@escaping CompletionType<[Route]>,uniqueIdResult: UniqueIdResultType = nil){
		MapRoutingRequestHandler.handle(req: request, chat: self, completion: completion)
	}
	
	func mapStaticImage(_ request:NewMapStaticImageRequest,completion:@escaping CompletionType<Data>,uniqueIdResult: UniqueIdResultType = nil){
		MapStaticImageRequestHandler.handle(req: request, chat: self, completion: completion)
	}
	
	func getThreads(_ request:ThreadsRequest,completion:@escaping CompletionType<[Conversation]>, cacheResponse: CacheResponseType<[Conversation]>? = nil ,  uniqueIdResult: UniqueIdResultType = nil){
		GetThreadsRequestHandler.handle(request, self , completion , cacheResponse , uniqueIdResult)
	}
	
	func isThreadNamePublic(_ request:IsThreadNamePublicRequest,completion:@escaping CompletionType<String>,uniqueIdResult: UniqueIdResultType = nil){
		IsThreadNamePublicRequestHandler.handle(request, self , completion , uniqueIdResult)
	}
	
	func muteThread(_ request:NewMuteUnmuteThreadRequest,completion:@escaping CompletionType<Int>,uniqueIdResult: UniqueIdResultType = nil){
		MuteThreadRequestHandler.handle(request, self , completion , uniqueIdResult)
	}
	
	func unmuteThread(_ request:NewMuteUnmuteThreadRequest,completion:@escaping CompletionType<Int>,uniqueIdResult: UniqueIdResultType = nil){
		UnMuteThreadRequestHandler.handle(request, self , completion , uniqueIdResult)
	}
	
	func pinThread(_ request:NewPinUnpinThreadRequest,completion:@escaping CompletionType<Int>,uniqueIdResult: UniqueIdResultType = nil){
		PinThreadRequestHandler.handle(request, self , completion , uniqueIdResult)
	}
	
	func unpinThread(_ request:NewPinUnpinThreadRequest,completion:@escaping CompletionType<Int>,uniqueIdResult: UniqueIdResultType = nil){
		UnPinThreadRequestHandler.handle(request, self , completion , uniqueIdResult)
	}
	
	func createThread(_ request:NewCreateThreadRequest, completion:@escaping CompletionType<Conversation> ,uniqueIdResult: UniqueIdResultType = nil){
		CreateThreadRequestHandler.handle(request, self , completion , uniqueIdResult)
	}
	
	func addParticipant(_ request:AddParticipantRequest, completion:@escaping CompletionType<Conversation> , uniqueIdResult: UniqueIdResultType = nil){
		AddParticipantsRequestHandler.handle([request], self , completion , uniqueIdResult)
	}
	
	func addParticipants(_ request:[AddParticipantRequest],completion:@escaping CompletionType<Conversation>, uniqueIdResult: UniqueIdResultType = nil){
		AddParticipantsRequestHandler.handle(request, self , completion , uniqueIdResult)
	}
	
	func removeParticipants(_ request: NewRemoveParticipantsRequest,completion:@escaping CompletionType<[Participant]>, uniqueIdResult: UniqueIdResultType = nil){
		RemoveParticipantsRequestHandler.handle(request, self , completion , uniqueIdResult)
	}
	
	func joinThread(_ request:NewJoinPublicThreadRequest ,completion:@escaping CompletionType<Conversation>,uniqueIdResult: UniqueIdResultType = nil){
		JoinPublicThreadRequestHandler.handle(request, self , completion , uniqueIdResult)
	}
	
	func closeThread(_ request:NewCloseThreadRequest ,completion:@escaping CompletionType<Int>,uniqueIdResult: UniqueIdResultType = nil){
		CloseThreadRequestHandler.handle(request, self , completion , uniqueIdResult)
	}
	
	func updateThreadInfo(_ request:NewUpdateThreadInfoRequest , uniqueIdResult: UniqueIdResultType = nil, uploadProgress:@escaping UploadProgressType,completion:@escaping CompletionType<Conversation>){
		UpdateThreadInfoRequestHandler(self , request ,uploadProgress ,completion , uniqueIdResult ,.UPDATE_THREAD_INFO).handle()
	}
	
	func createThreadWithMessage(_ request:CreateThreadWithMessage ,
					uniqueIdResult: UniqueIdResultType = nil,
					onSent:OnSentType = nil,
					onDelivery:OnDeliveryType = nil,
					onSeen: OnSentType = nil,
					completion:@escaping CompletionType<Conversation>){
		CreateThreadWithMessageRequestHandler.handle(request, self , completion , uniqueIdResult)
	}
	
	func leaveThread(_ request:NewLeaveThreadRequest ,completion:@escaping CompletionType<Conversation>,uniqueIdResult: UniqueIdResultType = nil){
		LeaveThreadRequestHandler.handle(request, self , completion , uniqueIdResult)
	}
	
	func createBot(_ request:NewCreateBotRequest ,completion:@escaping CompletionType<Bot>,uniqueIdResult: UniqueIdResultType = nil){
		CreateBotRequestHandler.handle(request, self , completion , uniqueIdResult)
	}
	
	func createBotCommand(_ request:NewAddBotCommandRequest ,completion:@escaping CompletionType<BotInfo>,uniqueIdResult: UniqueIdResultType = nil){
		AddBotCommandRequestHandler.handle(request, self , completion , uniqueIdResult)
	}
	
	func startBot(_ request:NewStartStopBotRequest ,completion:@escaping CompletionType<String> ,uniqueIdResult: UniqueIdResultType = nil){
		StartBotRequestHandler.handle(request, self , completion , uniqueIdResult)
	}
	
	func stopBot(_ request:NewStartStopBotRequest , completion:@escaping CompletionType<String> , uniqueIdResult: UniqueIdResultType = nil){
		StopBotRequestHandler.handle(request, self , completion , uniqueIdResult)
	}
	
	func getUserInfo(_ request:UserInfoRequest ,completion:@escaping CompletionType<User> ,cacheResponse: CacheResponseType<User>? = nil,uniqueIdResult: UniqueIdResultType = nil){
		UserInfoRequestHandler.handle(request, self , completion , cacheResponse , uniqueIdResult)
	}
	
	func setProfile(_ request:NewUpdateChatProfile ,completion:@escaping CompletionType<Profile>,uniqueIdResult: UniqueIdResultType = nil){
		UpdateChatProfileRequestHandler.handle(request, self , completion , uniqueIdResult)
	}
	
	func sendStatusPing(_ request:SendStatusPingRequest){
		SendStatusPingRequestHandler.handle(request, self)
	}
	
	func getThreadParticipants(_ request:ThreadParticipantsRequest ,completion:@escaping CompletionType<[Participant]>, cacheResponse: CacheResponseType<[Participant]>? = nil,uniqueIdResult: UniqueIdResultType = nil){
		ThreadParticipantsRequestHandler.handle(request, self , completion , cacheResponse , uniqueIdResult)
	}
    
    func sendTextMessage(_ request:NewSendTextMessageRequest ,uniqueIdresult:UniqueIdResultType = nil, onSent:OnSentType = nil , onSeen:OnSeenType = nil, onDeliver:OnDeliveryType = nil){
        SendTextMessageRequestHandler.handle(request, self, onSent, onSeen, onDeliver)
    }
    
    func editMessage(_ request:NewEditMessageRequest , completion:@escaping CompletionType<Message> ,uniqueIdresult:UniqueIdResultType = nil){
        EditMessageRequestHandler.handle(request, self, completion )
    }
    
    func forwardMessages(_ request:NewForwardMessageRequest ,  onSent:OnSentType = nil , onSeen:OnSeenType = nil, onDeliver:OnDeliveryType = nil ,uniqueIdsrResult:UniqueIdsResultType = nil){
        ForwardMessagesRequestHandler.handle(request, self, onSent, onSeen, onDeliver, uniqueIdsrResult)
    }
    
    func getHistory(_ request:NewGetHistoryRequest ,
                    completion:@escaping CompletionType<[Message]> ,
                    cacheResponse: CacheResponseType<[Message]>? = nil,
                    textMessageNotSentRequests: CompletionType<[NewSendTextMessageRequest]>? = nil,
                    editMessageNotSentRequests: CompletionType<[NewEditMessageRequest]>? = nil,
                    forwardMessageNotSentRequests: CompletionType<[NewForwardMessageRequest]>? = nil,
                    uniqueIdResult: UniqueIdResultType = nil){
        GetHistoryRequestHandler.handle(request,
                                        self ,
                                        completion,
                                        cacheResponse ,
                                        textMessageNotSentRequests ,
                                        editMessageNotSentRequests ,
                                        forwardMessageNotSentRequests,
                                        uniqueIdResult)
    }
	
	func pinMessage(_ request:NewPinUnpinMessageRequest ,completion:@escaping CompletionType<PinUnpinMessageResponse> , uniqueIdResult: UniqueIdResultType = nil){
		PinMessageRequestHandler.handle(request, self , completion , uniqueIdResult)
	}
	
    func unpinMessage(_ request:NewPinUnpinMessageRequest ,completion:@escaping CompletionType<PinUnpinMessageResponse> ,uniqueIdResult: UniqueIdResultType = nil){
		UnPinMessageRequestHandler.handle(request, self , completion , uniqueIdResult)
	}
	
	func clearHistory(_ request:NewClearHistoryRequest ,completion:@escaping CompletionType<Int>,uniqueIdResult: UniqueIdResultType = nil){
		ClearHistoryRequestHandler.handle(request, self , completion , uniqueIdResult)
	}
	
	func deleteMessage(_ request:NewDeleteMessageRequest ,completion:@escaping CompletionType<DeleteMessage>,uniqueIdResult: UniqueIdResultType = nil){
		DeleteMessageRequestHandler.handle(request, self , completion , uniqueIdResult)
	}
	
	func batchDeleteMessage(_ request:BatchDeleteMessageRequest ,completion:@escaping CompletionType<DeleteMessage>,uniqueIdResult: UniqueIdResultType = nil){
		BatchDeleteMessageRequestHandler.handle(request, self , completion , uniqueIdResult)
	}
	
    func allUnreadMessageCount(_ request:UnreadMessageCountRequest ,completion:@escaping CompletionType<Int>, cacheResponse: CacheResponseType<Int>? = nil ,uniqueIdResult: UniqueIdResultType = nil){
		AllUnreadMessageCountRequestHandler.handle(request, self , completion , cacheResponse , uniqueIdResult)
	}
	
	func getMentions(_ request:MentionRequest ,completion:@escaping CompletionType<[Message]> ,cacheResponse: CacheResponseType<[Message]>? = nil, uniqueIdResult: UniqueIdResultType = nil){
		MentionsRequestHandler.handle(request, self , completion, cacheResponse, uniqueIdResult)
	}
	
	func messageDeliveryParticipants(_ request:MessageDeliveredUsersRequest ,completion:@escaping CompletionType<[Participant]> ,uniqueIdResult: UniqueIdResultType = nil){
		MessageDeliveryParticipantsRequestHandler.handle(request, self , completion , uniqueIdResult)
	}
	
	func messageSeenByUsers(_ request:MessageSeenByUsersRequest , completion:@escaping CompletionType<[Participant]> , uniqueIdResult: UniqueIdResultType = nil){
		MessagSeenByUsersRequestHandler.handle(request, self , completion , uniqueIdResult)
	}
	
	func deliver(_ request:MessageDeliverRequest ,uniqueIdResult: UniqueIdResultType = nil){
		DeliverRequestHandler.handle(request, self)
	}
	
	func seen(_ request:MessageSeenRequest , uniqueIdResult: UniqueIdResultType = nil){
		SeenRequestHandler.handle(request, self)
	}
	
    func getCurrentUserRoles(_ request:CurrentUserRolesRequest ,completion:@escaping CompletionType<[Roles]> , cacheResponse: CacheResponseType<[Roles]>? = nil, uniqueIdResult: UniqueIdResultType = nil){
		CurrentUserRolesRequestHandler.handle(request, self , completion , cacheResponse , uniqueIdResult)
	}
	
	// REST API Request
    func restApiRequest<T:Decodable>(_ encodableRequest:Encodable? ,
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
	func prepareToSendAsync(req:Encodable? = nil ,
									clientSpecificUniqueId:String? = nil ,
									typeCode:String? = nil ,
									//this sometimes use to send threadId with subjectId Key must fix from server to get threadId
									subjectId:Int? = nil,
									messageType:NewChatMessageVOTypes ,
									uniqueIdResult:((String)->())? = nil,
									completion: ((ChatResponse)->())? = nil,
									onSent: OnSentType? = nil,
									onDelivered: OnDeliveryType? = nil,
									onSeen: OnSeenType? = nil,
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
        if let data = try? JSONEncoder().encode(asyncMessage){
            print("json sent is:\(String(describing: String(data: data , encoding: .utf8)))")
        }
		sendToAsync(asyncMessageVO: asyncMessage)
	}
    
    func prepareToSendAsync(_ chatMessage:NewSendChatMessageVO,
                            uniqueId:String,
                            completion: ((ChatResponse)->())? = nil,
                            onSent: OnSentType? = nil,
                            onDelivered: OnDeliveryType? = nil,
                            onSeen: OnSeenType? = nil){
        guard let chatMessageContent = chatMessage.convertCodableToString() , let createChatModel = createChatModel  else{return}
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
