//
//  UpdateContactRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/17/21.
//

import Foundation
import Contacts
import Alamofire

class UpdateContactRequestHandler {
	
	class func handle( req:UpdateContactRequest , chat:Chat,typeCode:String? = nil , completion: @escaping (ChatResponse)->()){
		
		guard let createChatModel = chat.createChatModel else {return}
		let url = "\(createChatModel.platformHost)\(SERVICES_PATH.UPDATE_CONTACTS.rawValue)"
		let headers: HTTPHeaders = ["_token_": createChatModel.token, "_token_issuer_": "1"]
		chat.restApiRequest(req, decodeType: ContactResponse.self, url: url, method: .post ,headers: headers , typeCode: typeCode){ response in
			updateContacts(chat: chat, contactsResponse:response.result as? ContactResponse)
			completion(response)
		}
	}
	
	private class func updateContacts(chat:Chat , contactsResponse:ContactResponse?){
		if let contacts = contactsResponse?.contacts {
			CMContact.insertOrUpdate(contacts: contacts)
		}
		PSM.shared.save()
	}
	
}
