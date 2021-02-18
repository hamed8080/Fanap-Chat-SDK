//
//  CallbacksManager.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/17/21.
//

import Foundation

class CallbacksManager{
	
	private var callbacks:[String:(ChatResponse)->()] = [:]
	
	func addCallback(uniqueId:String , callback:@escaping (ChatResponse)->()) {
		callbacks[uniqueId] = callback
	}
	
	func removeError(uniqueId:String ){
		callbacks.removeValue(forKey: uniqueId)
	}
	
	func getCallBack(_ uniqueId:String)->((ChatResponse)->())?{
		return callbacks[uniqueId]
	}
}
