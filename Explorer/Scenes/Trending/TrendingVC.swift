//
//  TrendingVCViewController.swift
//  Explorer
//
//  Created by Zagahr on 26.08.18.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import Foundation
import XLPagerTabStrip

final class TrendingVC: ButtonBarPagerTabStripViewController  {
    
    weak var coordinatorDelegate: RepositoryDetailCoordinatorDelegate?
    
    override func viewDidLoad() {
        configureView()
        
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configureView() {
        title = "Trending"
        view.backgroundColor = StyleGuide.secondaryBackgroundColor
        settings.style.buttonBarBackgroundColor = StyleGuide.highlightColor
        settings.style.buttonBarItemBackgroundColor = StyleGuide.highlightColor
        settings.style.selectedBarBackgroundColor = StyleGuide.tertiaryTextColor
        settings.style.selectedBarHeight = 2
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let service = GitHubService()
        
        let viewControllers = TrendingPeroid.allCases.compactMap({(period) -> UIViewController in
            let viewModel = RepositoriesListViewModel(period: period, service: service)
            viewModel.coordinatorDelegate = coordinatorDelegate
            let viewController = RepositoriesListController(collectionViewLayout: UICollectionViewFlowLayout())
            viewController.viewModel = viewModel
            
            return viewController
        })
        
        return viewControllers
    }
}
