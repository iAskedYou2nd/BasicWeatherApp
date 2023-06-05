//
//  PersitentContainerType.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 6/1/23.
//

import Foundation

protocol PersistentContainerType {
    func setModel<T: Encodable>(model: T, for key: String)
    func getModel<T: Decodable>(for key: String, type: T.Type) -> T?
    func purgeContainer()
}

extension PersistentContainerType {
    
    static var defaultKey: String {
        return "LastLocation"
    }
    
    func setModel<T: Encodable>(model: T, for key: String = Self.defaultKey) {
        self.setModel(model: model, for: key)
    }
    
    func getModel<T: Decodable>(for key: String = Self.defaultKey, type: T.Type) -> T? {
        return self.getModel(for: key, type: type)
    }
    
}
