//
//  NewRemoveContactsRequest.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/12/21.
//

import Foundation
public class NewRemoveContactsRequest : BaseRequest{

    public let contactId:   Int
    public init(contactId:  Int, typeCode:String = "default") {
        
        self.contactId  = contactId
        super.init(uniqueId: nil, typeCode: typeCode)
    }
    
    private enum CodingKeys:String ,CodingKey{
        case contactId = "id"
        case typeCode  = "typeCode"
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(contactId, forKey: .contactId)
        try? container.encode(typeCode, forKey: .typeCode)
    }
    
}
