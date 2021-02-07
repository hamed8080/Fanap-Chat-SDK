//
//  ContactResponse.swift
//  Chat
//
//  Created by Mahyar Zhiani on 7/23/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import Foundation
import SwiftyJSON


open class ContactResponse: ResponseModel , Decodable {

    public var contentCount     : Int = 0
    public var contacts         : [Contact] = []
    
    private enum CodingKeys:String , CodingKey{
        case contacts     = "result"
        case contentCount = "count"
        case hasError     = "hasError"
        case message      = "message"
        case errorCode    = "errorCode"
    }
    
    public required init(from decoder: Decoder) throws {
        let container     =  try  decoder.container(keyedBy: CodingKeys.self)
        contacts          = (try? container.decode([Contact].self, forKey: .contacts)) ?? []
        contentCount      = (try? container.decode(Int.self, forKey: .contentCount)) ?? 0
        let errorCode     = (try? container.decode(Int.self, forKey: .errorCode)) ?? 0
        let hasError      = (try? container.decode(Bool.self, forKey: .hasError)) ?? false
        let message       = (try? container.decode(String.self, forKey: .message)) ?? ""
        super.init(hasError: hasError, errorMessage: message, errorCode: errorCode)
    }

    @available(*,deprecated , message: "removed in future release dont use this contsuctor ,it's internal purpose")
    public init(contentCount   : Int,
                contacts       : [Contact]?,
                hasError       : Bool,
                errorMessage   : String?,
                errorCode      : Int?) {
        
        self.contacts = contacts ?? []
        self.contentCount = contentCount
        super.init(hasError:        hasError,
                   errorMessage:    errorMessage ?? "",
                   errorCode:       errorCode ?? 0)
    }
}
