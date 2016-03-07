//
//  Skill.swift
//  TrabalhoPokemon
//
//  Created by Luiz Carrion on 2/29/16.
//  Copyright © 2016 LuizCarrion. All rights reserved.
//

import Foundation
import SwiftyJSON

class Skill {
    
    let name: String!
    let type: String!
    let damageCategory: String!
    let power: Int!
    let accuracy: Int!
    let powerPoint: Int!
    
    
    init(json:JSON){
        self.name = json["name"].stringValue
        self.type = json["type"].stringValue
        self.damageCategory = json["damageCategory"].stringValue
        self.power = json["power"].intValue
        self.accuracy = json["accuracy"].intValue
        self.powerPoint = json["powerPoint"].intValue
    }



}
