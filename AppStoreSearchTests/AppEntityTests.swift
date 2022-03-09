//
//  AppStoreSearchTests.swift
//  AppStoreSearchTests
//
//  Created by Peter hornsby on 3/8/22.
//

import XCTest
import CoreData
import os.log

@testable import AppStoreSearch

class AppStoreSearchTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func tesAppEntityGoodParameters() throws {
        
        let source: [String : Any] = [
            "trackName": "Cool App 1",
            "version": "7.7.0",
            "artistName": "pjh",
            "description": "App Description - text",
            "primaryGenreName": "App Category",
            "price": 7.00,
            "fileSizeBytes": "8783872",
            "artworkUrl512": "https://is3-ssl.mzstatic.com/image/thumb/Purple126/v4/1d/f1/4d/1df14d63-bd52-2fba-15cc-16707c8663a7/source/512x512bb.jpg",
        ]
        
        
        let appEntity = DataModel.makeAppEntityFromSource(source)
        
        XCTAssertNotNil(appEntity)
        
    }
    

    func testAppEntityBadName() throws {
        let source: [String : Any] = [
            "trackName": "",
            "version": "7.7.0",
            "artistName": "pjh",
            "description": "App Description - text",
            "primaryGenreName": "App Category",
            "price": 7.00,
            "fileSizeBytes": "8783872",
            "artworkUrl512": "https://is3-ssl.mzstatic.com/image/thumb/Purple126/v4/1d/f1/4d/1df14d63-bd52-2fba-15cc-16707c8663a7/source/512x512bb.jpg",
        ]
        
        
        let appEntity = DataModel.makeAppEntityFromSource(source)

        XCTAssertNil(appEntity)

    }

    func testAppEntityBadAppDesciption() throws {
        let source: [String : Any] = [
            "trackName": "Cool App 2",
            "version": "7.7.0",
            "artistName": "pjh",
            "description": "",
            "primaryGenreName": "App Category",
            "price": 7.00,
            "fileSizeBytes": "8783872",
            "artworkUrl512": "https://is3-ssl.mzstatic.com/image/thumb/Purple126/v4/1d/f1/4d/1df14d63-bd52-2fba-15cc-16707c8663a7/source/512x512bb.jpg",
        ]
        
        let appEntity = DataModel.makeAppEntityFromSource(source)
        XCTAssertNil(appEntity)
    }

    func testAppEntityBadCatgory() throws {
        let source: [String : Any] = [
            "trackName": "Cool App 3",
            "version": "7.7.0",
            "artistName": "pjh",
            "description": "App Description - text",
            "primaryGenreName": "",
            "price": 7.00,
            "fileSizeBytes": "8783872",
            "artworkUrl512": "https://is3-ssl.mzstatic.com/image/thumb/Purple126/v4/1d/f1/4d/1df14d63-bd52-2fba-15cc-16707c8663a7/source/512x512bb.jpg",
        ]
        
        
        let appEntity = DataModel.makeAppEntityFromSource(source)
        XCTAssertNil(appEntity)
    }

    func testAppEntityBadPrice() throws {
        let source: [String : Any] = [
            "trackName": "Cool App 4",
            "version": "7.7.0",
            "artistName": "pjh",
            "description": "App Description - text",
            "primaryGenreName": "App Category",
            "price": "",
            "fileSizeBytes": "8783872",
            "artworkUrl512": "https://is3-ssl.mzstatic.com/image/thumb/Purple126/v4/1d/f1/4d/1df14d63-bd52-2fba-15cc-16707c8663a7/source/512x512bb.jpg",
        ]
        
        let appEntity = DataModel.makeAppEntityFromSource(source)
        XCTAssertNil(appEntity)
    }

    func testAppEntityFreePrice() throws {
        let source: [String : Any] = [
            "trackName": "Cool App 5",
            "version": "7.7.0",
            "artistName": "pjh",
            "description": "App Description - text",
            "primaryGenreName": "App Category",
            "price": 0.00,
            "fileSizeBytes": "8783872",
            "artworkUrl512": "https://is3-ssl.mzstatic.com/image/thumb/Purple126/v4/1d/f1/4d/1df14d63-bd52-2fba-15cc-16707c8663a7/source/512x512bb.jpg",
        ]
        
        let appEntity = DataModel.makeAppEntityFromSource(source)
        XCTAssertEqual(appEntity?.isFree(), true)
    }

    func testAppEntityCostToPrice() throws {
        let source: [String : Any] = [
            "trackName": "Cool App 6",
            "version": "7.7.0",
            "artistName": "pjh",
            "description": "App Description - text",
            "primaryGenreName": "App Category",
            "price": 7.06,
            "fileSizeBytes": "8783872",
            "artworkUrl512": "https://is3-ssl.mzstatic.com/image/thumb/Purple126/v4/1d/f1/4d/1df14d63-bd52-2fba-15cc-16707c8663a7/source/512x512bb.jpg",
        ]
        
        let appEntity = DataModel.makeAppEntityFromSource(source)
        XCTAssertEqual(appEntity?.isFree(), false)
    }
}
