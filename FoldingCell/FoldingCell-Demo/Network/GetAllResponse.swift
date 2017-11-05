//
//  GetAllResponse.swift
//  FoldingCell-Demo
//
//  Created by Ruiji Wang on 04/11/2017.
//  Copyright © 2017 Alex K. All rights reserved.
//

import ObjectMapper

class GetAllResponse: Mappable {
    
    var EmotionalRange: Double?
    var Openness: Double?
    var Extraversion: Double?
    var Agreeableness: Double?
    var Conscientiousness: Double?
    
    var Movies: [String]?
    var Books: [String]?
    var Musics: [String]?
    
    var SelfEnhancement: Double?
    var OpennessToChange: Double?
    var SelfTranscendence: Double?
    var Hedonism: Double?
    var Conservation: Double?
    
    var Items: [ShoppingItem]?
    var shoppingListName: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        EmotionalRange <- map["pi.personality.Emotional range"]
        Openness <- map["pi.personality.Openness"]
        Extraversion <- map["pi.personality.Extraversion"]
        Agreeableness <- map["pi.personality.Agreeableness"]
        Conscientiousness <- map["pi.personality.Conscientiousness"]
        
        Movies <- map["pi.movies"]
        Books <- map["pi.books"]
        Musics <- map["pi.musics"]
        
        SelfEnhancement <- map["pi.val.Self-enhancement"]
        OpennessToChange <- map["pi.val.Openness to change"]
        SelfTranscendence <- map["pi.val.Self-transcendence"]
        Hedonism <- map["pi.val.Hedonism"]
        Conservation <- map["pi.val.Conservation"]
        
        Items <- map["goods.items"]
        shoppingListName <- map["goods.name"]
    }
    
}
