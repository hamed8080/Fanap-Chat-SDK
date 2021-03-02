//
//  AddContactsRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/2/21.
//

import Foundation
import Alamofire

class AddContactsRequestHandler{
    
    class func handle( req:[AddContactRequest] , chat:Chat , useCache :Bool , typeCode:String? = nil , completion: @escaping (ChatResponse)->()){
        
        guard let createChatModel = chat.createChatModel else {return}
        let url = "\(createChatModel.platformHost)\(SERVICES_PATH.ADD_CONTACTS.rawValue)"
        let headers: HTTPHeaders    = ["_token_": createChatModel.token, "_token_issuer_": "1"]
        chat.restApiRequest(req, decodeType: ContactResponse.self,url: url , headers: headers , typeCode: typeCode) { response in
            addToCacheIfEnabled(chat: chat, useCache: useCache , contactsResponse:response.result as? ContactResponse)
            completion(response)
        }
    }
    
    class func addToCacheIfEnabled(chat:Chat , useCache:Bool , contactsResponse:ContactResponse?){
        if chat.createChatModel?.enableCache == true && useCache , let contacts = contactsResponse?.contacts{
            CMContact.insertOrUpdate(contacts: contacts)
        }
    }
}
