//
//  NewMapRoutingRequest.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/1/21.
//

import Foundation

public struct Cordinate  {
	public let lat:Double
	public let lng:Double
	
	public init(lat:Double , lng:Double) {
		self.lat = lat
		self.lng = lng
	}
}

open class NewMapRoutingRequest : Encodable {
	
	public   var alternative: Bool = true
	private  let destination:Cordinate
	private  let origin:Cordinate
	
	public init(alternative:    Bool?, origin: Cordinate, destination: Cordinate) {
		
		self.alternative = alternative ?? true
		self.destination = origin
		self.origin      = destination
	}
	
	private enum CodingKeys:String , CodingKey{
		case alternative = "alternative"
		case origin      = "origin"
		case destination = "destination"
	}
	
	public func encode(to encoder: Encoder) throws {
		var continer = encoder.container(keyedBy: CodingKeys.self)
		try? continer.encode("\(origin.lat),\(origin.lng)", forKey: .origin)
		try? continer.encode("\(destination.lat),\(destination.lng)", forKey: .destination)
		try? continer.encode(alternative, forKey: .alternative)
	}
	
}
