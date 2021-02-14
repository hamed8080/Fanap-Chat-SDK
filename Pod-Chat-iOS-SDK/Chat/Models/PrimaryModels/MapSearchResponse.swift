//
//  MapSearch.swift
//  FanapPodChatSDK
//
//  Created by Mahyar Zhiani on 10/11/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import Foundation

open class MapSearchResponse : ResponseModel{
    
    public var count:   Int
    public var items:   [MapItem]?
	
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
		items = (try container.decodeIfPresent([MapItem].self, forKey: .items)) ?? nil
		
		super.init(hasError: hasError, errorMessage: errorMessage, errorCode: errorCode)
	}
}

open class MapItem : Codable{
    
    public let address    :     String?
    public let category   :    String?
    public let region     :      String?
    public let type       :        String?
    public let title      :       String?
    public var location   :    Location?
	public var neighbourhood :String?
}

open class Location : Codable{
    
    public let x: Double
    public let y: Double
}

