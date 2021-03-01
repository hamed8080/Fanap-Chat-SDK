//
//  CoreDataCrud.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/9/21.
//

import CoreData

open class CoreDataCrud<T:NSFetchRequestResult> {
    
    var entityName:String

    public init(entityName:String) {
        self.entityName = entityName
    }
    
    public func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest(entityName: entityName)
    }
    
    public func getInsertEntity()->T{
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: PSM.shared.context) as! T
    }
    
    public func getFetchRequest() -> NSFetchRequest<T> {
        return NSFetchRequest<T>(entityName: entityName)
    }
    
    public func getAll()->[T]{
        return (try? PSM.shared.context.fetch(getFetchRequest())) ?? []
    }
    
    public func fetchWith(_ fetchRequest:NSFetchRequest<NSFetchRequestResult>)->[T]?{
        return (try? PSM.shared.context.fetch(fetchRequest)) as? [T]
    }
    
    public func fetchWith(_ predicate:NSPredicate)->[T]?{
        let req = fetchRequest()
        req.predicate = predicate
        return (try? PSM.shared.context.fetch(req)) as? [T]
    }
    
    /// - todo: check key equality work with @ for string or int %i float %f and ...
    public func find(keyWithFromat:String, value:CVarArg)->T?{
        let req = getFetchRequest()
        req.predicate = NSPredicate(format: "\(keyWithFromat)", value)
        return (try? PSM.shared.context.fetch(req).first) as? T
    }
    
    public func delete(entity:NSManagedObject){
        PSM.shared.context.delete(entity)
        save()
    }
    
    public func deleteWith(predicate:NSPredicate){
        do{
            let req = fetchRequest()
            req.predicate = predicate
            let deleteReq = NSBatchDeleteRequest(fetchRequest: req)
            try PSM.shared.context.execute(deleteReq)
            save()
        }catch{
            print("error in delete happened\(error)")
        }
        
    }
    
    public func deleteAll(){
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest())
        let _ = try? PSM.shared.context.execute(deleteRequest)
        save()
    }
    
    public func insert(setEntityVariables:(T)->()){
        insertAll(setEntityVariables: setEntityVariables)
    }
    
    /// - warning: Please be sure using entity fetched from insertEntity method otherwise cant save
    public func insertAll(setEntityVariables:(T)->() ){
        PSM.shared.context.performAndWait{
            let entity = getInsertEntity()
            setEntityVariables(entity)
        }
        save()
    }
    
    public func save(){
        PSM.shared.save()
    }
}
