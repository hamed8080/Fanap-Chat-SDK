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
}
