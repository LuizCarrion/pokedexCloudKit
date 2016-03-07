//
//  Pokemon.swift
//  TrabalhoPokemon
//
//  Created by Luiz Carrion on 2/29/16.
//  Copyright © 2016 LuizCarrion. All rights reserved.
//

import Foundation
import SwiftyJSON

class Pokemon {
    
    let number: Int!
    let name: String!
    let icon: String!
    let image: String!
    let level: Int!
    let type: (type1: String!, type2: String!)
    let status: Status
    var skills: Array<Skill> = []
    
    init(json:JSON){
        self.number = json["number"].intValue
        self.name = json["name"].stringValue
        self.icon = json["icon"].stringValue
        self.image = json["image"].stringValue
        self.level = json["level"].intValue
        self.type = (type1: json["type1"].stringValue, type2: json["type2"].stringValue)
        self.status = Status(json: json["status"])
        
        let arraySkillsJSON: Array<JSON> = json["skills"].arrayValue
        
        for skill in arraySkillsJSON{
            skills.append(Skill(json: skill))
        }
    }
}