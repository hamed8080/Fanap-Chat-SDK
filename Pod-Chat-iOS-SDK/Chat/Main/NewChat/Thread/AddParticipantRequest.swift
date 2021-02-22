//
//  AddParticipantRequest.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/22/21.
//

import Foundation
public struct AddParticipantRequest: Encodable {
	
	public  let id       : String
	private let idType    : InviteeVoIdTypes
	
	public init(userName:String){
		idType = .TO_BE_USER_USERNAME
		self.id = userName
	}
	
	public init (contactId:Int){
		idType = .TO_BE_USER_CONTACT_ID
		self.id = "\(contactId)"
	}
	
	public init (coreUserId:Int){
		idType = .TO_BE_USER_ID
		self.id = "\(coreUserId)"
	}
	
}
