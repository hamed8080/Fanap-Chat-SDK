//
//  BaseRequest.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
public  class BaseRequest: Encodable{
	
	public var uniqueId:String?
	public var typeCode:String?
	

	public init(uniqueId:String? = nil , typeCode:String? = nil) {
		self.uniqueId = uniqueId ?? UUID().uuidString
		self.typeCode = typeCode ?? Chat.sharedInstance.createChatModel?.typeCode ?? "defualt"
	}
	
	public func encode(to encoder: Encoder) throws {
		//this empty method must prevent encode values
	}
}
