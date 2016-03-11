//
//  pokedexTests.swift
//  pokedexTests
//
//  Created by Luiz Carrion on 3/7/16.
//  Copyright © 2016 LuizCarrion. All rights reserved.
//

import XCTest
import CloudKit
@testable import pokedex

class pokedexTests: XCTestCase, AsyncUpdateProtocol{
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    

    func testJSON(){
        let pokemonArray = CloudManager.sharedInstance().loadFromJSON()
        
        XCTAssertEqual(pokemonArray.count, 6)
        XCTAssertEqual(pokemonArray[0].name, "Pikachu")
        XCTAssertEqual(pokemonArray[1].status.attack, 253)
        XCTAssertEqual(pokemonArray[2].skills[0].name, "Take Down")
    }
    
    func testCloud(){
        CloudManager.sharedInstance().checkDatabase({
            XCTAssertNotNil(CloudManager.sharedInstance().pokemonAtIndex(0))
            XCTAssertTrue(CloudManager.sharedInstance().pokemonListCount() > 0)
            
            let record = CloudManager.sharedInstance().pokemonAtIndex(CloudManager.sharedInstance().pokemonListCount() - 1)
            
            let skills = record["Skills"] as! [CKRecord]
            
            XCTAssertNotEqual(skills.count, 0)
            
        })
       
    }
    
    func asyncUpdate() {
        
    }
}
