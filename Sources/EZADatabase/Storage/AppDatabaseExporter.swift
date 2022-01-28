//
//  AppDatabaseExporter.swift
//  TempProject
//
//  Created Eugeniy Zaychenko on 11/12/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file is generated by custom SKELETON Xcode template.
//

import Foundation
import PromiseKit

public enum DatabaseReaderComputationOperation: String {
    
    case min = "min:"
    case max = "max:"
    case average = "average:"
}

public protocol DatabaseReaderProtocol {
    
    associatedtype ReadType
    
    /// Efficiently exports Updatable object from the database.
    ///
    /// - Parameters:
    ///   - type: Type of object
    ///   - predicate: predicate for searching
    /// - Returns: A promise with object when the work is finished
    ///
    @discardableResult
    static func exportRemote(_ type: ReadType.Type, predicate: NSPredicate?, sort: [NSSortDescriptor]?) -> Promise<ReadType?>
    
    /// Efficiently exports Updatable object from the database.
    ///
    /// - Parameters:
    ///   - predicate: predicate for searching
    /// - Returns: A single object
    ///
    @discardableResult
    static func exportRemoteSingle(predicate: NSPredicate?, sort: [NSSortDescriptor]?) -> ReadType?
    
    /// Efficiently exports Updatable objects list from the database.
    ///
    /// - Parameters:
    ///   - type: Type of objects
    ///   - predicate: predicate for searching
    ///   - sort: sort descriptors for ordering
    /// - Returns: A promise with a list of objects when the work is finished
    ///
    @discardableResult
    static func exportRemoteList(_ type: ReadType.Type, predicate: NSPredicate?, sort: [NSSortDescriptor]?)  -> Promise<[ReadType]?>
    
    @discardableResult
    static func compute(_ type: ReadType.Type, operation: DatabaseReaderComputationOperation, keyPath: String, predicate: NSPredicate) -> Int?
    
    static func fetchedResultsProvider(_ type: ReadType.Type,
                                       mainPredicate: NSPredicate,
                                       optionalPredicates: [NSPredicate]?,
                                       sorting sortDescriptors: [NSSortDescriptor],
                                       sectionName: String?,
                                       fetchLimit: Int?) -> FetchedResultsProviderInterface
}

public extension DatabaseReaderProtocol {
    
    static func exportRemoteSingle(predicate: NSPredicate?, sort: [NSSortDescriptor]? = nil) -> ReadType? {
        return exportRemoteSingle(predicate: predicate, sort: sort)
    }
    
    static func exportRemote(_ type: ReadType.Type, predicate: NSPredicate?, sort: [NSSortDescriptor]? = nil) -> Promise<ReadType?> {
        return exportRemote(type, predicate: predicate, sort: sort)
    }
}


public class AppDatabaseExporter<ExportedType: CoreDataCompatible>: DatabaseReaderProtocol {

    typealias Reader = CoreDataReader
    public typealias ReadType = ExportedType
    
    public static func exportRemoteSingle(predicate: NSPredicate?, sort: [NSSortDescriptor]?) -> ReadType? {
        return Reader<ReadType>.exportRemoteSingle(predicate: predicate, sort: sort)
    }
    
    public static func exportRemote(_ type: ReadType.Type, predicate: NSPredicate?, sort: [NSSortDescriptor]?) -> Promise<ReadType?> {
        return Reader<ReadType>.exportRemote(type, predicate: predicate, sort: sort)
    }
    
    public static func exportRemoteList(_ type: ReadType.Type, predicate: NSPredicate?, sort: [NSSortDescriptor]?) -> Promise<[ReadType]?> {
        return Reader<ReadType>.exportRemoteList(type, predicate: predicate, sort: sort)
    }
    
    public static func fetchedResultsProvider(_ type: ReadType.Type,
                                       mainPredicate: NSPredicate,
                                       optionalPredicates: [NSPredicate]?,
                                       sorting sortDescriptors: [NSSortDescriptor],
                                       sectionName: String?,
                                       fetchLimit: Int?) -> FetchedResultsProviderInterface
    {
        return Reader<ReadType>.fetchedResultsProvider(type,
                                                       mainPredicate: mainPredicate,
                                                       optionalPredicates: optionalPredicates,
                                                       sorting: sortDescriptors,
                                                       sectionName: sectionName,
                                                       fetchLimit: fetchLimit)
    }
    
    public static func compute(_ type: ReadType.Type, operation: DatabaseReaderComputationOperation, keyPath: String, predicate: NSPredicate) -> Int? {
        return Reader<ReadType>.compute(type, operation: operation, keyPath: keyPath, predicate: predicate)
    }
}
