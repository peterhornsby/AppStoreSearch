//
//  DataModelTests.swift
//  AppStoreSearchTests
//
//  Created by Peter hornsby on 3/9/22.
//

import XCTest
@testable import AppStoreSearch

class DataModelTests: XCTestCase {

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

}
