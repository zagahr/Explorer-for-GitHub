//
//  Coordinator.swift
//  Explorer
//
//  Created by Zagahr on 10.09.18.
//  Copyright © 2018 Zagahr. All rights reserved.
//

class Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    
    func start() {
        preconditionFailure("This methode needs to be overriden by subclass")
    }
    
    func finish() {
        preconditionFailure("This methode needs to be overriden by subclass")
    }
    
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        if childCoordinators.contains(where: { $0 == coordinator }) {
            childCoordinators.removeAll { $0 == coordinator }
        } else {
            print("Couldn't remove coordinator: \(coordinator). It's not a child coordinator.")
        }
    }
    
    func removeAllChildCoordinatorsWith<T>(type: T.Type) {
        childCoordinators = childCoordinators.filter { $0 is T == false }
    }
    
    func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }
}


extension Coordinator: Equatable {
    static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        return lhs === rhs
    }
}
