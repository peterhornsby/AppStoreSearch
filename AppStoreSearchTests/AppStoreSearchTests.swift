//
//  AppStoreSearchTests.swift
//  AppStoreSearchTests
//
//  Created by Peter hornsby on 3/8/22.
//

import XCTest
@testable import AppStoreSearch

class AppStoreSearchTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testModelValidateAppEntityGoodParameters() throws {
        let name = "Cool App"
        let descripton = "App Description - text"
        let category = "App Category"
        let price = "7.00"
        let size = "8783872"
        
        let appEntity = DataModel.makeAppEntity(name,
                                                descripton,
                                                category,
                                                price,
                                                size)
        
        XCTAssertNotNil(appEntity)
        
    }
    

    func testModelValidateAppEntityBadName() throws {
        let name = ""
        let descripton = "App Description - text"
        let category = "App Category"
        let price = "7.00"
        let size = "8783872"
        
        let appEntity = DataModel.makeAppEntity(name,
                                                descripton,
                                                category,
                                                price,
                                                size)
        
        XCTAssertNil(appEntity)
        
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
