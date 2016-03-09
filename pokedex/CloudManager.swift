//
//  cloudManager.swift
//  pokedex
//
//  Created by Luiz Carrion on 3/8/16.
//  Copyright © 2016 LuizCarrion. All rights reserved.
//

import Foundation
import CloudKit
import SwiftyJSON
let RECORD_TYPE_POKEMON = "Pokemon"
let RECORD_TYPE_STATUS = "Status"
let RECORD_TYPE_SKILLS = "Skills"
public class CloudManager: NSObject {
    
    private let fileName = "pokemons"
    private let privateDb: CKDatabase = CKContainer.defaultContainer().privateCloudDatabase
    private let publicDb: CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
    private var pokemonList = Array<CKRecord>()
    
    private init(singleton: Bool) {
        super.init()
        
        checkDatabase()
    }
    
    class func sharedInstance() -> CloudManager {
        struct Static {
            static var instance: CloudManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = CloudManager(singleton: true)
        }
        
        return Static.instance!
    }
    
    func populateCloudFromJSON() {
        let array = loadFromJSON()
        
        for obj in array{
            let pokemonRecord = CKRecord(recordType: RECORD_TYPE_POKEMON)
            
            pokemonRecord["Name"] = obj.name
            pokemonRecord["Level"] = obj.level
            pokemonRecord["Number"] = obj.number
            pokemonRecord["Type"] = [obj.type.type1, obj.type.type2]
            
            let statusRecord = CKRecord(recordType: RECORD_TYPE_STATUS)
            
            statusRecord["Health"] = obj.status.health
            statusRecord["Attack"] = obj.status.attack
            statusRecord["Defense"] = obj.status.defense
            statusRecord["SpAttack"] = obj.status.spAttack
            statusRecord["SpDefense"] = obj.status.spDefense
            statusRecord["Speed"] = obj.status.speed
            
            publicDb.saveRecord(statusRecord) { savedUser, error in
                if let e = error{
                    print(e.debugDescription)
                }else{
                    print("success")
                }
            }

        
            let statusReference = CKReference(record: statusRecord, action: CKReferenceAction.DeleteSelf)
            
            pokemonRecord["Status"] = statusReference
            
            var skillReferenceArray = Array<CKReference>()
            
            for skill in obj.skills {
                
                let skillRecord = CKRecord(recordType: RECORD_TYPE_SKILLS)
                
                
                skillRecord["Name"] = skill.name
                skillRecord["Type"] = skill.type
                skillRecord["Power"] = skill.power
                skillRecord["Accuracy"] = skill.accuracy
                skillRecord["PowerPoint"] = skill.powerPoint
                skillRecord["DamageCategory"] = skill.damageCategory
                
                
                let skillReference = CKReference(record: skillRecord, action: CKReferenceAction.DeleteSelf)
                
                skillReferenceArray.append(skillReference)
                
                publicDb.saveRecord(skillRecord) { savedUser, error in
                    if let e = error{
                        print(e.debugDescription)
                    }else{
                        print("success")
                    }
                }

                
                
            }
            
            pokemonRecord["Skills"] = skillReferenceArray
            
            publicDb.saveRecord(pokemonRecord) { savedUser, error in
                if let e = error{
                    print(e.debugDescription)
                }else{
                    print("success")
                }
            }
        }
    }
    
    private func checkDatabase(){
        let query = CKQuery(recordType: RECORD_TYPE_POKEMON, predicate: NSPredicate(value: true))
        
        publicDb.performQuery(query, inZoneWithID: nil, completionHandler: { (results, error) -> Void in
            if error != nil {
                print(error)
            }
            
            if results!.count == 0 {
                self.populateCloudFromJSON()
            }else {
                self.pokemonList = results!
            }
        })
    }
    
    func loadFromJSON() -> Array<Pokemon> {
        let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "json")
        var jsonData: NSData!
        do{
            jsonData = try NSData(contentsOfFile: path!, options: NSDataReadingOptions.DataReadingMappedIfSafe)
        }catch{
            print("error")
        }
        
        let json = JSON(data: jsonData)
        var arrayPokemon = Array<Pokemon>()
        
        for (var i = 0; i < json.count ; i++){
            arrayPokemon.append(Pokemon(json: json[i]))
        }
        
        return arrayPokemon
    }
    
    func pokemonListCount () -> Int {
        return pokemonList.count
    }
    
    func pokemonAtIndex(index: Int) -> CKRecord{
        
        return pokemonList[index]
        
    }
    
    
}