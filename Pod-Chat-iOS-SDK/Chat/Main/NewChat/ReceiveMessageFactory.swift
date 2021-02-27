//
//  ReceiveMessageFactory.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/17/21.
//

import Foundation

class ReceiveMessageFactory{
	
	class func invokeCallback(data:Data , chat:Chat) {
		guard let asyncMessage = try? JSONDecoder().decode(AsyncMessage.self, from: data) else {return}
		guard let chatMessageData  = asyncMessage.content.data(using: .utf8) else{return}
		guard let chatMessage =  try? JSONDecoder().decode(NewChatMessage.self, from: chatMessageData) else{return}
		print("asyncMessage decoded: \(chatMessage)")
		
		switch chatMessage.type {
			
			case .ADD_PARTICIPANT:
				AddParticipantResponseHandler.handle(chat , chatMessage , asyncMessage)
				break
			case .ALL_UNREAD_MESSAGE_COUNT:
				AllUnreadMessageCountResponseHandler.handle(chat , chatMessage , asyncMessage)
				break
			case .BLOCK:
				BlockedResponseHandler.handle(chat , chatMessage , asyncMessage)
				break
			case .BOT_MESSAGE://TODO: not implemented yet!
				break
			case .CHANGE_TYPE://TODO: not implemented yet!
				break
			case .CLEAR_HISTORY:
                ClearHistoryResponseHandler.handle(chat , chatMessage , asyncMessage)
				break
			case .CLOSE_THREAD:
				CloseThreadResponseHandler.handle(chat , chatMessage , asyncMessage)
				break
			case .CONTACTS_LAST_SEEN:
				break
			case .CREATE_BOT:
				CreateBotResponseHandler.handle(chat , chatMessage , asyncMessage)
				break
			case .CREATE_THREAD:
				CreateThreadResponseHandler.handle(chat , chatMessage , asyncMessage)
				break
			case .DEFINE_BOT_COMMAND:
				CreateBotCommandResposneHandler.handle(chat , chatMessage , asyncMessage)
				break
			case .DELETE_MESSAGE:
                DeleteMessageResposneHandler.handle(chat , chatMessage , asyncMessage)
				break
			case .DELIVERY://only use in request but no callback from server back
				break
			case .EDIT_MESSAGE:
				break
			case .ERROR:
				ErrorResponseHandler.handle(chat, chatMessage , asyncMessage)
				break
			case .FORWARD_MESSAGE:
				break
			case .GET_BLOCKED:
				BlockedContactsResponseHandler.handle(chat , chatMessage , asyncMessage)
				break
			case .GET_CONTACTS:
				ContactsResponseHandler.handle(chat , chatMessage , asyncMessage)
				break
			case .GET_CURRENT_USER_ROLES:
				break
			case .GET_HISTORY:
				HistoryResponseHandler.handle(chat , chatMessage , asyncMessage)
				break
			case .GET_MESSAGE_DELEVERY_PARTICIPANTS:
				MessageDeliveredUsersResponseHandler.handle(chat , chatMessage , asyncMessage)
				break
			case .GET_MESSAGE_SEEN_PARTICIPANTS:
				MessageSeenByUsersResponseHandler.handle(chat , chatMessage , asyncMessage)
				break
			case .GET_NOT_SEEN_DURATION:
				ContactNotSeenDurationHandler.handle(chat , chatMessage , asyncMessage)
				break
			case .GET_REPORT_REASONS:
				break
			case .GET_STATUS://TODO: not implemented yet!
				break
			case .GET_THREADS:
				ThreadsResponseHandler.handle(chat ,chatMessage , asyncMessage)
				break
			case .IS_NAME_AVAILABLE:
				IsPublicThreadNameAvailableResponseHandler.handle(chat ,chatMessage , asyncMessage)
				break
			case .JOIN_THREAD:
				JoinThreadResponseHandler.handle(chat ,chatMessage , asyncMessage)
				break
			case .LAST_SEEN_UPDATED:
				break
			case .LEAVE_THREAD:
                LeaveThreadResponseHandler.handle(chat ,chatMessage , asyncMessage)
				break
			case .LOGOUT:
				break
			case .MESSAGE:
				break
			case .MUTE_THREAD:
				MuteThreadResponseHandler.handle(chat, chatMessage, asyncMessage)
				break
			case .PING:
				break
			case .PIN_MESSAGE:
                PinUnPinMessageResponseHandler.handle(chat, chatMessage, asyncMessage)
				break
			case .PIN_THREAD:
				PinThreadResponseHandler.handle(chat, chatMessage, asyncMessage)
				break
			case .RELATION_INFO://TODO: not implemented yet!
				break
			case .REMOVED_FROM_THREAD:
				break
			case .REMOVE_PARTICIPANT:
				RemoveParticipantResponseHandler.handle(chat, chatMessage, asyncMessage)
				break
			case .REMOVE_ROLE_FROM_USER:
				break
			case .RENAME://TODO: not implemented yet!
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
				SetProfileResponseHandler.handle(chat , chatMessage , asyncMessage)
				break
			case .SET_RULE_TO_USER:
				break
			case .SPAM_PV_THREAD:
				break
			case .START_BOT:
				StartBotResponseHandler.handle(chat , chatMessage , asyncMessage)
				break
			case .STATUS_PING:
				//never triggered because no reponse back from server
				StatusPingResponseHandler.handle(chat , chatMessage , asyncMessage)
				break
			case .STOP_BOT:
				StopBotResponseHandler.handle(chat , chatMessage , asyncMessage)
				break
			case .SYSTEM_MESSAGE:
				break
			case .THREAD_INFO_UPDATED:
				break
			case .THREAD_PARTICIPANTS:
				ThreadParticipantsResponseHandler.handle(chat , chatMessage , asyncMessage)
				break
			case .UNBLOCK:
				UnBlockResponseHandler.handle(chat , chatMessage , asyncMessage)
				break
			case .UNMUTE_THREAD:
				//same as Mute response no neeed new class to handle it
				MuteThreadResponseHandler.handle(chat, chatMessage, asyncMessage)
				break
			case .UNPIN_MESSAGE:
                PinUnPinMessageResponseHandler.handle(chat, chatMessage, asyncMessage)
				break
			case .UNPIN_THREAD:
				//same as Pin response no neeed new class to handle it
				PinThreadResponseHandler.handle(chat, chatMessage, asyncMessage)
				break
			case .UPDATE_THREAD_INFO:
				break
			case .USER_INFO:
				UserInfoResponseHandler.handle(chat, chatMessage, asyncMessage)
				break
			case .USER_STATUS: //TODO: not implemented yet!
				break
			@unknown default :
				print("a message recived with unknowned type value. investigate to fix or leave that.")
		}
		
	}
}
