//
//  MapSearchRequest.swift
//  FanapPodChatSDK
//
//  Created by Mahyar Zhiani on 10/11/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import Foundation

public class MapSearchRequest : BaseRequest {
    
    public let lat:     Double
    public let lng:     Double
    public let term:    String
    
    public init(lat:    Double,
                lng:    Double,
                term:   String) {
        
        self.lat    = lat
        self.lng    = lng
        self.term   = term
    }
	
	private enum CodingKeys:String , CodingKey{
		case lat = "lat"
		case lng = "lng"
		case term = "term"
	}
	
	public override func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try? container.encode(lat, forKey: .lat)
		try? container.encode(lng, forKey: .lng)
		try? container.encode(term, forKey: .term)
	}
    
}


public class MapSearchRequestModel: MapSearchRequest {
    
}


