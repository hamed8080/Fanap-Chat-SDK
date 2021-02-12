//
//  MapReverseRequest.swift
//  FanapPodChatSDK
//
//  Created by Mahyar Zhiani on 10/11/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import Foundation

open class MapReverseRequest :Encodable {
    
    public let lat:     Double
    public let lng:     Double
    public var uniqueId = UUID().uuidString
    
    public init(lat:    Double,
                lng:    Double,
                uniqueId:String = UUID().uuidString
    ) {
        
        self.lat      = lat
        self.lng      = lng
        self.uniqueId = uniqueId
    }
    
}

@available(*,unavailable , message:"use MapReverseRequest class")
open class MapReverseRequestModel: MapReverseRequest {}






