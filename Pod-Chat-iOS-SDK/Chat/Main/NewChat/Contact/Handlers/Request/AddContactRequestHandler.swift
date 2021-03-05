//
//  AddContactRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/2/21.
//

import Foundation
import Alamofire

class AddContactRequestHandler{
    
    class func handle( req:AddContactRequest , chat:Chat , typeCode:String? = nil , completion: @escaping CompletionType<[Contact]>){
        
        guard let createChatModel = chat.createChatModel else {return}
        let url = "\(createChatModel.platformHost)\(SERVICES_PATH.ADD_CONTACTS.rawValue)"
        let headers: HTTPHeaders    = ["_token_": createChatModel.token, "_token_issuer_": "1"]
        chat.restApiRequest(req, decodeType: ContactResponse.self,url: url , headers: headers , typeCode: typeCode) { response in
            let contactResponse = response.result as? ContactResponse
            addToCacheIfEnabled(chat: chat, contactsResponse: contactResponse)
            completion(contactResponse?.contacts , response.error)
        }
    }
    
    class func addToCacheIfEnabled(chat:Chat , contactsResponse:ContactResponse?){
        if chat.createChatModel?.enableCache  == true , let contacts = contactsResponse?.contacts{
            CMContact.insertOrUpdate(contacts: contacts)
        }
    }
}
