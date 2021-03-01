//
//  UpdateContactRequest.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/1/21.
//

import Foundation

public struct UpdateContactRequest :Encodable {
	
	public let cellphoneNumber: String
	public let email:           String
	public let firstName:       String
	public let id:              Int
	public let lastName:        String
	public let username:        String
	
	public init(cellphoneNumber:    String,
				email:              String,
				firstName:          String,
				id:                 Int,
				lastName:           String,
				username:           String) {
		
		self.cellphoneNumber    = cellphoneNumber
		self.email              = email
		self.firstName          = firstName
		self.id                 = id
		self.lastName           = lastName
		self.username           = username
	}

}
