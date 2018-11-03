//
//  MainCoordinator.swift
//  Explorer
//
//  Created by Zagahr on 10.09.18.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import UIKit


final class MainCoordinator: Coordinator {
    
    let tabBarController: UITabBarController
    
    lazy var trendingScene: TrendingCoordinator = {
        let coordinator = TrendingCoordinator()
        coordinator.start()
        
        return coordinator
    }()

    lazy var contributeScene: ContributeCoordinator = {
        let coordinator = ContributeCoordinator()
        coordinator.start()
        
        return coordinator
    }()
    
//    lazy var searchScene: SearchCoordinator = {
//        let coordinator = SearchCoordinator()
//        coordinator.start()
//
//        return coordinator
//    }()
    
    lazy var settingsScene: SettingsCoordinator = {
        let coordinator = SettingsCoordinator()
        coordinator.start()
        
        return coordinator
    }()
    
    override init() {
        self.tabBarController = UITabBarController()
    }
    
    override func start() {
        tabBarController.tabBar.tintColor = StyleGuide.highlightColor
        tabBarController.tabBar.barTintColor = StyleGuide.elementColor
        tabBarController.setViewControllers([trendingScene.rootViewController, contributeScene.rootViewController, settingsScene.rootViewController], animated: false)
    }
}
