//
//  ImageCacheTests.swift
//  BasicWeatherAppTests
//
//  Created by iAskedYou2nd on 7/10/23.
//

import XCTest
import Combine
@testable import BasicWeatherApp

final class ImageCacheTests: XCTestCase {

    private var sut: ImageCache = ImageCache.shared
    private var mockImage: UIImage!
    private var mockImageKey: String!
    private var subscriptions: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.mockImage = UIImage(named: "question-mark")
        self.mockImageKey = "MockImage"
        self.subscriptions = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        self.sut.purgeCache()
        self.mockImage = nil
        self.mockImageKey = nil
        self.subscriptions = nil
        try super.tearDownWithError()
    }
    
    /// Test basic storing and retriving image data from cache
    func testSaveAndRetrieveImage() {
        let expectation = XCTestExpectation(description: "Should Receive Cached Image data")
        var cachedImageData: Data?
        
        let testData = self.mockImage.jpegData(compressionQuality: 1)!
        self.sut.set(testData, for: self.mockImageKey)
        
        self.sut.get(for: self.mockImageKey)
            .sink { cachedData in
                cachedImageData = cachedData
                expectation.fulfill()
            }.store(in: &self.subscriptions)
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertEqual(cachedImageData, testData)
    }
    
    /// Test if purge works when data exists in cache
    func testPurgeWithData() {
        let expectation = XCTestExpectation(description: "Should Receive Nil")
        var cachedImageData: Data?
        
        let testData = self.mockImage.jpegData(compressionQuality: 1)!
        self.sut.set(testData, for: self.mockImageKey)

        self.sut.purgeCache()
        
        self.sut.get(for: self.mockImageKey)
            .sink { cachedData in
                cachedImageData = cachedData
                expectation.fulfill()
            }.store(in: &self.subscriptions)
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertNil(cachedImageData)
    }
    
    /// Test that failing to retrieve and image works correctly
    func testFailedToRetrieveImage() {
        let expectation = XCTestExpectation(description: "Should Receive Nil")
        var cachedImageData: Data?
        
        self.sut.get(for: self.mockImageKey)
            .sink { cachedData in
                cachedImageData = cachedData
                expectation.fulfill()
            }.store(in: &self.subscriptions)
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertNil(cachedImageData)
    }
    
}
