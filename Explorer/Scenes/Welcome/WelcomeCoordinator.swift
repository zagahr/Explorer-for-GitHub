//
//  WelcomeCoordinator.swift
//  Explorer
//
//  Created by Zagahr on 10.09.18.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import UIKit

protocol WelcomeCoordinatorDelegate: class {
    func openMainScene()
}

class WelcomeCoordinator: Coordinator, WelcomeCoordinatorDelegate {
    weak var coordinatorDelegate: AppCoordinatorDelegate?
    
    let rootViewController: UINavigationController
    let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
    
    lazy var viewModel: WelcomeViewModel! = {
        let viewModel = WelcomeViewModel()
        viewModel.coordinatorDelegate = self
        
        return viewModel
    }()
    
    override init() {      
        self.rootViewController = UINavigationController()
    }
    
    override func start() {
        guard let welcomeVC = storyboard.initialViewController() as? WelcomeVC else {
            return
        }
        
        welcomeVC.viewModel = viewModel
        rootViewController.isNavigationBarHidden = true
        rootViewController.setViewControllers([welcomeVC], animated: true)
    }
    
    override func finish() {
        rootViewController.viewControllers.removeAll()
        coordinatorDelegate?.didFinish(from: self)
    }
    
    // TODO: Add separate Constants-file
    func openMainScene() {
        UserDefaults.standard.set(true, forKey: "FirstAppStart")
        finish()
    }
}
