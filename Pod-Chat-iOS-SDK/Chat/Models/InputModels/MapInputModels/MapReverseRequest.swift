//
//  MapReverseRequest.swift
//  FanapPodChatSDK
//
//  Created by Mahyar Zhiani on 10/11/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import Foundation

public class MapReverseRequest :BaseRequest {
    
    public let lat:     Double
    public let lng:     Double
    
    public init(lat:    Double,
                lng:    Double) {
        
        self.lat    = lat
        self.lng    = lng
    }
	
	private enum CodingKeys :String , CodingKey{
		case lat = "lat"
		case lng = "lng"
	}
	
	public override func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try? container.encode(lat, forKey: .lat)
		try? container.encode(lng, forKey: .lng)
	}
    
}


public class MapReverseRequestModel: MapReverseRequest {
    
}






