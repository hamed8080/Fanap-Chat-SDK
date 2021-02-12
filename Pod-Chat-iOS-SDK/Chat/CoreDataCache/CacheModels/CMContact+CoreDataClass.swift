//
//  CMContact+CoreDataClass.swift
//  FanapPodChatSDK
//
//  Created by Mahyar Zhiani on 11/1/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//
//

import Foundation
import CoreData

public class CMContact:NSManagedObject {
    
    static let crud = CoreDataCrud<CMContact>(entityName: "CMContact")
    
    public func getCodable() -> Contact{
            return Contact(blocked  : blocked as? Bool,
                    cellphoneNumber : cellphoneNumber,
                    email           : email,
                    firstName       : firstName,
                    hasUser         : (hasUser as? Bool) ?? false,
                    id              : id as? Int,
                    image           : image,
                    lastName        : lastName,
                    linkedUser      : linkedUser?.convertCMObjectToObject(),
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
            model.linkedUser      = CMLinkedUser.convertContactToCM(linkedUser: linkedUser)
        }
        model.notSeenDuration = contact.notSeenDuration as NSNumber?
        model.time            = contact.timeStamp as NSNumber?
        model.userId          = contact.userId as NSNumber?
        return model
    }
    
    func updateObject(with contact: Contact) {
        if let blocked = contact.blocked as NSNumber? {
            self.blocked = blocked
        }
        if let cellphoneNumber = contact.cellphoneNumber {
            self.cellphoneNumber = cellphoneNumber
        }
        if let email = contact.email {
            self.email = email
        }
        if let firstName = contact.firstName {
            self.firstName = firstName
        }
        if let hasUser = contact.hasUser as NSNumber? {
            self.hasUser = hasUser
        }
        if let id = contact.id as NSNumber? {
            self.id = id
        }
        if let image = contact.image {
            self.image = image
        }
        if let lastName = contact.lastName {
            self.lastName = lastName
        }
        if let notSeenDuration = contact.notSeenDuration as NSNumber? {
            self.notSeenDuration = notSeenDuration
        }
        if let userId = contact.userId as NSNumber? {
            self.userId = userId
        }
        
        self.time = Int(Date().timeIntervalSince1970) as NSNumber?
    }
    
    // MARK: - retrieve Contacts:
    /// Retrieve Contacts:
    /// retrieve Contacts from cacheDB and return the result to the caller
    ///
    /// - first, it will fetch the Objects from CoreData (Cache DB).
    /// - then based on the client request, it will find the objects that the client wants to get,
    /// and then it will return it as 'GetContactsModel' to the client.
    /// - (if it found any object, it will return that, otherwise it will return nil. (means cache has no data(CMContact object) on itself))
    ///
    /// Inputs:
    /// ther is no need to send any params to this method
    ///
    /// Outputs:
    /// It returns "GetContactsModel" model as output
    ///
    /// - parameters:
    ///     - ascending:        on what order do you want to get the response? (Bool)
    ///     - cellphoneNumber:  if you want to search Contact with specific cellphone number, you should fill this parameter (String?)
    ///     - count:            how many Contacts do you spect to return (Int)
    ///     - email:            if you want to search Contact with specific email address, you should fill this parameter (String?)
    ///     - firstName:        if you want to search Contact with specific first name, you should fill this parameter (String?)    (deprecated)
    ///     - id:               if you want to search Contact with specific contact id, you should fill this parameter (Int?)
    ///     - lastName:         if you want to search Contact with specific last name, you should fill this parameter (String?)    (deprecated)
    ///     - offset:           from what offset do you want to get the Cache response (Int)
    ///     - search:           if you want to search some term on every content of the Contact (like as: cellphoneNumber, email, firstName, lastName), you should fill this parameter (String?)
    ///     - timeStamp:        the only way to delete contact, is to check if there is a long time that some contact is not updated, we will delete it. this it the timeStamp to check (Int)
    ///     - uniqueId:         this f**king parameter is not related to the Object! this related to the request! anyway just pass it as nil! (String?)
    ///
    /// - Returns:
    ///     GetContactsModel?
    ///
    public class func retrieveContacts(ascending:Bool, contactsRequest:GetContactsRequest , timeStamp:Int , uniqueId:String? = nil) -> GetContactsModel? {
        /*
         * first of all, try to delete all the Contacts that has not been updated for a long time (check it from timeStamp)
         * after that, we will fetch on the Cache
         */
        deleteContacts(byTimeStamp: timeStamp)
        
        
        /*
         *  -> if 'id' or 'uniqueId' property have been set:
         *      we only have to predicate of them and answer exact response
         *
         *  -> in the other situation:
         *      -> make this properties AND together: 'firstName', 'lastName', 'cellphoneNumber', 'email'
         *      -> then with the response of the AND, make OR with 'search' property
         *
         *  -> if { 'id' }
         *  -> else { 'uniqueId' }
         *  -> else { ('cellphoneNumber' && 'firstName' && 'lastName' && 'email') || ('search') }
         *
         *  -> then we create the output model and return it.
         *
         */
        let fetchRequest = CMContact.crud.fetchRequest()
        
        let theOnlyPredicate: NSPredicate?
        if let theId = contactsRequest.id {
            theOnlyPredicate = NSPredicate(format: "id == %i", theId)
            fetchRequest.predicate = theOnlyPredicate
        } else if let theUniqueId = uniqueId {
            theOnlyPredicate = NSPredicate(format: "uniqueId == %@", theUniqueId)
            fetchRequest.predicate = theOnlyPredicate
        } else {
            
            var andPredicateArr = [NSPredicate]()
            if let theCellphoneNumber = contactsRequest.cellphoneNumber  , theCellphoneNumber != "" {
                    let theCellphoneNumberPredicate = NSPredicate(format: "cellphoneNumber CONTAINS[cd] %@", theCellphoneNumber)
                    andPredicateArr.append(theCellphoneNumberPredicate)
            }
            if let theEmail = contactsRequest.email  , theEmail != "" {
                let theEmailPredicate = NSPredicate(format: "email CONTAINS[cd] %@", theEmail)
                andPredicateArr.append(theEmailPredicate)
            }
            
            var orPredicatArray = [NSPredicate]()
            
            if (andPredicateArr.count > 0) {
                let andPredicateCompound = NSCompoundPredicate(type: .and, subpredicates: andPredicateArr)
                orPredicatArray.append(andPredicateCompound)
            }
            
            if let query = contactsRequest.query , query != "" {
                let theSearchPredicate = NSPredicate(format: "cellphoneNumber CONTAINS[cd] %@ OR email CONTAINS[cd] %@ OR firstName CONTAINS[cd] %@ OR lastName CONTAINS[cd] %@", query, query, query, query)
                orPredicatArray.append(theSearchPredicate)
            }
            
            if (orPredicatArray.count > 0) {
                let predicateCompound = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: orPredicatArray)
                fetchRequest.predicate = predicateCompound
            }
        }
        fetchRequest.sortDescriptors = [.init(key: "firstName", ascending: ascending) , .init(key: "lastName", ascending: ascending)]
        if let result = CMContact.crud.fetchWith(fetchRequest) {
            
            var insideCount = 0
            var cmContactObjectArr = [CMContact]()
            
            for (index, item) in result.enumerated() {
                if (index >= contactsRequest.offset) && (insideCount < contactsRequest.size) {
                    cmContactObjectArr.append(item)
                    insideCount += 1
                }
            }
            
            var contactsArr = [Contact]()
            for item in cmContactObjectArr {
                contactsArr.append(item.getCodable())
            }
            
            let getContactModelResponse = GetContactsModel(contactsObject:  contactsArr,
                                                           contentCount:    result.count,
                                                           count:           contactsRequest.size,
                                                           offset:          contactsRequest.offset,
                                                           hasError:        false,
                                                           errorMessage:    "",
                                                           errorCode:       0)
            
            return getContactModelResponse
            
        } else {
            return nil
        }
    }
    
    /// Delete Contacts by TimeStamp:
    /// by calling this method, it will delete the CMContact that had not been updated for specific timeStamp.
    ///
    /// - get the current time
    /// - decrease it with the timeStamp input and create a new time
    /// - fetch CMContact Entity where object that has lesser time value than this new time that we generated
    /// - loop through the result and get the object Ids
    /// - if there was more than 1 value of objectIds,
    /// - send the objectIds to the 'deleteContact(withContactIds: [Int])' to delete these contacts
    ///
    /// Inputs:
    /// it gets the timeStamp as "Int" to delete Contacts that has not been updated for this amount of time
    ///
    /// Outputs:
    /// it returns no output
    ///
    /// - parameters:
    ///     - byTimeStamp:  declear the seconds to delete contacts that has not updated for this amount of time. (Int)
    ///
    /// - Returns:
    ///     none
    ///
    public class func deleteContacts(byTimeStamp timeStamp: Int) {
        let currentTime = Int(Date().timeIntervalSince1970)
        let predicate = NSPredicate(format: "time <= %i", Int(currentTime - timeStamp))
        CMContact.crud.deleteWith(predicate: predicate)
    }

}
