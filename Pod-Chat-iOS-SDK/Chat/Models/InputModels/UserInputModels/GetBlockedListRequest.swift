//
//  GetBlockedListRequest.swift
//  Chat
//
//  Created by Mahyar Zhiani on 10/1/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

@available(*,unavailable, renamed: "BlockedListRequest")
open class GetBlockedListRequest{}

open class BlockedListRequest : Encodable {
    
    public let count:       Int?
    public let offset:      Int?
    
	@available(*,deprecated , message: "removed in future release. use typeCode In blockContact method params")
	public var typeCode:    String? = nil
	
	@available(*,deprecated , message: "removed in future release. use uniqueId inside blockContact method parameter.")
	public let uniqueId:    String
	
	@available(*,deprecated , message: "removed in future release use another init without uniqueId  and typeCode params")
    public init(count:      Int?,
                offset:     Int?,
                typeCode:   String?,
                uniqueId:   String?) {
        
        self.count      = count
        self.offset     = offset
        
        self.typeCode   = typeCode
        self.uniqueId   = uniqueId ?? UUID().uuidString
    }
	
	public init (count: Int? = 50 , offset: Int = 0){
		self.count      = count
		self.offset     = offset
		self.uniqueId   = UUID().uuidString
	}
	
	private enum CodingKeys: String ,CodingKey{
		case count
		case offset
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try? container.encode(count, forKey: .count)
		try? container.encode(offset, forKey: .offset)
	}
}


@available(*,unavailable,message: "use GetBlockedListRequest")
open class GetBlockedContactListRequestModel: GetBlockedListRequest {}
