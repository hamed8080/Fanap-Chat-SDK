//
//  MapRoutingRequest.swift
//  FanapPodChatSDK
//
//  Created by Mahyar Zhiani on 10/11/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
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

open class MapRoutingRequest : Encodable {

    public   var alternative:     Bool = true
    private  let destination:Cordinate
    private  let origin:Cordinate
    
    @available(*,deprecated , message: "removed in future release use another init.")
    public init(alternative:    Bool?,
                destination:    (Double, Double),
                origin:         (Double, Double)) {
        
        self.alternative    = alternative ?? true
        self.origin         = Cordinate(lat: origin.0, lng: origin.1)
        self.destination    = Cordinate(lat: destination.0, lng: destination.1)
    }
    
    public init(alternative:    Bool?,
                origin: Cordinate,
                destination: Cordinate) {
        
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

@available(*,unavailable , message: "use MapRoutingRequest class")
open class MapRoutingRequestModel: MapRoutingRequest {
    
}

