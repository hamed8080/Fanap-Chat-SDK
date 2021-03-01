//
//  CodableExtension.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/3/21.
//

import Foundation
extension Encodable{
	
	func convertCodableToString()->String? {
		if let data = try? JSONEncoder().encode(self){
			return String(data: data, encoding: .utf8)
		}else{
			return nil
		}
	}
	
	func asDictionary() throws -> [String: Any] {
		let data = try JSONEncoder().encode(self)
		guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
			throw NSError()
		}
		return dictionary
	}
}
