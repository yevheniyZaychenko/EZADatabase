//
//  NSPredicate+ext.swift
//  Altos-app
//
//  Created by Eugeniy Zaychenko on 11/15/21.
//

import Foundation

public extension NSPredicate {
    
    enum CompoundType {
        case and
        case or
    }
    
    convenience init(key: String, value: Any) {
        let arg = "\(value)"
        self.init(format: "\(key) == %@", arg)
    }
    
    convenience init(id: Any) {
        let arg = "\(id)"
        self.init(format: "id == %@", arg)
    }
    
    static func dateRangePredicate(from: Date, to: Date) -> NSPredicate {
        
        let fromPredicate = NSPredicate(format: "date >= %@", from as CVarArg)
        let toPredicate = NSPredicate(format: "date < %@", to as CVarArg)
        let datePredicate = fromPredicate.appending(predicate: toPredicate, type: .and)
        
        return datePredicate
    }
    
    func appending(predicate: NSPredicate?, type: CompoundType) -> NSPredicate {
        
        guard let toAppend = predicate else { return self }
        
        switch type {
        case .and: return NSCompoundPredicate(andPredicateWithSubpredicates: [self, toAppend])
        case .or: return NSCompoundPredicate(orPredicateWithSubpredicates: [self, toAppend])
        }
    }
}
