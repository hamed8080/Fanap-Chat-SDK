//
//  AsyncDelegateImplementaion.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/17/21.
//

import Foundation
import FanapPodAsyncSDK
import SwiftyJSON

class AsyncDelegateImplementaion : AsyncDelegates{
	
	let chat:Chat
	
	init(_ chat:Chat) {
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
			ReceiveMessageFactory.invokeCallback(data: data , chat: chat)
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
