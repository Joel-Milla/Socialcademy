//
//  Loadable.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 05/01/24.
//

import Foundation

enum Loadable<Value> {
    case loading
    case error(Error)
    case loaded(Value)
    
    var value: Value? {
        get {
            if case let .loaded(value) = self {
                return value
            }
            return nil
        }
        
        set {
            guard let newValue = newValue else { return }
            self = .loaded(newValue)
        }
    }
}

extension Loadable where Value: RangeReplaceableCollection {
    static var empty: Loadable<Value> { .loaded(Value()) }
}
