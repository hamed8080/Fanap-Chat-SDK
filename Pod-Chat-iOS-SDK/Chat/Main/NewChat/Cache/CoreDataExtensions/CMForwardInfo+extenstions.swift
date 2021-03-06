//
//  CMForwardInfo+extenstions.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/2/21.
//

import Foundation

extension CMForwardInfo{
    
    public static let crud = CoreDataCrud<CMForwardInfo>(entityName: "CMForwardInfo")
    
    public func getCodable() -> ForwardInfo{
		return ForwardInfo(conversation: conversation?.getCodable(),
						   participant: participant?.getCodable())
    }
    
    public class func convertForwardInfoToCM(forwardInfo:ForwardInfo  ,entity:CMForwardInfo? = nil) -> CMForwardInfo{
        
        let model        = entity ?? CMForwardInfo()
//		model.conversation = forwardInfo.conversation
//		model.participant = forwardInfo.participant
        return model
    }
    
	public class func insertOrUpdate(forwardInfo:ForwardInfo , messageId:Int? , resultEntity:((CMForwardInfo)->())? = nil){
        
		if let messageId = messageId, let findedEntity = CMForwardInfo.crud.find(keyWithFromat: "coreUserId == %i", value: messageId){
            let cmForwardInfo = convertForwardInfoToCM(forwardInfo: forwardInfo, entity: findedEntity)
            resultEntity?(cmForwardInfo)
        }else{
			CMForwardInfo.crud.insert { cmForwardInfoEntity in
               let cmForwardInfo = convertForwardInfoToCM(forwardInfo: forwardInfo, entity: cmForwardInfoEntity)
                resultEntity?(cmForwardInfo)
            }
        }
        
    }
}
