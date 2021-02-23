//
//  CallbacksManager.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/17/21.
//

import Foundation

class CallbacksManager{
	
    private var callbacks            : [String : (ChatResponse)->()] = [:]
    private var onSentCallbacks      : [String : (Any)->()]          = [:]
    private var onDeliveredCallbacks : [String : (Any)->()]          = [:]
    private var onSeenCallbacks      : [String : (Any)->()]          = [:]
	
    func addCallback(uniqueId    : String ,
                     callback    : @escaping (ChatResponse)->(),
                     onSent      : ( (Any)->() )? = nil ,
                     onDelivered : ( (Any)->() )? = nil ,
                     onSeen      : ( (Any)->() )? = nil
    ) {
        callbacks[uniqueId] = callback
        if let onSent = onSent{
            onSentCallbacks[uniqueId] = onSent
        }
        if let onDelivered = onDelivered{
            onDeliveredCallbacks[uniqueId] = onDelivered
        }
        if let onSeen = onSeen{
            onSeenCallbacks[uniqueId] = onSeen
        }
    }
    
	func removeError(uniqueId:String ){
		callbacks.removeValue(forKey: uniqueId)
	}
	
	func getCallBack(_ uniqueId:String)->((ChatResponse)->())?{
		return callbacks[uniqueId]
	}
}
