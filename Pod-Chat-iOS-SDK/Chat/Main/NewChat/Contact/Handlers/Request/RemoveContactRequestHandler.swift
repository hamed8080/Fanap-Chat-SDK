//
//  RemoveContactRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/2/21.
//

import Foundation
import Alamofire

class RemoveContactRequestHandler{
    
    class func handle( req:NewRemoveContactsRequest , chat:Chat,typeCode:String? = nil , completion: @escaping CompletionType<Bool>){
        
        guard let createChatModel = chat.createChatModel else {return}
        let url = "\(createChatModel.platformHost)\(SERVICES_PATH.REMOVE_CONTACTS.rawValue)"
        let headers: HTTPHeaders    = ["_token_": createChatModel.token, "_token_issuer_": "1"]
        chat.restApiRequest(req, decodeType: NewRemoveContactResponse.self,  url: url , method: .post, headers: headers , typeCode: typeCode){ response in
            let removeResponse = response.result as? NewRemoveContactResponse
            removeFromCacheIfExist(chat: chat, removeContactResponse: removeResponse, contactId: req.contactId)
            completion(removeResponse?.deteled ?? false , response.error)
        }
    }
    
    private class func removeFromCacheIfExist(chat:Chat , removeContactResponse:NewRemoveContactResponse? , contactId:Int){
        if removeContactResponse?.deteled == true{
            CMContact.crud.deleteWith(predicate: NSPredicate(format: "id == %i", contactId))
			PSM.shared.save()
        }
    }
}
