//
//  MapStaticImageRequest.swift
//  FanapPodChatSDK
//
//  Created by Mahyar Zhiani on 10/12/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import Foundation

open class MapStaticImageRequest : Encodable {
	
	
    
	public var key    : String
    public var center : (lat : Double, lng : Double)
    public var height : Int      = 500
    public var type   : String = "standard-night"
    public var width  : Int     = 800
    public var zoom   : Int    = 15
    
	public init(centerLat :Double ,
				centerLng:Double ,
				key:String? = nil,
				height:Int = 500,
				width:Int = 800,
				zoom:Int = 15,
				type:String = "standard-night"
	) {
		self.center = (centerLat , centerLng)
		self.type = type
		self.height = height
		self.width = width
		self.zoom = zoom
		self.key = key ?? ""
	}
	
	private enum CodingKeys : String  ,CodingKey{
		case key
		case center
		case type
		case width
		case height
		case zoom
	}
	
	public func encode(to encoder: Encoder) throws {
		var  container = encoder.container(keyedBy: CodingKeys.self)
		try? container.encode("\(center.lat),\(center.lng)", forKey: .center)
		try? container.encode(key, forKey: .key)
		try? container.encode(width, forKey: .width)
		try? container.encode(height, forKey: .height)
		try? container.encode(zoom, forKey: .zoom)
		try? container.encode(type, forKey: .type)
	}
    
}



