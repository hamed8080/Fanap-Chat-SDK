//
//  GetContactsCallback.swift
//  FanapPodChatSDK
//
//  Created by Mahyar Zhiani on 3/18/1398 AP.
//  Copyright © 1398 Mahyar Zhiani. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftyBeaver
import FanapPodAsyncSDK

extension Chat {
    
    /// GetContact Response comes from server
    ///
    /// - Outputs:
    ///    - it doesn't have direct output,
    ///    - but on the situation where the response is valid,
    ///    - it will call the "onResultCallback" callback to getContacts function (by using "getContactsCallbackToUser")
    func responseOfGetContacts(withMessage message: ChatMessage) {
        log.verbose("Message of type 'GET_CONTACTS' recieved", context: "Chat")
        
        let returnData = CreateReturnData(hasError:         false,
                                          errorMessage:     "",
                                          errorCode:        0,
                                          result:           nil,
                                          resultAsArray:    message.content?.convertToJSON().array,
                                          resultAsString:   nil,
                                          contentCount:     message.contentCount,
                                          subjectId:        message.subjectId)
        
		guard let callback = Chat.map[message.uniqueId] as? GetContactsCallback  else {return}
		callback.onResultCallback(uID: message.uniqueId,
								  response: returnData,
								  success:  { (successJSON) in
									self.getContactsCallbackToUser?(successJSON)
								  }) { _ in }
		Chat.map.removeValue(forKey: message.uniqueId)
    }
    
    public class GetContactsCallback: CallbackProtocol {
        var sendParams: SendChatMessageVO
        init(parameters: SendChatMessageVO) {
            self.sendParams = parameters
        }
        
        func onResultCallback(uID:      String,
                              response: CreateReturnData,
                              success:  @escaping callbackTypeAlias,
                              failure:  @escaping callbackTypeAlias) {
            log.verbose("GetContactsCallback", context: "Chat")
            
            if let arrayContent = response.resultAsArray as? [JSON] {
                let content = sendParams.content?.convertToJSON()
                
                if Chat.sharedInstance.createChatModel?.enableCache == true {
                    var contacts = [Contact]()
                    for item in (response.resultAsArray as? [JSON]) ?? [] {
                        let myContact = Contact(messageContent: item)
                        contacts.append(myContact)
                    }
                    
//                    handleServerAndCacheDifferential(sendParams: sendParams, serverResponse: contacts)
                    let contactEventModel = ContactEventModel(type: ContactEventTypes.CONTACTS_LIST_CHANGE, contacts: contacts, contactsLastSeenDuration: nil)
                    Chat.sharedInstance.delegate?.contactEvents(model: contactEventModel)
                    Chat.cacheDB.saveContact(withContactObjects: contacts)
                }
                
                let getContactsModel = GetContactsResponse(messageContent:  arrayContent,
                                                           contentCount:    response.contentCount,
                                                           count:           content?["size"].intValue ?? 0,
                                                           offset:          content?["offset"].intValue ?? 0,
                                                           hasError:        response.hasError,
                                                           errorMessage:    response.errorMessage,
                                                           errorCode:       response.errorCode)
                success(getContactsModel)
            }
        }
        
    }
    
}
