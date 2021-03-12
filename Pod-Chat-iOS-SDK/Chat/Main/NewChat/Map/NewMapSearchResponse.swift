//
//  NewMapSearchResponse.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/1/21.
//

import Foundation

open class NewMapSearchResponse : NewResponseModel{
	
	public var count:   Int
	public var items:   [NewMapItem]?
	
	private enum CodingKeys : String , CodingKey{
		case count       = "count"
		case items      = "items"
		case hasError     = "hasError"
		case errorMessage = "errorMessage"
		case errorCode    = "errorCode"
	}
	
	public required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let hasError = (try container.decodeIfPresent(Bool.self, forKey: .hasError)) ?? false
		let errorCode = (try container.decodeIfPresent(Int.self, forKey: .errorCode)) ?? 0
		let errorMessage = (try container.decodeIfPresent(String.self, forKey: .errorMessage)) ?? ""
		count = (try container.decodeIfPresent(Int.self, forKey: .count)) ?? 0
		items = (try container.decodeIfPresent([NewMapItem].self, forKey: .items)) ?? nil
		
		super.init(hasError: hasError, errorMessage: errorMessage, errorCode: errorCode)
	}
}

open class NewMapItem : Codable{
	
	public let address    :     String?
	public let category   :    String?
	public let region     :      String?
	public let type       :        String?
	public let title      :       String?
	public var location   :    NewLocation?
	public var neighbourhood :String?
}

open class NewLocation : Codable{
	
	public let x: Double
	public let y: Double
}
