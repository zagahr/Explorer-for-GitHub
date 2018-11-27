//
//  UserCoordinator.swift
//  Explorer
//
//  Created by Zagahr on 21/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import Foundation

final class UserCoordinator {
    static let shared = UserCoordinator()
    
    var user: User? {
        get {
            return get()
        }
        set {
            set(newValue)
        }
    }

    func update(language: Language) {
        var updatedUser = user ?? User(language: language)
        updatedUser.language = language
        user = updatedUser
    }
    
    
    private func set(_ user: User?) {
        guard let user = user else { return }
        
        let encoder = JSONEncoder()
    
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: "CurrentUser")
        }
    }
    
    private func get() -> User? {
        let decoder = JSONDecoder()
        
        if let userData = UserDefaults.standard.data(forKey: "CurrentUser"),
            let user = try? decoder.decode(User.self, from: userData) {
            return user
        } else {
            return nil
        }
    }
}
