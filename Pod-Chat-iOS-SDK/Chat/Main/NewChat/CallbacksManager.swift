//
//  CallbacksManager.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/17/21.
//

import Foundation

class CallbacksManager{
	
    private var callbacks            : [String : (ChatResponse)->()]        = [:]
    private var sentCallbacks        : [String : OnSentType]                = [:]
    private var deliveredCallbacks   : [String : OnDeliveryType]            = [:]
    private var seenCallbacks        : [String : OnSeenType]                = [:]
	
    func addCallback(uniqueId    : String ,
                     callback    : ((ChatResponse)->())? = nil,
                     onSent      : OnSentType? = nil ,
                     onDelivered : OnDeliveryType? = nil ,
                     onSeen      : OnSeenType? = nil
    ) {
        if let callback = callback {
            callbacks[uniqueId] = callback
        }
        if let onSent = onSent{
            sentCallbacks[uniqueId] = onSent
        }
        if let onDelivered = onDelivered{
            deliveredCallbacks[uniqueId] = onDelivered
        }
        if let onSeen = onSeen{
            seenCallbacks[uniqueId] = onSeen
        }
    }
    
	func removeCallback(uniqueId:String){
		callbacks.removeValue(forKey: uniqueId)
	}
    
    func removeSentCallback(uniqueId:String){
        sentCallbacks.removeValue(forKey: uniqueId)
    }
    
    func removeDeliverCallback(uniqueId:String){
        deliveredCallbacks.removeValue(forKey: uniqueId)
    }
    
    func removeSeenCallback(uniqueId:String){
        seenCallbacks.removeValue(forKey: uniqueId)
    }
	
	func getCallBack(_ uniqueId:String)->((ChatResponse)->())?{
		return callbacks[uniqueId]
	}
    
    func getSentCallBack(_ uniqueId:String)->OnSentType?{
        return sentCallbacks[uniqueId]
    }
    
    func getDeliverBack(_ uniqueId:String)->OnDeliveryType?{
        return deliveredCallbacks[uniqueId]
    }
    
    func getSeenBack(_ uniqueId:String)->OnSeenType?{
        return seenCallbacks[uniqueId]
    }
    
}
