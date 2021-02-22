//
//  RequestBuilder.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/17/21.
//

import Foundation

public enum RequestBuilder {
	case GetContacts(req:GetContactsRequest , messageType:NewChatMessageVOTypes = .GET_CONTACTS)
	case GetBlockedContacts(req:BlockedListRequest , messageType:NewChatMessageVOTypes = .GET_BLOCKED)
	case AddContact(req:AddContactRequest)
	case AddContacts(req:[AddContactRequest])
	case ContactNotSeenDuration(req:GetNotSeenDurationRequest , messageType:NewChatMessageVOTypes = .GET_NOT_SEEN_DURATION)
	case RemoveContact(req:RemoveContactsRequest)
	case SearchContact(req:GetContactsRequest, messageType:NewChatMessageVOTypes = .GET_CONTACTS)
	case SyncContacts
	case UpdateContact(req:UpdateContactRequest)
	case BlockContact(req:BlockRequest , messageType:NewChatMessageVOTypes = .BLOCK)
	case UnBlockContact(req:UnblockRequest , messageType:NewChatMessageVOTypes = .UNBLOCK)
	case MapReverse(req:MapReverseRequest)
	case MapSearch(req:MapSearchRequest)
	case MapRouting(req:MapRoutingRequest)
	case MapStaticImage(req:MapStaticImageRequest)
	case Threads(req:ThreadsRequest ,  messageType:NewChatMessageVOTypes = .GET_THREADS)
	case IsThreadNamePublic(req:IsThreadNamePublicRequest ,  messageType:NewChatMessageVOTypes = .IS_NAME_AVAILABLE)
	case MuteThread(threadId:Int, messageType:NewChatMessageVOTypes = .MUTE_THREAD)
	case UnMuteThread(threadId:Int , messageType:NewChatMessageVOTypes = .UNMUTE_THREAD)
	case PinThread(threadId:Int ,  messageType:NewChatMessageVOTypes = .PIN_THREAD)
	case UnPinThread(threadId:Int,  messageType:NewChatMessageVOTypes = .UNPIN_THREAD)
	case CreateThread(req:CreateThreadRequest ,  messageType:NewChatMessageVOTypes = .CREATE_THREAD)
	case AddParticipant(threadId:Int, req: AddParticipantRequest ,  messageType:NewChatMessageVOTypes = .ADD_PARTICIPANT)
	case AddParticipants(threadId:Int , req: [AddParticipantRequest] ,  messageType:NewChatMessageVOTypes = .ADD_PARTICIPANT)
	case RemoveParticipant(threadId:Int, participantId: Int ,  messageType:NewChatMessageVOTypes = .REMOVE_PARTICIPANT)
	case RemoveParticipants(threadId:Int , participantIds: [Int] ,  messageType:NewChatMessageVOTypes = .REMOVE_PARTICIPANT)
	case JoinThread(uniqueName:String ,  messageType:NewChatMessageVOTypes = .JOIN_THREAD)
	case CloseThread(threadId:Int ,  messageType:NewChatMessageVOTypes = .CLOSE_THREAD)
	case UpdateThreadInfo(req:UpdateThreadInfoRequest ,  messageType:NewChatMessageVOTypes = .UPDATE_THREAD_INFO)
	
}
