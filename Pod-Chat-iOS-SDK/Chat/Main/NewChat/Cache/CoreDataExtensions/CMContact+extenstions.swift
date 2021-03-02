//
//  CMContact+extenstions.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/2/21.
//

import Foundation

extension CMContact{
    
    public static let crud = CoreDataCrud<CMContact>(entityName: "CMContact")
    
    public func getCodable() -> Contact{
            return Contact(blocked  : blocked as? Bool,
                    cellphoneNumber : cellphoneNumber,
                    email           : email,
                    firstName       : firstName,
                    hasUser         : (hasUser as? Bool) ?? false,
                    id              : id as? Int,
                    image           : image,
                    lastName        : lastName,
                    linkedUser      : linkedUser?.getCodable(),
                    notSeenDuration : notSeenDuration as? Int,
                    timeStamp       : time as? UInt,
                    userId          : userId as? Int)
    }
    
    class func convertContactToCM(contact:Contact  ,entity:CMContact? = nil) -> CMContact{
        let model             = entity ?? CMContact()
        model.blocked         = contact.blocked as NSNumber?
        model.cellphoneNumber = contact.cellphoneNumber
        model.email           = contact.email
        model.firstName       = contact.firstName
        model.lastName        = contact.lastName
        model.hasUser         = contact.hasUser as NSNumber?
        model.id              = contact.id as NSNumber?
        model.image           = contact.image
        if let linkedUser = contact.linkedUser{
            CMLinkedUser.insertOrUpdate(linkedUser: linkedUser,resultEntity:{ linkedUserEntity in
                model.linkedUser = linkedUserEntity
            })
        }
        model.notSeenDuration = contact.notSeenDuration as NSNumber?
        model.time            = contact.timeStamp as NSNumber?
        model.userId          = contact.userId as NSNumber?
        return model
    }
    
    public class func deleteContacts(byTimeStamp timeStamp: Int) {
        let currentTime = Int(Date().timeIntervalSince1970)
        let predicate = NSPredicate(format: "time <= %i", Int(currentTime - timeStamp))
        CMContact.crud.deleteWith(predicate: predicate)
    }
    
    public class func insertOrUpdate(contacts:[Contact]){
        contacts.forEach { contact in
            if let findedEntity = CMContact.crud.find(keyWithFromat: "id == %i", value: contact.id!){
                _ = convertContactToCM(contact: contact, entity: findedEntity)
            }else{
                CMContact.crud.insert { cmContactEntity in
                    _ = convertContactToCM(contact: contact, entity: cmContactEntity)
                }
            }
        }
        CMContact.crud.save()
    }
}
