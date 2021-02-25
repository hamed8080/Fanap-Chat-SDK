//
//  StatusPing.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/24/21.
//

import Foundation
public struct StatusPing : Encodable{
	
	public let statusType:StatusPingType
	public let id:Int?
	
	public init(statusType:StatusPingType){
		self.id = nil
		self.statusType = statusType
	}
	
	public init(statusType:StatusPingType , contactId:Int){
		self.id = contactId
		self.statusType = statusType
	}
	
	public init(statusType:StatusPingType , threadId:Int){
		self.id = threadId
		self.statusType = statusType
	}
	
	private enum CodingKeys : String ,CodingKey{
		case location = "location"
		case locationId = "locationId"
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		if statusType == .CHAT {
			try container.encode(1, forKey: .location)
		}else if statusType == .CONTACTS || statusType == .CONTACT_ID{
			try container.encode(3, forKey: .location)
		}else if statusType == .THREAD || statusType == .THREAD_ID{
			try container.encode(2, forKey: .location)
		}
		try container.encodeIfPresent(id, forKey: .locationId)
	}
}


public enum StatusPingType : Int , Encodable{
	case CHAT
	case THREAD
	case CONTACTS
	case THREAD_ID
	case CONTACT_ID
}
