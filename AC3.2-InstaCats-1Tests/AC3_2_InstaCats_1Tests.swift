//
//  AC3_2_InstaCats_1Tests.swift
//  AC3.2-InstaCats-1Tests
//
//  Created by Louis Tur on 10/10/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import XCTest
@testable import AC3_2_InstaCats_1

class AC3_2_InstaCats_1Tests: XCTestCase {
    
    let testInstaCatTableVC: InstaCatTableViewController = InstaCatTableViewController()
    
    let testName: String = "Insta Cat"
    let testID: Int = 99999
    let testURL: URL = URL(string: "http://www.google.com")!
    
    let testFileName: String = "test.json"
    let invalidFileName: String = "testing.json"
    let malformedFileName: String = "testedjson"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitializerOfInstaCat() {
        let testInstaCat: InstaCat = InstaCat(name: testName, id: testID, instagramURL: testURL)
        
        XCTAssertTrue(testInstaCat.name == testName)
        XCTAssertTrue(testInstaCat.id == testID)
        XCTAssertTrue(testInstaCat.instagramURL == testURL)
    }
    
    func testValidInstaCatDescription() {
//        let testInstaCat: InstaCat = InstaCat(name: testName, id: testID, instagramURL: testURL)
//        let expectedDescription: String = "Nice to me you, I'm \(testName)"
//        
//        XCTAssertTrue(testInstaCat.description == expectedDescription)
    }
    
    func testGetResourceURLFromFilename() {
        let testFileName: String = "test.json"
        let testFileURL = testInstaCatTableVC.getResourceURL(from: testFileName)
        XCTAssertNotNil(testFileURL, "getResourceURL(from:) should return a non-nil URL for a valid file")
        
        let invalidFileName: String = "testing.json"
        let invalidTestFileURL = testInstaCatTableVC.getResourceURL(from: invalidFileName)
        XCTAssertNil(invalidTestFileURL, "getResourceURL(from:) should return nil for a file that does not exist")
        
        let malformedFileName: String = "testedjson"
        let malformedFileURL = testInstaCatTableVC.getResourceURL(from: malformedFileName)
        XCTAssertNil(malformedFileURL, "getResourceURL(from:) should return nil for an improperly formatted filename parameter")
    }
    
    func testGetDataFromURL() {
        let testFileURL = testInstaCatTableVC.getResourceURL(from: testFileName)
        let testData = testInstaCatTableVC.getData(from: testFileURL!)
        XCTAssertNotNil(testData, "getData(from:) should return a non-nil URL for a valid file")
    }
    
    func testGettingInstaCatsFromData() {
        guard let testFileURL = testInstaCatTableVC.getResourceURL(from: testFileName),
            let testFileData = testInstaCatTableVC.getData(from: testFileURL),
            let testFileInstaCats = testInstaCatTableVC.getInstaCats(from: testFileData)
        else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(testFileInstaCats.count == 3)
        XCTAssertTrue(testFileInstaCats[0].name == "Nala Cat")
        XCTAssertTrue(testFileInstaCats[1].id == 002)
        XCTAssertTrue(testFileInstaCats[2].instagramURL == URL(string: "https://www.instagram.com/grump_cat_/?hl=en"))
    }

}
