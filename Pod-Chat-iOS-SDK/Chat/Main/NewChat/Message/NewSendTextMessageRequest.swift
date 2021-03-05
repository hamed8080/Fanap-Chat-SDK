//
//  NewSendTextMessageRequest.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/5/21.
//

import Foundation
public class NewSendTextMessageRequest : BaseRequest {
    
    public let messageType:     MessageType
    public let metadata:        String?
    public let repliedTo:       Int?
    public let systemMetadata:  String?
    public let textMessage:     String
    public let threadId:        Int
    
    public init(threadId: Int, textMessage: String, messageType: MessageType, metadata: String? = nil, repliedTo: Int? = nil, systemMetadata: String? = nil) {
        self.messageType    = messageType
        self.metadata       = metadata
        self.repliedTo      = repliedTo
        self.systemMetadata = systemMetadata
        self.textMessage    = textMessage
        self.threadId       = threadId
    }
    
    
}
