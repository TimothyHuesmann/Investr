//
//  Stock.swift
//  Investr
//
//  Created by Timothy Huesmann on 10/5/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit

class Stock: NSObject
{
    var name : String!
    var value : Int!
    var change : String!
    
    init(name: String, value: Int)
    {
        self.name = name
        self.value = value
    }

}
