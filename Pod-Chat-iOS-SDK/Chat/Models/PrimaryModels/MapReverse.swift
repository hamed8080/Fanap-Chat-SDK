//
//  MapReverse.swift
//  FanapPodChatSDK
//
//  Created by Mahyar Zhiani on 10/11/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import Foundation
import SwiftyJSON


open class MapReverse : Codable {
    
    public var address:             String?
    public var city:                String?
    public var neighbourhood:       String?
    
    @available(*,unavailable,renamed: "inOddEvenZone")
    public var in_odd_even_zone : Bool?
    public var inOddEvenZone    : Bool?
    
    @available(*,unavailable,renamed: "in_traffic_zone")
    public var in_traffic_zone:     Bool?
    public var inTrafficZone:Bool?
    
    @available(*,unavailable,renamed: "municipalityZone")
    public var municipality_zone:   Int?
    public var municipalityZone:String?
    
    public var state:               String?
    
    
    private enum CodingKeys : String ,CodingKey{
        case address          = "address"
        case city             = "city"
        case neighbourhood    = "neighbourhood"
        case inOddEvenZone    = "in_odd_even_zone"
        case inTrafficZone    = "in_traffic_zone"
        case municipalityZone = "municipality_zone"
        case state            = "state"
    }
    
    public required init(from decoder: Decoder) throws {
        let container       = try decoder.container(keyedBy: CodingKeys.self)
        address             = (try? container.decodeIfPresent(String.self, forKey : .address)) ?? nil
        city                = (try? container.decodeIfPresent(String.self, forKey : .city)) ?? nil
        neighbourhood       = (try? container.decodeIfPresent(String.self, forKey : .neighbourhood)) ?? nil
        inOddEvenZone       = (try? container.decodeIfPresent(Bool.self, forKey : .inOddEvenZone)) ?? nil
        inTrafficZone       = (try? container.decodeIfPresent(Bool.self, forKey : .inTrafficZone)) ?? false
        municipalityZone    = (try? container.decodeIfPresent(String.self, forKey : .municipalityZone)) ?? nil
        state               = (try? container.decodeIfPresent(String.self, forKey : .state)) ?? nil
    }
}
