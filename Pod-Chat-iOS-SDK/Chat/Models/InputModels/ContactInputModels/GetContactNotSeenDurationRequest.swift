//
//  NotSeenDurationRequestModel.swift
//  FanapPodChatSDK
//
//  Created by MahyarZhiani on 10/30/1398 AP.
//  Copyright © 1398 Mahyar Zhiani. All rights reserved.
//

import Foundation

open class GetNotSeenDurationRequest: Encodable {
    
	public let userIds     : [Int]
	
	@available(*,deprecated , message: "removed in future release use typeCode In contactNotSeenDuration method params")
	public var typeCode    : String? = nil
	
	@available(*,deprecated , message: "removed in future release use uniqueId In contactNotSeenDuration method params")
	public var uniqueId    : String = UUID().uuidString
    
	
	@available(*,deprecated , message: "removed in future release use another init without uniqueId params")
    public init(userIds: [Int], typeCode: String?, uniqueId: String?) {
        self.userIds    = userIds
        self.typeCode   = typeCode
		self.uniqueId   = uniqueId ?? UUID().uuidString
    }
	
	public init(userIds: [Int]) {
		self.userIds    = userIds
	}
    
}


@available(*,unavailable, message: "use GetNotSeenDurationRequest class instead")
open class NotSeenDurationRequestModel: GetNotSeenDurationRequest {
}

