//
//  CasheFactory.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/2/21.
//

import Foundation
class CacheFactory {
    
    enum ReadCacheType {
        case GET_CASHED_CONTACTS(_ req:ContactsRequest?)
        case GET_THREADS(_ req:ThreadsRequest)
        case GET_BLOCKED_USERS
        case GET_THREAD_PARTICIPANTS(_ req:ThreadParticipantsRequest)
        case CUREENT_USER_ROLES(_ threadId:Int)
        case USER_INFO
        case ALL_UNREAD_COUNT
        case MENTIONS
        case GET_HISTORY(_ req: NewGetHistoryRequest)
        case GET_TEXT_NOT_SENT_REQUESTS(_ threadId:Int)
        case EDIT_MESSAGE_REQUESTS(_ threadId:Int)
        case FORWARD_MESSAGE_REQUESTS(_ threadId:Int)
    }
    
    enum WriteCacheType {
        case CASHE_CONTACTS(_ contacts:[Contact])
        case THREADS(_ threads:[Conversation])
        case GET_BLOCKED_USERS
        case PARTICIPANTS(_ participants:[Participant]? , _ threadId:Int?)
        case REMOVE_PARTICIPANTS(participants:[Participant]? , threadId:Int?)
        case LEAVE_THREAD(_ conversation:Conversation)
        case CURRENT_USER_ROLES(_ roles:[Roles] , _ threadId:Int?)
        case USER_INFO(_ user:User)
        case PIN_MESSAGE(_ pinMessage:PinUnpinMessage, _ threadId:Int?)
        case UNPIN_MESSAGE(_ unpinMessage:PinUnpinMessage, _ threadId:Int?)
        case CLEAR_ALL_HISTORY(_ threadId:Int)
        case DELETE_MESSAGE(_ threadId:Int , messageId:Int)
        case DELETE_MESSAGES(_ threadId:Int , messageIds:[Int])
        case SEND_TXET_MESSAGE_QUEUE(_ req:NewSendTextMessageRequest)
        case DELETE_SEND_TXET_MESSAGE_QUEUE(_ uniqueId:String)
        case MESSAGE(_ message:Message)
        case EDIT_MESSAGE_QUEUE(_ req : NewEditMessageRequest)
        case DELETE_EDIT_MESSAGE_QUEUE(_ message:Message)
        case FORWARD_MESSAGE_QUEUE(_:NewForwardMessageRequest)
        case DELETE_FORWARD_MESSAGE_QUEUE(_ uniqueId:String)
    }
    
    class func get(useCache: Bool = false , cacheType: ReadCacheType , completion: ((ChatResponse)->())? = nil){
        if Chat.sharedInstance.createChatModel?.enableCache == true && useCache == true{
            switch cacheType {
            case .GET_CASHED_CONTACTS(_ :let req):
                let contacts = CMContact.getContacts(req: req)
                completion?(.init( cacheResponse: contacts))
                break
            case .GET_BLOCKED_USERS:
                //completion?(.init(result: nil, cacheResponse: CMBlocked.crud.getAll().map{$0.convertCMObjectToObject()}, error: nil))
                break
            case .GET_THREADS(_ : let req ):
                let threads = CMConversation.getThreads(req: req)
                completion?(.init(cacheResponse: threads))
                break
            case .GET_THREAD_PARTICIPANTS(_ : let req):
                let cmParticipants = CMParticipant.crud.fetchWithOffset(count: req.count, offset: req.offset, predicate: .init(format: "threadId == %i", req.threadId))
                let paricipants = cmParticipants.map{$0.getCodable()}
                completion?(.init(cacheResponse: paricipants))
                break
            case .CUREENT_USER_ROLES(_ : let threadId):
                let roles = CMCurrentUserRoles.crud.fetchWith(NSPredicate(format: "threadId == %i" , threadId))
                completion?(.init(cacheResponse: roles?.first?.getCodable()))
                break
            case .USER_INFO:
                let user = CMUser.crud.getAll().first?.getCodable()
                completion?(.init(cacheResponse: user))
                break
            case .ALL_UNREAD_COUNT:
                let allUnreadCount = CMConversation.crud.getAll().compactMap{ $0.unreadCount as? Int ?? 0 }.reduce(0, +)
                completion?(.init(cacheResponse: allUnreadCount))
                break
            case .MENTIONS:
                let mentions = CMMessage.crud.fetchWith(NSPredicate(format: "mentioned == %@", NSNumber(value: true)))?.map{$0.getCodable()}
                completion?(.init(cacheResponse: mentions))
                break
            case .GET_HISTORY(_ : let req):
                let fetchRequest = CMMessage.fetchRequestWithGetHistoryRequest(req: req)
                let messages = CMMessage.crud.fetchWith(fetchRequest)?.map{$0.getCodable()}
                completion?(.init(cacheResponse: messages))
                break
            case .GET_TEXT_NOT_SENT_REQUESTS(_: let threadId):
                let requests = QueueOfTextMessages.crud.fetchWith(NSPredicate(format: "threadId == %i" , threadId))?.compactMap{$0.getCodable()}
                completion?(.init(cacheResponse: requests))
                break
            case .EDIT_MESSAGE_REQUESTS(_ : let threadId):
                let requests = QueueOfEditMessages.crud.fetchWith(NSPredicate(format: "threadId == %i" , threadId))?.compactMap{$0.getCodable()}
                completion?(.init(cacheResponse: requests))
                break
            case .FORWARD_MESSAGE_REQUESTS(_: let threadId):
                let requests = QueueOfForwardMessages.crud.fetchWith(NSPredicate(format: "threadId == %i" , threadId))?.compactMap{$0.getCodable()}
                completion?(.init(cacheResponse: requests))
                break
            }
        }
    }
    
    class func write(cacheType: WriteCacheType){
        if Chat.sharedInstance.createChatModel?.enableCache == true{
            switch cacheType {
            case .CASHE_CONTACTS(contacts: let contacts):
                CMContact.insertOrUpdate(contacts: contacts)
                break
            case .GET_BLOCKED_USERS:
                break
            case .THREADS(_ : let threads):
                CMConversation.insertOrUpdate(conversations: threads)
                break
            case .PARTICIPANTS(_ : let participants , _ : let threadId):
                CMParticipant.insertOrUpdateParicipants(participants: participants, threadId: threadId)
                break
            case .REMOVE_PARTICIPANTS(_: let participants, _: let threadId):
                CMParticipant.deleteParticipants(participants: participants , threadId: threadId)
                break
            case .LEAVE_THREAD(_ : let conversation):
                if let threadId = conversation.id{
                    CMParticipant.crud.deleteWith(predicate: NSPredicate(format: "threadId == %i" , threadId))
                    CMConversation.crud.deleteWith(predicate: NSPredicate(format: "threadId == %i" , threadId))
                }
                break
                
            case .CURRENT_USER_ROLES(_ :let roles, _ :let threadId):
                if let threadId = threadId{
                    CMCurrentUserRoles.insertOrUpdate(roles: roles, threadId: threadId)
                }
                break
            case .USER_INFO(_ : let user):
                CMUser.insertOrUpdate(user: user, resultEntity: nil)
                break
            case .PIN_MESSAGE(_ : let pinMessage , _: let threadId):
                CMPinMessage.pinMessage(pinMessage: pinMessage , threadId: threadId)
                break
            case .UNPIN_MESSAGE(_ : let unpinMessage, _: let threadId):
                CMPinMessage.unpinMessage(pinMessage: unpinMessage , threadId: threadId)
                break
            case .CLEAR_ALL_HISTORY(_: let threadId):
                CMMessage.crud.deleteWith(predicate: NSPredicate(format:"threadId == %i" , threadId))
                break
            case .DELETE_MESSAGE(_ :let threadId , _ :let messageId):
                CMMessage.crud.deleteWith(predicate: NSPredicate(format:"threadId == %i AND id == %i" , threadId , messageId))
                break
            case .DELETE_MESSAGES(_ :let threadId , _ :let messageIds):
                CMMessage.crud.fetchWith(NSPredicate(format:"threadId == %i AND id IN %@" , threadId , messageIds))?.forEach({ entity in
                    CMMessage.crud.delete(entity: entity)
                })
                break
            case .SEND_TXET_MESSAGE_QUEUE(_ :let req):
                QueueOfTextMessages.insert(request: req)
                break
            case .DELETE_SEND_TXET_MESSAGE_QUEUE(_ :let uniqueId):
                QueueOfTextMessages.crud.deleteWith(predicate: NSPredicate(format: "uniqueId == %@", uniqueId))
                break
            case .MESSAGE(_ :let message):
                CMMessage.insertOrUpdate(message: message, threadId: message.threadId)
                break
            case .EDIT_MESSAGE_QUEUE(_ :let req):
                QueueOfEditMessages.insert(request: req)
                break
            case .DELETE_EDIT_MESSAGE_QUEUE(_ : let message):
                guard let messageId = message.id ,  let threadId = message.conversation?.id else{return}
                QueueOfEditMessages.crud.deleteWith(predicate: NSPredicate(format: "messageId == %i AND threadId == %i", messageId , threadId))
                break
            case .FORWARD_MESSAGE_QUEUE(_ : let req):
                QueueOfForwardMessages.insert(request: req)
                break
            case .DELETE_FORWARD_MESSAGE_QUEUE(_ : let uniqueId):
                QueueOfForwardMessages.crud.deleteWith(predicate: NSPredicate(format: "uniqueId == %@", uniqueId))
                break
            }
        }
    }
}
