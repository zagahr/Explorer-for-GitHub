//
//  AppCoordinator.swift
//  Explorer
//
//  Created by Zagahr on 10.09.18.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import UIKit
import Apollo

let apollo: ApolloClient = {
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = ["Authorization": "Bearer \(GitHubApiKey)"]
    
    let url = URL(string: "https://api.github.com/graphql")!
    
    return ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
}()

protocol AppCoordinatorDelegate: class {
    func didFinish(from coordinator: Coordinator)
}

final class AppCoordinator: Coordinator {
    let window: UIWindow?
    
    lazy var welcomeScene: UINavigationController = {
        let coordinator = WelcomeCoordinator()
        coordinator.coordinatorDelegate = self
        addChildCoordinator(coordinator)
        coordinator.start()
        
        return coordinator.rootViewController
    }()
    
    lazy var mainScene: UITabBarController = {
        let coordinator = MainCoordinator()
        addChildCoordinator(coordinator)
        coordinator.start()

        return coordinator.tabBarController
    }()
    
    
    let rootViewController = UINavigationController()
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    override func start() {
        guard window != nil else {
            return
        }
        
        apollo.cacheKeyForObject = { $0["id"] }
        StyleGuide.setupAppearence()
       
        // TODO: Add separate Constants-file
        let hasRunBefore = UserDefaults.standard.bool(forKey: "FirstAppStart")
        
        if hasRunBefore {
          window?.rootViewController = mainScene
        } else {
            window?.rootViewController = welcomeScene
        }
        
        window?.makeKeyAndVisible()
    }
    
    func presentMainScene() {
        // TODO: Add animation
        window?.rootViewController = mainScene
    }        
}


extension AppCoordinator: AppCoordinatorDelegate {
    func didFinish(from coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
        
        presentMainScene()
    }
}
