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
	case MuteThread(req:MuteThreadRequest ,  messageType:NewChatMessageVOTypes = .MUTE_THREAD)
}
