//
//  ObservableString.swift
//  Investr
//
//  Created by Michael Litman on 10/2/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit

class ObservableString: NSObject
{
    var observers = NSMutableArray()
    
    var value = ""{willSet(newValue){
        print("About to set")
        for observer in observers
        {
            (observer as! CurrentGameVC).observableStringUpdate(newValue)
        }

        }
        didSet(newValue){
            print("Did set")
            //let the observers know
                    }
    }
    
    func updateValue(value: String)
    {
        self.value = value
    }
    
    init(value: String)
    {
        self.value = value
    }
    
    func addObserver(observer: AnyObject)
    {
        self.observers.addObject(observer)
    }
}
