//
//  UserDefaultsModelWrapperTests.swift
//  BasicWeatherAppTests
//
//  Created by iAskedYou2nd on 7/10/23.
//

import XCTest
@testable import BasicWeatherApp

final class UserDefaultsModelWrapperTests: XCTestCase {

    private var sut: UserDefaultsModelWrapper!
    private var mockModel: MockModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.sut = UserDefaultsModelWrapper(persistentStore: UserDefaults())
        self.mockModel = MockModel(testString: "Test", testInt: 0, testBool: true)
    }

    override func tearDownWithError() throws {
        self.sut = nil
        self.mockModel = nil
        try super.tearDownWithError()
    }

    /// Test UserDefaultWrapper works with custom keys foir codable objects
    func testSaveAndRetrieveModelWithCustomKey() {
        var testMockModel: MockModel?
        
        self.sut.setModel(model: self.mockModel, for: "MockKey")
        testMockModel = self.sut.getModel(for: "MockKey", type: MockModel.self)
        
        XCTAssertEqual(self.mockModel, testMockModel)
    }
    
    /// Test UserDefaultWrapper works with the default key for codable objects
    func testSaveAndRetrieveModelWithDefaultKey() {
        var testMockModel: MockModel?
        
        self.sut.setModel(model: self.mockModel)
        testMockModel = self.sut.getModel(type: MockModel.self)
        
        XCTAssertEqual(self.mockModel, testMockModel)
    }

}
