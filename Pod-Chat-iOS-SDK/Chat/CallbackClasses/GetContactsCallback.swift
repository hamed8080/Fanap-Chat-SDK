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
    
    /*
     * GetContact Response comes from server
     *
     *  save data comes from server to the Cache if needed
     *  send Event to client if needed!
     *  call the "onResultCallback"
     *
     *  + Access:   - private
     *  + Inputs:
     *      - message:      ChatMessage
     *  + Outputs:
     *      - it doesn't have direct output,
     *          but on the situation where the response is valid,
     *          it will call the "onResultCallback" callback to getContacts function (by using "getContactsCallbackToUser")
     *
     */
    func responseOfGetContacts(withMessage message: ChatMessage) {
        /*
         *  -> check if we have saves the message uniqueId on the "map" property
         *      -> if yes: (means we send this request and waiting for the response of it)
         *          -> create the "CreateReturnData" variable
         *          -> check if Cache is enabled by the user
         *              -> if yes, save the income Data to the Cache
         *          -> call the "onResultCallback" which will send callback to getContacts function (by using "getContactsCallbackToUser")
         *
         */
        log.verbose("Message of type 'GET_CONTACTS' recieved", context: "Chat")
        if Chat.map[message.uniqueId] != nil {
            let returnData: JSON = CreateReturnData(hasError:       false,
                                                    errorMessage:   "",
                                                    errorCode:      0,
                                                    result:         message.content?.convertToJSON() ?? [:],
                                                    resultAsString: nil,
                                                    contentCount:   message.contentCount,
                                                    subjectId:      message.subjectId)
                .returnJSON()
            
            if enableCache {
                var contacts = [Contact]()
                for item in message.content?.convertToJSON() ?? [:] {
                    let myContact = Contact(messageContent: item.1)
                    contacts.append(myContact)
                }
                Chat.cacheDB.saveContact(withContactObjects: contacts)
            }
            
            let callback: CallbackProtocol = Chat.map[message.uniqueId]!
            callback.onResultCallback(uID:      message.uniqueId,
                                      response: returnData,
                                      success:  { (successJSON) in
                self.getContactsCallbackToUser?(successJSON)
            }) { _ in }
            Chat.map.removeValue(forKey: message.uniqueId)
        }
        
    }
    
    
    public class GetContactsCallback: CallbackProtocol {
        
        var sendParams: SendChatMessageVO
        init(parameters: SendChatMessageVO) {
            self.sendParams = parameters
        }
        
        func onResultCallback(uID:      String,
                              response: JSON,
                              success:  @escaping callbackTypeAlias,
                              failure:  @escaping callbackTypeAlias) {
            /*
             *  -> check if response hasError or not
             *      -> if yes, create the "GetContactsModel"
             *      -> send the "GetContactsModel" as a callback
             *
             */
            log.verbose("GetContactsCallback", context: "Chat")
            if (!response["hasError"].boolValue) {
                let content = sendParams.content.convertToJSON()
                let getContactsModel = GetContactsModel(messageContent: response["result"].arrayValue,
                                                        contentCount:   response["contentCount"].intValue,
                                                        count:          content["count"].intValue,
                                                        offset:         content["offset"].intValue,
                                                        hasError:       response["hasError"].boolValue,
                                                        errorMessage:   response["errorMessage"].stringValue,
                                                        errorCode:      response["errorCode"].intValue)
                success(getContactsModel)
            }
        }
        
    }
    
}
