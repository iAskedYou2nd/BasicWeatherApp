//
//  UserDefaultsWrapper.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 6/1/23.
//

import Foundation

class UserDefaultsModelWrapper {
    
    private let persistentStore: UserDefaults
    
    init(persistentStore: UserDefaults = UserDefaults.standard) {
        self.persistentStore = persistentStore
    }
    
}

extension UserDefaultsModelWrapper: PersistentContainerType {
    
    func setModel<T: Encodable>(model: T, for key: String) {
        do {
            let encodedData = try JSONEncoder().encode(model)
            self.persistentStore.set(encodedData, forKey: key)
        } catch {
            print(error)
        }
    }
    
    func getModel<T: Decodable>(for key: String, type: T.Type) -> T? {
        guard let data = self.persistentStore.data(forKey: key) else { return nil }
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            print(error)
            return nil
        }
    }
    
    func purgeContainer() {
        guard let domain = Bundle.main.bundleIdentifier else { return }
        self.persistentStore.removePersistentDomain(forName: domain)
    }
    
}
