//
//  DataModelTests.swift
//  AppStoreSearchTests
//
//  Created by Peter hornsby on 3/9/22.
//

import XCTest
@testable import AppStoreSearch

class DataModelTests: XCTestCase {
    
    var appEntity = DataModel.makeAppEntityFromSource([
        "trackName": "Cool App",
        "version": "7.7.0",
        "artistName": "pjh",
        "description": "App Description - text",
        "primaryGenreName": "App Category",
        "price": 7.00,
        "fileSizeBytes": "8783872",
        "artworkUrl512": "https://is3-ssl.mzstatic.com/image/thumb/Purple126/v4/1d/f1/4d/1df14d63-bd52-2fba-15cc-16707c8663a7/source/512x512bb.jpg",
    ] as [String : Any])
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAppStoreServiceQueryForAppsFromDataModel() throws {
        let term = "IBM"
        let result = DataModel.queryForApps(term: term, handle: {_, _ in })
        
        // pjh: This means the function executed correctly, not including async behavior
        XCTAssertEqual(result.code, .okayNoErrorCode)
    }

    func testQueryForAppsWithValidString() throws {
        let result = DataModel.queryForApps(term: "IBM") {
            (appEntities, _) -> () in
            print("appEntities count: \(appEntities.count)")
        }
        
        XCTAssertEqual(result.code, .okayNoErrorCode)
    }
    
    
    func testQueryForAppsWithEmptyString() throws {
        let result = DataModel.queryForApps(term: "") {
            (appEntities, _) -> () in
            print("appEntities count: \(appEntities.count)")
        }
        
        XCTAssertEqual(result.code, .emptyStringErrorCode)
    }
    
    func testQueryForAppsWithNilString() throws {
        let result = DataModel.queryForApps(term: nil) {
            (appEntities, _) -> () in
            print("appEntities count: \(appEntities.count)")
        }
        
        XCTAssertEqual(result.code, .nilStringErrorCode)
    }
    
    
    

    func testIsValidNameForAppEntity() throws {
        XCTAssertTrue(DataModel.isAppEntityValid(appEntity))
        
        appEntity?.name = ""
        XCTAssertFalse(DataModel.isAppEntityValid(appEntity))
    }
    
    
    func testIsValidVersionForAppEntity() throws {
        XCTAssertTrue(DataModel.isAppEntityValid(appEntity))
        
        appEntity?.version = ""
        XCTAssertFalse(DataModel.isAppEntityValid(appEntity))
    }
    
    
    func testIsValidDeveloperForAppEntity() throws {
        XCTAssertTrue(DataModel.isAppEntityValid(appEntity))
        
        appEntity?.developer = ""
        XCTAssertFalse(DataModel.isAppEntityValid(appEntity))
    }
    
    func testIsValidDescriptionForAppEntity() throws {
        XCTAssertTrue(DataModel.isAppEntityValid(appEntity))
        
        appEntity?.appDescription = ""
        XCTAssertFalse(DataModel.isAppEntityValid(appEntity))
    }
    
    func testIsValidCategoryForAppEntity() throws {
        XCTAssertTrue(DataModel.isAppEntityValid(appEntity))
        
        appEntity?.category = ""
        XCTAssertFalse(DataModel.isAppEntityValid(appEntity))
    }
    
    func testIsValidPriceForAppEntity() throws {
        XCTAssertTrue(DataModel.isAppEntityValid(appEntity))
        
        appEntity?.price = ""
        XCTAssertFalse(DataModel.isAppEntityValid(appEntity))
    }
    
    func testIsValidFileSizeForAppEntity() throws {
        XCTAssertTrue(DataModel.isAppEntityValid(appEntity))
        
        appEntity?.size = ""
        XCTAssertFalse(DataModel.isAppEntityValid(appEntity))
    }
    
    func testIsValidArtworkForAppEntity() throws {
        XCTAssertTrue(DataModel.isAppEntityValid(appEntity))
        
        appEntity?.artworkURL = ""
        XCTAssertFalse(DataModel.isAppEntityValid(appEntity))
    }
}
