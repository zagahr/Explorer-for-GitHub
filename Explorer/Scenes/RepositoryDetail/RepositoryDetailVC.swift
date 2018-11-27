//
//  RepositoryDetailVC.swift
//  Explorer
//
//  Created by Zagahr on 22/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import UIKit

class RepositoryDetailVC: UIViewController {
    weak var viewModel: RepositoryDetailViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    lazy var stackView = ScrollStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchRepositoryDetail()
    }
    
    func configureView() {
        view.addSubview(stackView)
        stackView.edgesToSuperview()
        stackView.backgroundColor = .red
    }
}

extension RepositoryDetailVC: RepositoryDetailViewDelegate {
    
    func onFetchCompleted() {
        print("complete")
    }
    
    func onFetchFailed() {
        print("fails")
    }
}
