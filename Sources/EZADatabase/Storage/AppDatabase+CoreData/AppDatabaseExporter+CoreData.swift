//
//  AppDatabaseExporter+CoreData.swift
//  TempProject
//
//  Created Eugeniy Zaychenko on 11/12/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file is generated by custom SKELETON Xcode template.
//

import Foundation
import CoreData
import PromiseKit

class CoreDataReader<ExportedType> { }

extension CoreDataReader: DatabaseReaderProtocol where ExportedType: CoreDataCompatible {
    
    typealias ReadType = ExportedType
    
    static func exportRemoteSingle(predicate: NSPredicate?, sort: [NSSortDescriptor]?) -> ReadType? {
        
        let controller = CoreDataStorageController.shared
        let objects: [ReadType.ManagedType]? = controller.list(predicate: predicate,
                                                                sortDescriptors: sort,
                                                                fetchLimit: 1)
        
        return objects?.first?.getObject() as? ReadType
    }
    
    static func exportRemote(predicate: NSPredicate?, sort: [NSSortDescriptor]?) -> Promise<ReadType?> {
        
        let controller = CoreDataStorageController.shared
        
        return Promise<ReadType?> { seal in
            
            let completion: (([ReadType.ManagedType]?) -> Void) = { result in
                
                let object = result?.first?.getObject() as? ReadType
                DispatchQueue.main.async {
                    seal.fulfill(object)
                }
            }
            controller.asyncList(predicate: predicate,
                                  sortDescriptors: sort,
                                  fetchLimit: 1,
                                  completion: completion)
            
        }
    }
    
    static func exportRemoteList(predicate: NSPredicate?, sort: [NSSortDescriptor]?) -> Promise<[ReadType]?> {
        
        let controller = CoreDataStorageController.shared
        
        return Promise<[ReadType]?> { seal in
            
            let completion: (([ReadType.ManagedType]?) -> Void) = { result in
                
                let mapped = result?.compactMap { obj in
                    return obj.getObject() as? ReadType
                }
                DispatchQueue.main.async {
                    seal.fulfill(mapped)
                }
            }
            
            controller.asyncList(predicate: predicate,
                                  sortDescriptors: nil,
                                  fetchLimit: nil,
                                  completion: completion)
        }
    }
    
    static func fetchedResultsProvider(_ type: ReadType.Type,
                                       mainPredicate: NSPredicate,
                                       optionalPredicates: [NSPredicate]?,
                                       sorting sortDescriptors: [NSSortDescriptor],
                                       sectionName: String?,
                                       fetchLimit: Int?) -> FetchedResultsProviderInterface
    {
        
        let controller = CoreDataStorageController.shared
        
        return controller.fetchedResultsProvider(type,
                                                 mainPredicate: mainPredicate,
                                                 optionalPredicates: optionalPredicates,
                                                 sorting: sortDescriptors,
                                                 sectionName: sectionName,
                                                 fetchLimit: fetchLimit)
    }
    
    static func compute(_ type: ReadType.Type, operation: DatabaseReaderComputationOperation, keyPath: String, predicate: NSPredicate) -> Int? {
        
        let controller = CoreDataStorageController.shared
        
        return controller.compute(ReadType.ManagedType.self, operation: operation.rawValue, keyPath: keyPath, predicate: predicate)
    }
}
