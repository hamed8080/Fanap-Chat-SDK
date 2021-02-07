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
	
	public var size       		: Int = 50
	public var offset      		: Int = 0
	
	//use in cashe
	public let id       			: Int? //contact id to client app can query and find a contact in cache core data with id
	public let cellphoneNumber 		: String?
	public let email           	: String?
	public let order           	: String?
	public let query           	: String?
	public var summery         	: Bool? = nil
	public let typeCode    		: String?
	
	@available(*,deprecated , message: "removed in future release use uniqueId In getContacts method params")
	public var uniqueId    		: String =  UUID().uuidString
	
	
	@available(*,deprecated , message: "removed in future release use another init without uniqueId params")
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
		
		self.size     		 	= count
		self.offset     		 	= offset
		self.id         			= id
		self.cellphoneNumber   	= cellphoneNumber
		self.email             	= email
		self.order             	= order?.rawValue ?? nil
		self.query             	= query
		self.summery           	= summery
		self.typeCode   			= typeCode
		
		self.uniqueId   			= uniqueId
	}
	
	
	public init( id:           		Int? = nil,
				 count:             Int = 50,
				 cellphoneNumber:   String? = nil,
				 email:             String? = nil,
				 offset:            Int = 0 ,
				 order:             Ordering? = nil,
				 query:             String? = nil,
				 summery:           Bool? = nil,
				 typeCode:          String? = nil) {
		
		self.size     		 	= count
		self.offset     		 	= offset
		self.id         			= id
		self.cellphoneNumber   	= cellphoneNumber
		self.email             	= email
		self.order             	= order?.rawValue ?? nil
		self.query             	= query
		self.summery           	= summery
		self.typeCode   			= typeCode
	}
	
	private enum CodingKeys:String ,CodingKey{
		case size
		case offset
		case id
		case cellphoneNumber
		case email
		case order
		case query
		case summery
		case typeCode
	}
	
	@available(*,deprecated , message: "removed in future release after remove uniqueId from this class")
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try? container.encodeIfPresent(size, forKey: .size)
		try? container.encodeIfPresent(offset, forKey: .offset)
		try? container.encodeIfPresent(id, forKey: .id)
		try? container.encodeIfPresent(cellphoneNumber, forKey: .cellphoneNumber)
		try? container.encodeIfPresent(email, forKey: .email)
		try? container.encodeIfPresent(order, forKey: .order)
		try? container.encodeIfPresent(summery, forKey: .summery)
		try? container.encodeIfPresent(typeCode, forKey: .typeCode)
		if let query = self.query {
			let theQuery = MakeCustomTextToSend(message: query).replaceSpaceEnterWithSpecificCharecters()
			let contentQuery  = JSON(theQuery)
			try? container.encode(contentQuery, forKey: .query)
		}
	}
	
}

@available(*, unavailable,message: "the class was removed use GetContactsRequest instead")
open class GetContactsRequestModel: GetContactsRequest {
}

