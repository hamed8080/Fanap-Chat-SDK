//
//  ContactManagementMethods.swift
//  FanapPodChatSDK
//
//  Created by Mahyar Zhiani on 3/21/1398 AP.
//  Copyright © 1398 Mahyar Zhiani. All rights reserved.
//

import Foundation
import FanapPodAsyncSDK
import SwiftyJSON
import Alamofire
import Contacts

// MARK: - Public Methods -
// MARK: - Contact Management

extension Chat {
    
	@available(*,deprecated , message: "this method removed in future release use another addContact method")
    public func addContact(inputModel addContactsInput:    AddContactRequest,
                           uniqueId:            @escaping (String) -> (),
                           completion:          @escaping callbackTypeAlias) {
		addContact(addContactsInput,
				   completion: completion,
				   uniqueIdResult: uniqueId)
    }
    
    // MARK: - Add Contact
    /// AddContact:
    /// it will add a contact
    ///
    /// By calling this function, HTTP request of type (ADD_CONTACTS) will send throut Chat-SDK,
    /// then the response will come back as callbacks to client whose calls this function.
    ///
    /// Inputs:
    /// - you have to send your parameters as "AddContactRequestModel" to this function
    ///
    /// Outputs:
    /// - It has 3 callbacks as responses.
    /// - parameter addContactRequest: (input) you have to send your parameters insid this model. (AddContactRequest)
    /// - parameter uniqueIdResult:   (response) it will returns the request 'UniqueId' that will send to server. (String)
    /// - parameter completion: (response) it will returns the response that comes from server to this request. (Any as! ContactModel)
	/// - warning: if user finded with matched details the user updated and not added.
    public func addContact(_ addContactRequest:    AddContactRequest,
                           completion:                   @escaping callbackTypeAlias,
                           uniqueIdResult:               ((String) -> ())? = nil) {
        
        log.verbose("Try to request to add contact with this parameters: \n \(addContactRequest)", context: "Chat")
        uniqueIdResult?(addContactRequest.uniqueId)
        guard let createChatModel = createChatModel else {return}
        let url = "\(createChatModel.platformHost)\(SERVICES_PATH.ADD_CONTACTS.rawValue)"
        let headers: HTTPHeaders    = ["_token_": createChatModel.token, "_token_issuer_": "1"]
        Networking.request(ofType: ContactResponse.self,
                           from: url,
                           withMethod: .post,
                           withHeaders: headers,
                           encodableRequest: addContactRequest,
                           completion: { addContactModel in
                            if let addContactModel = addContactModel {
                                self.addContactOnCache(addContactModel.contacts)
                                completion(addContactModel)
                            }
                           })
    }
    
	@available(*,deprecated ,message: "remove from future release use another addContacts")
    public func addContacts(inputModel addContactsInput:    AddContactsRequest,
                            uniqueIds:           @escaping ([String]) -> (),
                            completion:          @escaping callbackTypeAlias) {
        log.verbose("Try to request to add contact with this parameters: \n \(addContactsInput)", context: "Chat")
        uniqueIds(addContactsInput.uniqueIds)
        
        sendAddContactsRequest(withInputModel: addContactsInput)
        { (addContactModel) in
			self.addContactOnCache((addContactModel as! ContactResponse).contacts)
            completion(addContactModel)
        }
    }
    
	@available(*,deprecated , message: "this method removed from release when deleted deprecated addContacts method")
    private func sendAddContactsRequest(withInputModel addContactsInput:    AddContactsRequest,
                                        completion:          @escaping callbackTypeAlias) {
        guard let createChatModel = createChatModel else {return}
        var url = "\(createChatModel.platformHost)\(SERVICES_PATH.ADD_CONTACTS.rawValue)"
        let method: HTTPMethod      = HTTPMethod.post
        let headers: HTTPHeaders    = ["_token_": createChatModel.token, "_token_issuer_": "1"]

        url += "?"
        let contactCount = addContactsInput.cellphoneNumbers.count
        for (index, _) in addContactsInput.cellphoneNumbers.enumerated() {
            url += "firstName=\(addContactsInput.firstNames[index])"
            url += "&lastName=\(addContactsInput.lastNames[index])"
            url += "&email=\(addContactsInput.emails[index])"
            url += "&uniqueId=\(addContactsInput.uniqueIds[index])"

            if (addContactsInput.cellphoneNumbers.count > 0) {
                url += "&cellphoneNumber=\(addContactsInput.cellphoneNumbers[index])"
            } else if (addContactsInput.usernames.count > 0) {
                url += "&username=\(addContactsInput.usernames[index])"
            }
            if (index != contactCount - 1) {
                url += "&"
            }
        }
        url += "&typeCode=\(addContactsInput.typeCode ?? createChatModel.typeCode ?? "defualt")"
        let textAppend = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? url
        Networking.sharedInstance.requesttWithJSONresponse(from:            textAppend,
                                                           withMethod:      method,
                                                           withHeaders:     headers,
                                                           withParameters:  nil)
        { (jsonResponse) in
            if let json = jsonResponse as? JSON ,let contactModel  = try? JSONDecoder().decode(ContactResponse.self, from: json.rawData()){
                completion(contactModel)
            }
        }
    }
    
	/// AddContacts:
	/// it will add an array of contacts in one request
	///
	/// By calling this function, HTTP request of type (ADD_CONTACTS) will send throut Chat-SDK,
	/// then the response will come back as callbacks to client whose calls this function.
	///
	/// Inputs:
	/// - you have to send your parameters as "AddContactsRequest" to this function
	///
	/// Outputs:
	/// - It has 3 callbacks as responses.
	///
	/// - parameter inputModel: (input) you have to send your parameters insid this model. (AddContactsRequest)
	/// - parameter completion: (response) it will returns the response that comes from server to this request. (Any as! ContactModel)
	public func addContacts(_ contacts:[AddContactRequest] , completion: @escaping callbackTypeAlias){
		guard let createChatModel = createChatModel else {return}
		var url = "\(createChatModel.platformHost)\(SERVICES_PATH.ADD_CONTACTS.rawValue)"
		url += "?"
		for (index , contact) in contacts.enumerated(){
			url += "firstName=\(contact.firstName ?? "")"
			url += "&lastName=\(contact.lastName ?? "")"
			url += "&email=\(contact.email ?? "")"
			url += "&uniqueId=\(contact.uniqueId)"
			if let cellPhoneNumber = contact.cellphoneNumber {
				url += "&cellphoneNumber=\(cellPhoneNumber)"
			}
			if let userName = contact.username{
				url += "&username=\(userName)"
			}
			if (index != contacts.count - 1) {
				url += "&"
			}
		}
		url += "&typeCode=\(contacts.first?.typeCode ?? "default")"
		url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? url
		let headers: HTTPHeaders    = ["_token_": createChatModel.token, "_token_issuer_": "1"]
		Networking.request(ofType: ContactResponse.self,
						   from: url,
						   withMethod: .post,
						   withHeaders: headers,
						   encodableRequest: nil,
						   completion: { result in
							if let result = result {
								completion(result)
							}
						   })
	}
    
	private func addContactOnCache(_ contacts:[Contact]) {
		if createChatModel?.enableCache == true {
            Chat.cacheDB.saveContact(withContactObjects: contacts)
        }
    }
    
	@available(*,deprecated , message: "removed in future release use another getContacts method")
    public func getContacts(inputModel getContactsInput:    GetContactsRequest,
                            getCacheResponse:               Bool? = false,
                            uniqueId:           @escaping ((String) -> ()),
                            completion:         @escaping callbackTypeAlias,
                            cacheResponse:      @escaping (GetContactsModel) -> () ) {
		getContacts(getContactsInput,
					getCacheResponse: getCacheResponse,
					uniqueId: getContactsInput.uniqueId,
					completion: completion,
					uniqueIdResult: uniqueId,
					cacheResponse: cacheResponse)

    }
	
	// MARK: - Get Contacts
	// ToDo: filtering by "name" works well on the Cache but not by the Server!!!
	/// GetContacts:
	/// it returns list of contacts
	///
	/// By calling this function, a request of type 13 (GET_CONTACTS) will send throut Chat-SDK,
	/// then the response will come back as callbacks to client whose calls this function.
	///
	/// Inputs:
	/// - you have to send your parameters as "GetContactsRequest" to this function
	///
	/// Outputs:
	/// - It has 3 callbacks as responses.
	///
	/// - parameter inputModel:         (input) you have to send your parameters insid this model. (GetContactsRequest)
	/// - parameter getCacheResponse:   (input) specify if you want to get cache response for this request (Bool?)
	/// - parameter uniqueIdResult:     (response) it will returns the request 'UniqueId' that will send to server. (String)
	/// - parameter completion:         (response) it will returns the response that comes from server to this request. (Any as! GetContactsModel)
	/// - parameter cacheResponse:      (response) there is another response that comes from CacheDB to the user, if user has set 'enableCache' vaiable to be true. (GetContactsModel)
	public func getContacts(_ contactsRequest: GetContactsRequest,
							getCacheResponse:           Bool?   = false,
							uniqueId:					String? = nil,
							completion:         		@escaping callbackTypeAlias,
							uniqueIdResult:           	((String) -> ())? = nil,
							cacheResponse:      		((GetContactsModel) -> ())? = nil ){
		guard let createChatModel = createChatModel , let content = contactsRequest.convertCodableToString()  else {return}
		log.verbose("Try to request to get Contacts with this parameters: \n \(contactsRequest)", context: "Chat")
		let unqId = uniqueId ?? UUID().uuidString
		uniqueIdResult?(unqId)
		
		getContactsCallbackToUser = completion
		let chatMessage = SendChatMessageVO(chatMessageVOType:  ChatMessageVOTypes.GET_CONTACTS.intValue(),
											token:              createChatModel.token,
											content:            "\(content)",
											typeCode:           contactsRequest.typeCode ?? createChatModel.typeCode,
											uniqueId:           unqId,
											isCreateThreadAndSendMessage: true)
		
		let asyncMessage = SendAsyncMessageVO(content:      chatMessage.convertModelToString(),
											  msgTTL:       createChatModel.msgTTL,
											  peerName:     createChatModel.serverName,
											  priority:     createChatModel.msgPriority)
		
		sendMessageWithCallback(asyncMessageVO:     asyncMessage,
								callbacks:          [(GetContactsCallback(parameters: chatMessage), unqId)],
								sentCallback:       nil,
								deliverCallback:    nil,
								seenCallback:       nil)
		
		// if cache is enabled by user, it will return cache result to the user
		if (getCacheResponse ?? createChatModel.enableCache) {
			var isAscending = true
			if let ord = contactsRequest.order, (ord == Ordering.descending.rawValue) {
				isAscending = false
			}
            if let cacheContacts = CMContact.retrieveContacts(ascending: isAscending,
                                                              contactsRequest: contactsRequest,
                                                              timeStamp: createChatModel.cacheTimeStampInSec) {
				cacheResponse?(cacheContacts)
			}
		}
		
		
	}
    
    // MARK: - Get Contact Not Seen Duration
    /// GetContactNotSeenDuration:
    /// contact not seen duration time
    ///
    /// By calling this function, a request of type 47 (GET_NOT_SEEN_DURATION) will send throut Chat-SDK,
    /// then the response will come back as callbacks to client whose calls this function.
    ///
    /// Inputs:
    /// - you have to send your parameters as "GetNotSeenDurationRequest" to this function
    ///
    /// Outputs:
    /// - It has 2 callbacks as responses.
    ///
    /// - parameter inputModel: (input) you have to send your parameters insid this model. (GetNotSeenDurationRequest)
    /// - parameter uniqueId:   (response) it will returns the request 'UniqueId' that will send to server. (String)
    /// - parameter completion: (response) it will returns the response that comes from server to this request. (Any as! ContactNotSeenDurationRespoonse)
	
	@available(*,deprecated , message: "use another contactNotSeenDuration method with uniqueId and uniqueIdResult In Parameter")
	public func contactNotSeenDuration(inputModel notSeenDurationInput: GetNotSeenDurationRequest,
									   uniqueId:        @escaping (String) -> (),
									   completion:      @escaping callbackTypeAlias) {
		contactNotSeenDuration(notSeenDurationInput,
							   uniqueId: notSeenDurationInput.uniqueId,
							   uniqueIdResult: uniqueId,
							   completion: completion)
	}
	
	
	public func contactNotSeenDuration(_ notSeenRequest: GetNotSeenDurationRequest,
									   uniqueId:					String? = nil,
									   typeCode:String? = nil,
                                       uniqueIdResult:               ((String) -> ())? = nil,
									   completion:      @escaping callbackTypeAlias){
		guard let createChatModel = createChatModel , let content = notSeenRequest.convertCodableToString() else {return}
		log.verbose("Try to request to get  user notSeenDuration with this parameters: \n \(notSeenRequest)", context: "Chat")
		let unqId = uniqueId ?? UUID().uuidString
		uniqueIdResult?(unqId)
		getContactNotSeenDurationCallbackToUser = completion
		
		let chatMessage = SendChatMessageVO(chatMessageVOType:  ChatMessageVOTypes.GET_NOT_SEEN_DURATION.intValue(),
											token:              createChatModel.token,
											content:            "\(content)",
											typeCode:           typeCode ?? "default",
											uniqueId:           unqId,
											isCreateThreadAndSendMessage: true)
		
		let asyncMessage = SendAsyncMessageVO(content:      chatMessage.convertModelToString(),
											  msgTTL:       createChatModel.msgTTL,
											  peerName:     createChatModel.serverName,
											  priority:     createChatModel.msgPriority)
		
		sendMessageWithCallback(asyncMessageVO:     asyncMessage,
								callbacks:          [(GetContactNotSeenDurationCallback(), unqId)],
								sentCallback:       nil,
								deliverCallback:    nil,
								seenCallback:       nil)
	}
    
    
    
    @available(*,deprecated , message: "use another removeContact method with uniqueId and uniqueIdResult In Parameter")
    public func removeContact(inputModel removeContactsInput:  RemoveContactsRequest,
                              uniqueId:             @escaping (String) -> (),
                              completion:           @escaping callbackTypeAlias) {
        removeContact(removeContactsInput,
                      uniqueId: removeContactsInput.uniqueId,
                      completion: completion,
                      uniqueIdResult: uniqueId)
    }
    
    // MARK: - Remove Contact
    /// RemoveContact:
    /// it will remove a contact
    ///
    /// By calling this function, HTTP request of type (REMOVE_CONTACTS) will send throut Chat-SDK,
    /// then the response will come back as callbacks to client whose calls this function.
    ///
    /// Inputs:
    /// - you have to send your parameters as "RemoveContactsRequest" to this function
    ///
    /// Outputs:
    /// - It has 3 callbacks as responses.
    ///
    /// - parameter inputModel: (input) you have to send your parameters insid this model. (RemoveContactsRequest)
    /// - parameter uniqueId:   (response) it will returns the request 'UniqueId' that will send to server. (String)
    /// - parameter completion: (response) it will returns the response that comes from server to this request. (Any as! RemoveContactModel)
    public func removeContact(_ removeContactRequest:  RemoveContactsRequest,
                              uniqueId:String? = nil,
                              completion:           @escaping callbackTypeAlias,
                              uniqueIdResult:       ((String) -> ())? = nil) {
        
        log.verbose("Try to request to remove contact with this parameters: \n \(removeContactRequest)", context: "Chat")
        let unqId = uniqueId ?? UUID().uuidString
        uniqueIdResult?(unqId)
        
        guard let createChatModel = createChatModel else {return}
        let url = "\(createChatModel.platformHost)\(SERVICES_PATH.REMOVE_CONTACTS.rawValue)"
        let headers: HTTPHeaders = ["_token_": createChatModel.token, "_token_issuer_": "1"]
        Networking.request(ofType: RemoveContactResponse.self,
                           from: url,
                           withMethod: .post,
                           withHeaders: headers,
                           encodableRequest: removeContactRequest) { (removeContactResponse) in
            if let removeContactResponse = removeContactResponse{
                self.removeContactFromCache(contactId:  removeContactRequest.contactId)
                completion(removeContactResponse)
            }
        }
    }
    
    private func removeContactFromCache(contactId: Int) {
        guard let createChatModel = createChatModel else {return}
        if createChatModel.enableCache{
            CMContact.crud.deleteWith(predicate: NSPredicate(format: "id = %i", contactId))
        }
    }
    
    
    // MARK: - Search Contacts
    /// SearchContact:
    /// search contact and returns a list of contact.
    ///
    /// By calling this function, HTTP request of type (SEARCH_CONTACTS) will send throut Chat-SDK,
    /// then the response will come back as callbacks to client whose calls this function.
    ///
    /// Inputs:
    /// - you have to send your parameters as "SearchContactsRequest" to this function
    ///
    /// Outputs:
    /// - It has 3 callbacks as responses.
    ///
    /// - parameter inputModel:         (input) you have to send your parameters insid this model. (SearchContactsRequest)
    /// - parameter getCacheResponse:   (input) specify if you want to get cache response for this request (Bool?)
    /// - parameter uniqueId:           (response) it will returns the request 'UniqueId' that will send to server. (String)
    /// - parameter completion:         (response) it will returns the response that comes from server to this request. (Any as! GetContactsModel)
    /// - parameter cacheResponse:      (response) there is another response that comes from CacheDB to the user, if user has set 'enableCache' vaiable to be true. (GetContactsModel)
    @available(*,deprecated , message: "use another searchContacts method with uniqueId and uniqueIdResult In Parameter")
    public func searchContacts(inputModel searchContactsInput:  SearchContactsRequest,
                               getCacheResponse:                Bool?,
                               uniqueId:            @escaping ((String) -> ()),
                               completion:          @escaping callbackTypeAlias,
                               cacheResponse:       @escaping (GetContactsModel) -> ()) {
        
        searchContacts(searchContactsInput,
                           getCacheResponse: getCacheResponse,
                           uniqueId: searchContactsInput.uniqueId,
                           uniqueIdResult: uniqueId,
                           completion: completion,
                           cacheResponse: cacheResponse)
    }
    
    public func searchContacts(_ searchContactsRequest:SearchContactsRequest,
                               getCacheResponse:                Bool? = nil,
                               uniqueId:            String? = nil,
                               uniqueIdResult:      ((String)->())? = nil,
                               completion:          @escaping callbackTypeAlias,
                               cacheResponse:       @escaping (GetContactsModel) -> ()) {
        
        log.verbose("Try to request to search contact with this parameters: \n \(searchContactsRequest)", context: "Chat")
        
        let getContactRequest = GetContactsRequest(id:              searchContactsRequest.contactId,
                                                 count:             searchContactsRequest.count ?? 50,
                                                 cellphoneNumber:   searchContactsRequest.cellphoneNumber,
                                                 email:             searchContactsRequest.email,
                                                 offset:            searchContactsRequest.offset ?? 0,
                                                 order:             searchContactsRequest.order,
                                                 query:             searchContactsRequest.query,
                                                 summery:           searchContactsRequest.summery,
                                                 typeCode:          searchContactsRequest.typeCode)
        self.getContacts(getContactRequest,
                         getCacheResponse: getCacheResponse,
                         uniqueId: uniqueId,
                         completion: completion,
                         uniqueIdResult: uniqueIdResult,
                         cacheResponse: cacheResponse)
    }
    
    
    @available(*,deprecated , message: "this method removed in future release use syncContacts(completion:uniqueIdsResult:)")
    public func syncContacts(uniqueIds:     @escaping ([String]) -> (),
                             completion:    @escaping callbackTypeAlias) {
        syncContacts(completion: completion , uniqueIdsResult: uniqueIds)
    }
    
    
    // MARK: Sync Contact
    /// SyncContact:
    /// sync contacts from the client contact with Chat contact.
    ///
    /// By calling this function, HTTP request of type (SEARCH_CONTACTS) will send throut Chat-SDK,
    /// then the response will come back as callbacks to client whose calls this function.
    ///
    /// Inputs:
    /// - this method does not have any input parameters, it actualy gets the device contact automatically
    ///
    /// Outputs:
    /// - It has 2 callbacks as responses.
    ///
    /// - parameter uniqueId:       (response) it will returns the request 'UniqueId' that will send to server. (String)
    /// - parameter completion:     (response) it will returns the response that comes from server to this request. (Any as! [ContactModel])
    public func syncContacts(completion: @escaping callbackTypeAlias , uniqueIdsResult: @escaping ([String])->()){
        /// 1- check permission to has access to contact to read data.
        /// 2- if granted in grant closure get all contacts from user Device
        /// 3- if granted in grant closure get All phoneBook cached and convert them to [Contact]
        /// 4- check if Device contact cellphoneNumber with cache cellphoneNumberis equal and  then we must check for any update to device contact like firstName,lastName,email with isContactChanged method
        ///     if any change occured in contact on device this added to contactsToSync array to be send to server
        /// 5- if contact on device not found with this cellphoneNumber means the contact not synced so we must add it to contactsToSync array
        /// 6- create uniqueIds array and call server to add this new contacts with addContacts method
        /// 7- if server respond suucess contacts will added to PhoneBoock cache to check if in future any change detected.
        log.verbose("Try to request to sync contact", context: "Chat")
        var contactsToSync:[AddContactRequest] = []
        authorizeContactAccess(grant: { [weak self] store in
            guard let weakSelf = self else{return}
            let phoneContacts = weakSelf.getContactsFromAuthorizedStore(store)
            let cachePhoneContacts = Chat.cacheDB.retrievePhoneContacts()
            phoneContacts.forEach { phoneContact in
                if let findedContactCache = cachePhoneContacts.first(where: {$0.cellphoneNumber == phoneContact.cellphoneNumber}){
                    if (PhoneContact.isContactChanged(findedContactCache, phoneContactModel: phoneContact)) {
                        contactsToSync.append(phoneContact.convertToAddRequest())
                    }
                }else{
                    contactsToSync.append(phoneContact.convertToAddRequest())
                }
            }
            var uniqueIds:[String] = []
            contactsToSync.forEach { contact in
                uniqueIds.append(contact.uniqueId) // uniqueId generated in initializer.don't need to set manualy.
            }
            if contactsToSync.count <= 0 {return}
            weakSelf.addContacts(contactsToSync) { result in
                PhoneContact.updateOrInsertPhoneBooks(contacts:contactsToSync)
                completion(result)
            }
            uniqueIdsResult(uniqueIds)
            
        },errorResult:{error in
            print("authorize error\(error)")
        })
    }
    
    private func getContactsFromAuthorizedStore(_ store:CNContactStore) -> [PhoneContactModel] {
        var phoneContacts:[PhoneContactModel] = []
        let keys = [CNContactGivenNameKey,
                    CNContactFamilyNameKey,
                    CNContactPhoneNumbersKey,
                    CNContactEmailAddressesKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        
        try? store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
            var phoneContactModel = PhoneContactModel()
            phoneContactModel.cellphoneNumber = contact.phoneNumbers.first?.value.stringValue ?? ""
            phoneContactModel.firstName       = contact.givenName
            phoneContactModel.lastName        = contact.familyName
            phoneContactModel.email           = contact.emailAddresses.first?.value as String?
            phoneContacts.append(phoneContactModel)
        })
        return phoneContacts
    }
    
    private func authorizeContactAccess(grant: @escaping (CNContactStore)->() , errorResult:((Error)->())? = nil){
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                errorResult?(error)
                return
            }
            if granted {
                grant(store)
            }
        }
    }
    
    @available(*,unavailable , renamed:"updateContact(_:completion:uniqueIdResult:)")
    public func updateContact(inputModel updateContactsInput:  Any,
                              uniqueId:             @escaping (String) -> (),
                              completion:           @escaping callbackTypeAlias) {
    }
    
    // MARK: - Update Contact
    /// UpdateContact:
    /// it will update an existing contact
    ///
    /// By calling this function, HTTP request of type (UPDATE_CONTACTS) will send throut Chat-SDK,
    /// then the response will come back as callbacks to client whose calls this function.
    ///
    /// Inputs:
    /// - you have to send your parameters as "UpdateContactsRequest" to this function
    ///
    /// Outputs:
    /// - It has 3 callbacks as responses.
    ///
    /// - parameter updateContactRequest: (input) you have to send your parameters insid this model. (UpdateContactsRequest)
    /// - parameter uniqueIdResult:   (response) it will returns the request 'UniqueId' that will send to server. (String)
    /// - parameter completion: (response) it will returns the response that comes from server to this request. (Any as! ContactModel)
    public func updateContact(_ updateContactRequest:  UpdateContactRequest,
                              completion:           @escaping callbackTypeAlias,
                              uniqueIdResult:       ((String) -> ())? = nil){
        log.verbose("Try to request to update contact with this parameters: \n \(updateContactRequest)", context: "Chat")
        uniqueIdResult?(updateContactRequest.uniqueId)
        
        guard let createChatModel = createChatModel else {return}
        let url = "\(createChatModel.platformHost)\(SERVICES_PATH.UPDATE_CONTACTS.rawValue)"
        let headers: HTTPHeaders = ["_token_": createChatModel.token, "_token_issuer_": "1"]
        Networking.request(ofType: ContactResponse.self,
                           from: url,
                           withMethod: .post,
                           withHeaders: headers,
                           encodableRequest: updateContactRequest) { contactResponse in
            if let contactResponse = contactResponse{
                self.addContactOnCache(contactResponse.contacts)
                completion(contactResponse)
            }
        }
    }
	

	@available(*,deprecated , message: "use another searchContacts method with uniqueId and uniqueIdResult In Parameter")
	public func blockContact(inputModel blockContactsInput:    BlockRequest,
							 uniqueId:              @escaping (String) -> (),
							 completion:            @escaping callbackTypeAlias) {
		blockContact(blockContactsInput,
					 uniqueId: blockContactsInput.uniqueId,
					 completion: completion,
					 uniqueIdResult: uniqueId)
	}
	
	/// BlockContact:
	/// block a contact by its contactId.
	///
	/// By calling this function, a request of type 7 (BLOCK) will send throut Chat-SDK,
	/// then the response will come back as callbacks to client whose calls this function.
	///
	/// Inputs:
	/// - you have to send your parameters as "BlockRequest" to this function
	///
	/// Outputs:
	/// - It has 3 callbacks as responses.
	///
	/// - parameter blockRequest: (input) you have to send your parameters insid this model. (BlockRequest)
	/// - parameter uniqueIdResult:   (response) it will returns the request 'UniqueId' that will send to server. (String)
	/// - parameter completion: (response) it will returns the response that comes from server to this request. (Any as! BlockedUserModel)
	public func blockContact(_ blockRequest:BlockRequest ,
						uniqueId:String? = nil,
						typeCode:String? = nil,
						completion:@escaping callbackTypeAlias,
						uniqueIdResult:((String) -> ())? = nil ){
		guard let createChatModel = createChatModel , let content = blockRequest.convertCodableToString() else {return}
		log.verbose("Try to request to block user with this parameters: \n \(blockRequest)", context: "Chat")
		let unqId = uniqueId ?? UUID().uuidString
		uniqueIdResult?(unqId)
		blockCallbackToUser = completion
		
		let chatMessage = SendChatMessageVO(chatMessageVOType:  ChatMessageVOTypes.BLOCK.intValue(),
											token:              createChatModel.token,
											content:            "\(content)",
											typeCode:           typeCode ?? createChatModel.typeCode ?? "defualt",
											isCreateThreadAndSendMessage: true)
		
		let asyncMessage = SendAsyncMessageVO(content:      chatMessage.convertModelToString(),
											  msgTTL:       createChatModel.msgTTL,
											  peerName:     createChatModel.serverName,
											  priority:     createChatModel.msgPriority)
		
		sendMessageWithCallback(asyncMessageVO:     asyncMessage,
								callbacks:          [(BlockCallbacks(),unqId)],
								sentCallback:       nil,
								deliverCallback:    nil,
								seenCallback:       nil)
		
	}
	
	
	/// GetBlockContactsList:
	/// it returns a list of the blocked contacts.
	///
	/// By calling this function, a request of type 25 (GET_BLOCKED) will send throut Chat-SDK,
	/// then the response will come back as callbacks to client whose calls this function.
	///
	/// Inputs:
	/// - you have to send your parameters as "GetBlockedListRequest" to this function
	///
	/// Outputs:
	/// - It has 3 callbacks as responses.
	///
	/// - parameter inputModel:         (input) you have to send your parameters insid this model. (GetBlockedListRequest)
	/// - parameter getCacheResponse:   (input) specify if you want to get cache response for this request (Bool?)
	/// - parameter uniqueId:           (response) it will returns the request 'UniqueId' that will send to server. (String)
	/// - parameter completion:         (response) it will returns the response that comes from server to this request. (Any as! GetBlockedUserListModel)
	@available(*,deprecated , message: "use blockedContacts method with uniqueId and uniqueIdResult In Parameter")
	public func getBlockedContacts(inputModel getBlockedContactsInput:  BlockedListRequest,
								   getCacheResponse:                    Bool?,
								   uniqueId:                @escaping (String) -> (),
								   completion:              @escaping callbackTypeAlias) {
	
		blockedContacts(getBlockedContactsInput,
						   typeCode: getBlockedContactsInput.typeCode,
						   uniqueId: getBlockedContactsInput.uniqueId,
						   getCacheResponse: getCacheResponse,
						   completion: completion,
						   uniqueIdResult: uniqueId)
	}
	
	public func blockedContacts(_ blockedListRequest:BlockedListRequest,
								   typeCode:String? = nil,
								   uniqueId:String? = nil,
								   getCacheResponse: Bool? = false,
								   completion:@escaping callbackTypeAlias,
								   uniqueIdResult:((String)->())? = nil
								   ){
		guard let createChatModel = createChatModel , let content = blockedListRequest.convertCodableToString() else {return}
		log.verbose("Try to request to get block users with this parameters: \n \(blockedListRequest)", context: "Chat")
		let unqId = uniqueId ?? UUID().uuidString
		uniqueIdResult?(unqId)
		getBlockedListCallbackToUser = completion
		
		let chatMessage = SendChatMessageVO(chatMessageVOType:  ChatMessageVOTypes.GET_BLOCKED.intValue(),
											token:              createChatModel.token,
											content:            "\(content)",
											typeCode:           typeCode ?? createChatModel.typeCode ?? "default",
											uniqueId:           unqId,
											isCreateThreadAndSendMessage: true)
		
		let asyncMessage = SendAsyncMessageVO(content:      chatMessage.convertModelToString(),
											  msgTTL:       createChatModel.msgTTL,
											  peerName:     createChatModel.serverName,
											  priority:     createChatModel.msgPriority)
		
		sendMessageWithCallback(asyncMessageVO:     asyncMessage,
								callbacks:          [(GetBlockedUsersCallbacks(parameters: chatMessage), unqId)],
								sentCallback:       nil,
								deliverCallback:    nil,
								seenCallback:       nil)
		
		if (getCacheResponse ?? createChatModel.enableCache) {
			// ToDo: get blocked contacts from cache
		}
	}
		
	/// UnblockContact:
	/// unblock a contact from blocked list.
	///
	/// By calling this function, a request of type 8 (UNBLOCK) will send throut Chat-SDK,
	/// then the response will come back as callbacks to client whose calls this function.
	///
	/// Inputs:
	/// - you have to send your parameters as "UnblockRequest" to this function
	///
	/// Outputs:
	/// - It has 3 callbacks as responses.
	///
	/// - parameter inputModel: (input) you have to send your parameters insid this model. (UnblockRequest)
	/// - parameter uniqueId:   (response) it will returns the request 'UniqueId' that will send to server. (String)
	/// - parameter completion: (response) it will returns the response that comes from server to this request. (Any as! BlockedUserModel)
	public func unblockContact(inputModel unblockContactsInput:    UnblockRequest,
							   uniqueId:                @escaping (String) -> (),
							   completion:              @escaping callbackTypeAlias) {
		guard let createChatModel = createChatModel else {return}
		log.verbose("Try to request to unblock user with this parameters: \n \(unblockContactsInput)", context: "Chat")
		uniqueId(unblockContactsInput.uniqueId)
		
		unblockUserCallbackToUser = completion
		
		let chatMessage = SendChatMessageVO(chatMessageVOType:  ChatMessageVOTypes.UNBLOCK.intValue(),
											token:              createChatModel.token,
											content:            "\(unblockContactsInput.convertContentToJSON())",
											subjectId:          unblockContactsInput.blockId,
											typeCode:           unblockContactsInput.typeCode ?? createChatModel.typeCode,
											uniqueId:           unblockContactsInput.uniqueId,
											isCreateThreadAndSendMessage: true)
		
		let asyncMessage = SendAsyncMessageVO(content:      chatMessage.convertModelToString(),
											  msgTTL:       createChatModel.msgTTL,
											  peerName:     createChatModel.serverName,
											  priority:     createChatModel.msgPriority)
		
		sendMessageWithCallback(asyncMessageVO:     asyncMessage,
								callbacks:          [(UnblockCallbacks(), unblockContactsInput.uniqueId)],
								sentCallback:       nil,
								deliverCallback:    nil,
								seenCallback:       nil)
	}
}

