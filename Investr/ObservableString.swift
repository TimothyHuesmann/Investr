//
//  ObservableString.swift
//  Investr
//
//  Created by Michael Litman on 10/1/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit

class ObservableString: NSObject
{
    typealias WillSet = (currentValue:String?,tobeValue:String?)->()
    typealias DidSet = (oldValue:String?,currentValue:String?)->()
    typealias Observer = (pre:WillSet,post:DidSet)
    
    var observers = Dictionary<String,Observer>()
    
    var stringValue:String? = nil{
        willSet(newValue){
            for (identifier,observer) in observers{
                observer.pre(currentValue: stringValue,tobeValue: newValue)
            }
        }
        didSet{
            for (identifier,observer) in observers{
                observer.post(oldValue: oldValue,currentValue: stringValue)
            }
        }
    }
    
    func addObserver(identifier:String, observer:Observer){
        observers[identifier] = observer
    }
    
    func removeObserver(identifer:String){
        observers.removeValueForKey(identifer)
    }
    
    init(initialValue:String?){
        stringValue = initialValue
    }
}
