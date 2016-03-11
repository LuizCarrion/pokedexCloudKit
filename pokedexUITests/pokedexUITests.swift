//
//  pokedexUITests.swift
//  pokedexUITests
//
//  Created by Luiz Carrion on 3/7/16.
//  Copyright © 2016 LuizCarrion. All rights reserved.
//

import XCTest
@testable import pokedex

class pokedexUITests: XCTestCase {
    
    
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPokemonTableView(){
        
        let app = XCUIApplication()
        
        sleep(10)
        XCTAssertEqual(app.tables.cells.count, 6)
        XCTAssert(app.staticTexts["Pikachu"].exists, "nameLabel")
        XCTAssert(app.staticTexts["Bulbasaur"].exists, "nameLabel")
        XCTAssert(app.staticTexts["Charizard"].exists, "nameLabel")
        XCTAssert(app.staticTexts["Snorlax"].exists, "nameLabel")
        XCTAssert(app.staticTexts["Primeape"].exists, "nameLabel")
        XCTAssert(app.staticTexts["Squirtle"].exists, "nameLabel")
        app.tables.cells.staticTexts["Charizard"].tap()
        
        XCTAssert(app.staticTexts["Lvl: 95"].exists, "levelLabel")
        XCTAssert(app.staticTexts["Fire    Flying"].exists, "typeLabel")
        
        app.navigationBars["pokedex.PokemonDetailView"].buttons["Favorite"].tap()
        app.navigationBars["pokedex.PokemonDetailView"].buttons["Back"].tap()
        app.tables.cells.staticTexts["Pikachu"].tap()
        
        sleep(5)
        XCTAssert(app.staticTexts["247"].exists, "healthLabel")
        XCTAssert(app.staticTexts["Electric"].exists, "typeLabel")
        XCTAssertEqual(app.tables.cells.count, 4)
        app.tables.cells.staticTexts["Iron Tail"].tap()
        
        
        
    }
    
}
