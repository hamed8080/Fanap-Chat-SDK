//
//  RequestBuilder.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/17/21.
//

import Foundation

public enum RequestBuilder {
	case GetContacts(req:ContactsRequest)
	case GetBlockedContacts(req:BlockedListRequest)
	case AddContact(req:AddContactRequest)
	case AddContacts(req:[AddContactRequest])
	case ContactNotSeenDuration(req:NotSeenDurationRequest)
	case RemoveContact(req:RemoveContactsRequest)
	case SearchContact(req:ContactsRequest)
	case SyncContacts
	case UpdateContact(req:UpdateContactRequest)
	case BlockContact(req:NewBlockRequest)
	case UnBlockContact(req:UnblockRequest)
	case MapReverse(req:MapReverseRequest)
	case MapSearch(req:MapSearchRequest)
	case MapRouting(req:NewMapRoutingRequest)
	case MapStaticImage(req:NewMapStaticImageRequest)
	case Threads(req:ThreadsRequest)
	case IsThreadNamePublic(req:IsThreadNamePublicRequest)
	case MuteThread(threadId:Int)
	case UnMuteThread(threadId:Int)
	case PinThread(threadId:Int)
	case UnPinThread(threadId:Int)
	case CreateThread(req:CreateThreadRequest)
	case AddParticipant(threadId:Int, req: AddParticipantRequest)
	case AddParticipants(threadId:Int , req: [AddParticipantRequest])
	case RemoveParticipant(threadId:Int, participantId: Int)
	case RemoveParticipants(threadId:Int , participantIds: [Int])
	case JoinThread(uniqueName:String)
	case CloseThread(threadId:Int)
    case UpdateThreadInfo(req:UpdateThreadInfoRequest , uploadProgress: (Float)->())
    case CreateThreadWithMessage(req:CreateThreadWithMessage)
    case LeaveThread(req:LeaveThreadRequest)
	case CreateBot(botName:String)
	case CreateBotCommand(req:AddBotCommandRequest)
	case StartBot(req:StartStopBotRequest)
	case StopBot(req:StartStopBotRequest)
	case UserInfo
	case SetProfile(req:UpdateChatProfileRequest)
	case SendStatusPing(req:StatusPing)
	case ThreadParticipants(threadId:Int, _ req:ThreadParticipantsRequest)
    case PinMessage(_ req:PinUnpinMessageRequest)
    case UnPinMessage(_ req:PinUnpinMessageRequest)
    case ClearHistory(threadId:Int)
    case DeleteMessage(req:DeleteMessageRequest)
	case BatchDeleteMessage(req:BatchDeleteMessageRequest)
	case AllUnreadMessageCount(req:UnreadMessageCountRequest)
	case Mentions(req:MentionRequest)
	case MessageDeliveredUsers(req:MessageDeliveredUsersRequest)
	case MessageSeenByUsers(req:MessageSeenByUsersRequest)
	case NotifyDeliveredMessage(messageId:Int)
	case NotifySeenMessage(messageId:Int)
    case CurrentUserRoles(threadId:Int)
}
