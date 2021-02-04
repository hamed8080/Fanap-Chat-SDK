//
//  GetContactsRequestModel.swift
//  Chat
//
//  Created by Mahyar Zhiani on 10/1/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import FanapPodAsyncSDK
import SwiftyJSON

open class GetContactsRequest : Codable {
	
	public var count       		: Int = 50
	public var offset      		: Int = 0
	public let id       			: Int? //contact id to client app can query and find a contact in cache core data with id
	public let cellphoneNumber 		: String?
	public let email           	: String?
	public let order           	: String?
	public let query           	: String?
	public var summery         	: Bool? = nil
	public let typeCode    		: String?
	public var uniqueId    		: String =  UUID().uuidString
	
	public init( id:           Int? = nil,
		  count:             Int = 50,
		  cellphoneNumber:   String? = nil,
		  email:             String? = nil,
		  offset:            Int = 0 ,
		  order:             Ordering? = nil,
		  query:             String? = nil,
		  summery:           Bool? = nil,
		  typeCode:          String? = nil,
		  uniqueId:          String = UUID().uuidString) {
		
		self.count     		 	= count
		self.offset     		 	= offset
		self.id         			= id
		self.cellphoneNumber   	= cellphoneNumber
		self.email           	 	= email
		self.order             	= order?.rawValue ?? nil
		self.query             	= query
		self.summery           	= summery
		self.typeCode   			= typeCode
		self.uniqueId   			= uniqueId
		
	}
	
	
//	public func convertContentToJSON() -> JSON {
//		var content: JSON = [:]
//
//		if let query = self.query {
//			let theQuery = MakeCustomTextToSend(message: query).replaceSpaceEnterWithSpecificCharecters()
//			content["query"] = JSON(theQuery)
//		}
//	}
	
}

@available(*, unavailable,message: "the class was removed use GetContactsRequest instead")
open class GetContactsRequestModel: GetContactsRequest {
}

