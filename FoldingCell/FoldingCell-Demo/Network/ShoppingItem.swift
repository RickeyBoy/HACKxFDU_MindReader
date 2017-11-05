//
//  ShoppingItem.swift
//  FoldingCell-Demo
//
//  Created by Ruiji Wang on 05/11/2017.
//  Copyright © 2017 Alex K. All rights reserved.
//

import ObjectMapper

class ShoppingItem: Mappable {
    
    var imageURL: String?
    var description: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        imageURL <- map["img"]
        description <- map["description"]
    }
    
}

