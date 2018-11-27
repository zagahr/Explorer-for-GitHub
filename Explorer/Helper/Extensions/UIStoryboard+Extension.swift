//
//  UIStoryboard+Extension.swift
//  Explorer
//
//  Created by Zagahr on 10.09.18.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    func initialViewController() -> UIViewController {
        guard let controller = self.instantiateInitialViewController() else {
            fatalError("Storyboard: \(self.debugDescription) has no initial ViewController on ")
        }
        
        return controller
    }
    
    func initialNavigationController() -> UINavigationController {
        guard let controller = self.instantiateInitialViewController() else {
            fatalError("Storyboard: \(self.debugDescription) has no initial ViewController on ")
        }
        
        guard let navigationController = controller as? UINavigationController else {
            fatalError("Initial ViewController: \(controller.debugDescription) as no NavigationConroller ")
        }
        
        return navigationController
    }
}
