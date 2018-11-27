//
//  SettingsCoordinator.swift
//  Explorer
//
//  Created by Zagahr on 20/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import UIKit
import AcknowList

protocol SettingsCoordinatorDelegate: class {
    func showLanguageSelect()
    func showRecommendApp()
    func showLicences()
    func writeReview()
}


final class SettingsCoordinator: Coordinator {
    
    let rootViewController: UINavigationController
    let storyboard = UIStoryboard(name: "Settings", bundle: nil)
    
    lazy var tabBarItem: UITabBarItem = {
        return UITabBarItem(title: "Settings", image: UIImage(named: "settings"), selectedImage: nil)
    }()
    
    lazy var viewModel: SettingsViewModel = {
        let viewModel = SettingsViewModel()
        viewModel.coordinatorDelegate = self
        return viewModel
    }()
    
    
    
    override init() {
        self.rootViewController = UINavigationController()
    }
    
    override func start() {
        guard let settingsVC = storyboard.initialViewController() as? SettingsVC else {
            return
        }
        
        settingsVC.tabBarItem = tabBarItem
        settingsVC.viewModel = viewModel
        
        rootViewController.setViewControllers([settingsVC], animated: true)
    }
}


extension SettingsCoordinator: SettingsCoordinatorDelegate {
    func showLanguageSelect() {
        guard let vc = storyboard.instantiateViewController(withIdentifier: "LanguageListViewController") as? LanguageListViewController else { return }
        vc.hidesBottomBarWhenPushed = true
        rootViewController.pushViewController(vc, animated: true)
    }
    
    func showRecommendApp() {
        let text = "Get the new Explorer for GitHub App"
        let controller = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        controller.setValue(NSString(utf8String: "Explorer for GitHub"), forKey: "subject")
        controller.completionWithItemsHandler = { activity, success, items, error in
            if success {
               print("success")
            } else {
                print("error")
            }
        }
        self.rootViewController.present(controller, animated: true, completion: nil)
    }
    
    func showLicences() {
        // TODO: Change acknowledgemets
        let path = Bundle.main.path(forResource: "Pods-Explorer-acknowledgements", ofType: "plist")
        let vc = AcknowListViewController(acknowledgementsPlistPath: path)
        vc.title = "Licenses"
        vc.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(vc, animated: true)
    }
    
    func writeReview() {
        // TODO: Add ID
        guard let url = URLBuilder.init(host: "itunes.apple.com", scheme: "itms-apps")
            .add(paths: ["app", "AddIDHere"])
            .add(item: "action", value: "write-review")
            .url
            else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

final class URLBuilder {
    
    private var components = URLComponents()
    private var pathComponents = [String]()
    
    init(host: String, scheme: String) {
        components.host = host
        components.scheme = scheme
    }
    
    convenience init(host: String, https: Bool = true) {
        self.init(host: host, scheme: https ? "https" : "http")
    }
    
    static func github() -> URLBuilder {
        return URLBuilder(host: "github.com", https: true)
    }
    
    @discardableResult
    func add(path: LosslessStringConvertible) -> URLBuilder {
        pathComponents.append(String(describing: path))
        return self
    }
    
    @discardableResult
    func add(paths: [LosslessStringConvertible]) -> URLBuilder {
        paths.forEach { self.add(path: $0) }
        return self
    }
    
    @discardableResult
    func add(item: String, value: LosslessStringConvertible) -> URLBuilder {
        var items = components.queryItems ?? []
        items.append(URLQueryItem(name: item, value: String(describing: value)))
        components.queryItems = items
        return self
    }
    
    var url: URL? {
        var components = self.components
        if !pathComponents.isEmpty {
            components.path = "/" + pathComponents.joined(separator: "/")
        }
        return components.url
    }
    
}
