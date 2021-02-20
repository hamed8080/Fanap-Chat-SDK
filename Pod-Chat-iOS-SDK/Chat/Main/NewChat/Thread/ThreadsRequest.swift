//
//  ThreadsRequest.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/20/21.
//

import Foundation
import FanapPodAsyncSDK

public struct ThreadsRequest : Encodable {
	
	public let count : Int
	public let offset : Int
	public var name : String? = nil
	public let new : Bool?
	public let threadIds : [Int]?
	public let creatorCoreUserId : Int?
	public let partnerCoreUserId : Int?
	public let partnerCoreContactId : Int?
	public var metadataCriteria : String? = nil
	
	
	
	public init(count:Int = 50 ,
				offset:Int = 0,
				name:String? = nil,
				new:Bool? = nil,
				threadIds:[Int]? = nil,
				creatorCoreUserId:Int? = nil,
				partnerCoreUserId:Int? = nil,
				partnerCoreContactId:Int? = nil,
				metadataCriteria:String? = nil)
	{
		self.count                = 	count
		self.offset               = 		offset
		if let name = name {
			self.name = MakeCustomTextToSend(message: name).replaceSpaceEnterWithSpecificCharecters()
		}
		if let metadataCriteria = metadataCriteria{
			self.metadataCriteria = MakeCustomTextToSend(message: metadataCriteria).replaceSpaceEnterWithSpecificCharecters()
		}
		
		self.new                  = 		new
		self.threadIds            = 		threadIds
		self.creatorCoreUserId    = 		creatorCoreUserId
		self.partnerCoreUserId    = 		partnerCoreUserId
		self.partnerCoreContactId = 		partnerCoreContactId
	}
}
