//
//  NewSendChatMessageVO.swift
//  FanapPodChatSDK
//
//  Created by MahyarZhiani on 10/4/1398 AP.
//  Copyright © 1398 Mahyar Zhiani. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct NewSendChatMessageVO : Codable {
	
	
	
	let chatMessageVOType            : Int
	let token                        : String
	var content                      : String?             = nil
	var messageType                  :        Int?         = nil
	var metadata                     :           String?   = nil
	var repliedTo                    :          Int?       = nil
	var systemMetadata               :     String?         = nil
	var subjectId                    :          Int?       = nil
	var tokenIssuer                  :        Int?         = nil
	var typeCode                     :           String?   = nil
	var uniqueId                     :           String?   = nil
	var uniqueIds                    :          [String]?  = nil
	var isCreateThreadAndSendMessage : Bool                = false
	
	private enum CodingKeys : String ,CodingKey{
		case chatMessageVOType
		case type
		case tokenIssuer
		case token
		case content
		case messageType
		case metadata
		case repliedTo
		case subjectId
		case systemMetadata
		case typeCode
		case uniqueId
		case isCreateThreadAndSendMessage
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try? container.encodeIfPresent(chatMessageVOType, forKey: .type)
		try? container.encodeIfPresent(token, forKey: .token)
		try? container.encodeIfPresent(tokenIssuer ?? 1, forKey: .tokenIssuer)
		try? container.encodeIfPresent(content, forKey: .content)
		try? container.encodeIfPresent(messageType, forKey: .messageType)
		try? container.encodeIfPresent(metadata, forKey: .metadata)
		try? container.encodeIfPresent(repliedTo, forKey: .repliedTo)
		try? container.encodeIfPresent(subjectId, forKey: .subjectId)
		try? container.encodeIfPresent(systemMetadata, forKey: .systemMetadata)
		try? container.encodeIfPresent(typeCode, forKey: .typeCode)
		if let uniqueIds = uniqueIds {
			try? container.encodeIfPresent("\(uniqueIds)", forKey: .uniqueId)
		}else{
			try? container.encodeIfPresent(uniqueId, forKey: .uniqueId)
		}
	}
	
	public init(from decoder: Decoder) throws {
		let container = try? decoder.container(keyedBy: CodingKeys.self)
		token = (try container?.decodeIfPresent(String.self, forKey: .token)) ?? ""
		tokenIssuer =  (try container?.decodeIfPresent(Int.self, forKey: .tokenIssuer)) ?? 1
		chatMessageVOType = (try container?.decodeIfPresent(Int.self, forKey: .chatMessageVOType)) ?? 0
		content = try container?.decodeIfPresent(String.self, forKey: .content)
		metadata = try container?.decodeIfPresent(String.self, forKey: .metadata)
		repliedTo = try container?.decodeIfPresent(Int.self, forKey: .repliedTo)
		systemMetadata = try container?.decodeIfPresent(String.self, forKey: .systemMetadata)
		subjectId = try container?.decodeIfPresent(Int.self, forKey: .subjectId)
		typeCode = try container?.decodeIfPresent(String.self, forKey: .typeCode)
		messageType = try container?.decodeIfPresent(Int.self, forKey: .messageType)
		isCreateThreadAndSendMessage = try container?.decodeIfPresent(Bool.self, forKey: .isCreateThreadAndSendMessage) ?? false
		if let uniqueId = try container?.decodeIfPresent(String.self, forKey: .uniqueId){
			if let data = uniqueId.data(using: .utf8), let uniqueIds = try? JSONDecoder().decode([String].self, from: data){
				self.uniqueIds = uniqueIds
			}else{
				self.uniqueId = uniqueId
			}
		}
		if chatMessageVOType == ChatMessageVOTypes.DELETE_MESSAGE.intValue(){
			if let content = content {
				let jsonContent = JSON(stringLiteral: content)
				if let x = jsonContent["content"]["ids"].arrayObject , x.count <= 1 {
					self.uniqueId = ""
				}else{
					self.uniqueId = ""
				}
			}else if chatMessageVOType == ChatMessageVOTypes.PING.intValue(){
				uniqueId = ""
			}
			
		}
	}
	
	public init(chatMessageVOType				: Int,
				token						: String,
				content						: String? = nil,
				messageType					: Int? 	  = nil,
				metadata					: String?  = nil,
				repliedTo					: Int?     = nil,
				systemMetadata				: String? = nil,
				subjectId					: Int? = nil,
				tokenIssuer					: Int? = nil,
				typeCode					: String? = nil,
				uniqueId					: String? = nil,
				uniqueIds					: [String]? = nil,
				isCreateThreadAndSendMessage: Bool = false) {
		
		self.chatMessageVOType 			= chatMessageVOType
		self.token 						= token
		self.content 						= content
		self.messageType 					= messageType
		self.metadata 					= metadata
		self.repliedTo 					= repliedTo
		self.systemMetadata 				= systemMetadata
		self.subjectId 					= subjectId
		self.tokenIssuer 					= tokenIssuer
		self.typeCode 					= typeCode
		self.uniqueId 					= uniqueId
		self.uniqueIds 					= uniqueIds
		self.isCreateThreadAndSendMessage 	= isCreateThreadAndSendMessage
		
		
		// FIXME: i think below method generateUUID not working properly
		func generateUUID() -> String {
			return ""
		}
		
		if (uniqueId == nil && chatMessageVOType == ChatMessageVOTypes.DELETE_MESSAGE.intValue()) {
			if let json = content?.convertToJSON() {
				if(json["ids"].arrayObject?.count ?? 0) <= 1{
					self.uniqueId = generateUUID()
				}else{
					self.uniqueId = generateUUID()
				}
			}
		} else if (chatMessageVOType == ChatMessageVOTypes.PING.intValue()) {
			self.uniqueId = generateUUID()
		}
	}
	
}
