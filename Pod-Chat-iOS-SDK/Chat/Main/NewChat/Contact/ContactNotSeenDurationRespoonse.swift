//
//  ContactNotSeenDurationRespoonse.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/1/21.
//

import Foundation
open class ContactNotSeenDurationRespoonse: ResponseModel {
	
	public let notSeenDuration: [UserLastSeenDuration]
	
	private enum CodingKeys : String ,CodingKey{
		case hasError     = "hasError"
		case message      = "message"
		case errorCode    = "errorCode"
	}
	
	public required init(from decoder: Decoder) throws {
		if let unkeyedContainer = try? decoder.singleValueContainer() , let dictionary = try? unkeyedContainer.decode([String:Int?].self){
			notSeenDuration = dictionary.map{UserLastSeenDuration(userId: Int($0) ?? 0, time: $1 ?? 0)}
			super.init(hasError: false, errorMessage: "", errorCode: 0)
		}else{
			let container = try decoder.container(keyedBy: CodingKeys.self)
			let hasError = try container.decodeIfPresent(Bool.self, forKey: .hasError) ?? false
			let code = try container.decodeIfPresent(Int.self, forKey: .errorCode) ?? 0
			let message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
			notSeenDuration = []
			super.init(hasError: hasError, errorMessage: message, errorCode: code)
		}
	}
}
