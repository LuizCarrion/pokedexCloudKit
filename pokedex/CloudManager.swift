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
let RECORD_TYPE_FAVORITE = "Favorite"
public class CloudManager: NSObject {
    
    private let fileName = "pokemons"
    private let privateDb: CKDatabase = CKContainer.defaultContainer().privateCloudDatabase
    private let publicDb: CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
    private var pokemonList = Array<CKRecord>()
    var favorites = Array<CKRecord>()
    var asyncUpdate: AsyncUpdateProtocol?
    var arrayPokemon = Array<Pokemon>()
    
    
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
    
    private func populateCloudFromJSON() {
        let array = loadFromJSON()
        arrayPokemon = array
        
        for var i in 0...array.count-1{
            
            let obj = array[i]
            
            let pokemonID = CKRecordID(recordName: obj.name)
            let pokemonRecord = CKRecord(recordType: RECORD_TYPE_POKEMON, recordID: pokemonID)
            
            pokemonRecord["Name"] = obj.name
            pokemonRecord["Level"] = obj.level
            pokemonRecord["Number"] = obj.number
            pokemonRecord["Type"] = [obj.type.type1, obj.type.type2]
            
            let statusID = CKRecordID(recordName: "\(obj.name): Stats")
            let statusRecord = CKRecord(recordType: RECORD_TYPE_STATUS, recordID: statusID)
            
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
                
                let skillID = CKRecordID(recordName: "\(obj.name): \(skill.name)")
                let skillRecord = CKRecord(recordType: RECORD_TYPE_SKILLS, recordID: skillID)
                
                
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
                    if(i == array.count-1){
                        self.uploadImages(obj, pokeRecord: pokemonRecord, last: true, index: i)
                    }else{
                        self.uploadImages(obj, pokeRecord: pokemonRecord, last: false, index: i)
                    }
                }
            }
        }
        
    }
    
    
    
    private func uploadImages(pokemon: Pokemon, pokeRecord: CKRecord, last: Bool, index: Int){
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            let url = NSURL(string: pokemon.icon)!
            if let icon = UIImage(data: NSData(contentsOfURL: url)!){
                let imageUrl = NSURL(string: pokemon.image)!
                if let image = UIImage(data: NSData(contentsOfURL: imageUrl)!){
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        
                        
                        pokeRecord["Icon"] = CKAsset(fileURL: self.saveImageToFile(icon, index: index+100))
                        pokeRecord["Image"] = CKAsset(fileURL: self.saveImageToFile(image, index: index))
                        
                        
                        self.publicDb.saveRecord(pokeRecord)  { savedUser, error in
                            if let e = error{
                                print("\(e.localizedDescription)")
                            }else{
                                print("\(pokemon.name) updated icon/image")
                                
                                if(last){
                                    self.checkDatabase()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func saveImageToFile(image: UIImage, index: Int) -> NSURL{
        let dirPaths = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true)
        
        let docsDir: AnyObject = dirPaths[0]
        
        let filePath =
        docsDir.stringByAppendingPathComponent("image\(index).png")
        
        UIImageJPEGRepresentation(image, 0.5)!.writeToFile(filePath,
            atomically: true)
        
        return NSURL.fileURLWithPath(filePath)
    }

    
    
    func checkDatabase(){
        let query = CKQuery(recordType: RECORD_TYPE_POKEMON, predicate: NSPredicate(value: true))
        
        publicDb.performQuery(query, inZoneWithID: nil, completionHandler: { (results, error) -> Void in
            if error != nil {
                print(error)
            }
            
            if results!.count == 0 {
                self.populateCloudFromJSON()
            }else {
                self.pokemonList = results!
                self.fetchFavorites()
            }
        })
    }
    
    private func loadFromJSON() -> Array<Pokemon> {
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
    
    private func fetchFavorites(){
        let query = CKQuery(recordType: RECORD_TYPE_FAVORITE, predicate: NSPredicate(value: true))
        
        privateDb.performQuery(query, inZoneWithID: nil, completionHandler: { (results, error) -> Void in
            if error != nil {
                print(error)
            }
            if let records = results{
                self.favorites = records
                dispatch_async(dispatch_get_main_queue(), {
                    self.asyncUpdate?.asyncUpdate()
                })

            }
        })

    }
    
    func saveFavorite(name: String){
        let record = CKRecord(recordType: RECORD_TYPE_FAVORITE, recordID: CKRecordID(recordName: name+": Favorite"))
        record["Pokemon"] = name
        privateDb.saveRecord(record) { (record, error) -> Void in
            self.fetchFavorites()
        }
    }
    
    func pokemonListCount () -> Int {
        return pokemonList.count
    }
    
    func pokemonAtIndex(index: Int) -> CKRecord{
        
        return pokemonList[index]
    }
    
    
}