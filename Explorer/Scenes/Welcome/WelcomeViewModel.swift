//
//  WelcomeViewModel.swift
//  Explorer
//
//  Created by Zagahr on 09.09.18.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import Foundation

class WelcomeViewModel {
    weak var coordinatorDelegate: WelcomeCoordinatorDelegate?
    
    // TODO: Add GitHub login
    func login() {
        print("Not implemented yet")
    }
    
    func skip() {
        coordinatorDelegate?.openMainScene()
    }
}
