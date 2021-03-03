//
//  CasheFactory.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/2/21.
//

import Foundation
class CacheFactory {
    
    enum CacheType {
        case GET_CASHED_CONTACTS
    }
    
    class func get(chat:Chat ,useCache: Bool = false , completion: ((ChatResponse)->())? = nil , cacheType: CacheType){
        if chat.createChatModel?.enableCache == true && useCache == true{
            switch cacheType {
            case .GET_CASHED_CONTACTS:
                completion?(.init(result: nil, cacheResponse: CMContact.crud.getAll().map{$0.convertCMObjectToObject()}, error: nil))
                break
            }
        }
    }
    
    class func write(chat:Chat , data:Any , cacheType: CacheType){
        if chat.createChatModel?.enableCache == true{
            switch cacheType {
            case .GET_CASHED_CONTACTS:
                CMContact.insertOrUpdate(contacts: data as! [Contact])
                break
            }
        }
    }
}
