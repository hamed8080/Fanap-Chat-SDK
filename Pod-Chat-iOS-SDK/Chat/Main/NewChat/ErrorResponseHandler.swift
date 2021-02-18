//
//  ErrorResponseHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/15/21.
//

import Foundation
import Sentry

class ErrorResponseHandler  : ResponseHandler{
	
	private init(){}
	
	static func handle(_ chat: Chat , _ chatMessage:NewChatMessage , _ asyncMessage:AsyncMessage) {
		guard let createChatModel = chat.createChatModel else {return}
		print("Message of type 'ERROR' recieved")
		
		// send log to Sentry 4.3.1
		if createChatModel.captureLogsOnSentry {
			let event = Event(level: SentrySeverity.error)
			event.message = "Message of type 'ERROR' recieved: \n \(asyncMessage.convertCodableToString() ?? "")"
			Client.shared?.send(event: event, completion: { _ in })
		}
		
		
		if let callback = chat.callbacksManager.getCallBack(chatMessage.uniqueId){
			let code:Int
			let message:String
			let content:String
			
			if let data = chatMessage.content?.data(using: .utf8) , let chatError = try? JSONDecoder().decode(ChatError.self, from: data) {
				code = chatError.code ?? 0
				message = chatError.message ?? ""
				content = chatError.content ?? ""
			}else{
				code = chatMessage.code ?? 0
				content = asyncMessage.convertCodableToString() ?? ""
				message = chatMessage.message ??  ""
			}
            
            callback(.init(error: .init(code: code, message: message, content: content)))
			chat.delegate?.chatError(errorCode:   code,
									 errorMessage: message ,
									 errorResult:    content)
			chat.callbacksManager.removeError(uniqueId: chatMessage.uniqueId)
		}
	}
}
