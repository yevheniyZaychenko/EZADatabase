//
//  NSPredicate+ext.swift
//  Altos-app
//
//  Created by Eugeniy Zaychenko on 11/15/21.
//

import Foundation

extension NSPredicate {
    
    enum CompoundType {
        case and
        case or
    }
    
    convenience init(key: String, value: Any) {
        self.init(format: "%@ == %@", key, value as! CVarArg)
    }
    
    convenience init(value: Any) {
        
        self.init(format: "id == %@", value as! CVarArg)
    }
    
    static func dateRangePredicate(from: Date, to: Date) -> NSPredicate {
        
        let fromPredicate = NSPredicate(format: "date >= %@", from as CVarArg)
        let toPredicate = NSPredicate(format: "date < %@", to as CVarArg)
        let datePredicate = fromPredicate.appending(predicate: toPredicate, type: .and)
        
        return datePredicate
    }
    
    func appending(predicate: NSPredicate, type: CompoundType) -> NSPredicate {
        
        switch type {
        case .and: return NSCompoundPredicate(andPredicateWithSubpredicates: [self, predicate])
        case .or: return NSCompoundPredicate(orPredicateWithSubpredicates: [self, predicate])
        }
    }
}
