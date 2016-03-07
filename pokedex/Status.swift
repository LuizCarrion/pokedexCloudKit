//
//  Status.swift
//  TrabalhoPokemon
//
//  Created by Luiz Carrion on 2/29/16.
//  Copyright © 2016 LuizCarrion. All rights reserved.
//

import Foundation
import SwiftyJSON

class Status {
    let health: Int!
    let attack: Int!
    let defense: Int!
    let spAttack: Int!
    let spDefense: Int!
    let speed: Int!
    
    
    init(json:JSON){
        self.health = json["health"].intValue
        self.attack = json["attack"].intValue
        self.defense = json["defense"].intValue
        self.spAttack = json["spAttack"].intValue
        self.spDefense = json["spDefense"].intValue
        self.speed = json["speed"].intValue
    }
}