//
//  ContributeVC.swift
//  Explorer
//
//  Created by Zagahr on 14/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import UIKit

final class ContributeVC: UICollectionViewController {
    private lazy var refreshControl = UIRefreshControl()
    private var stateView: LoadingFooterView?
    
    weak var viewModel: ContributeViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configurecollectionView()
    }
    
    var initalLoad: Bool = true
    var languageChangeDetected: Bool = false
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.isScrollEnabled = !initalLoad
        
        if initalLoad && languageChangeDetected {
            collectionView.reloadData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModel.fetchModels(forceRefresh: self.languageChangeDetected)
            self.languageChangeDetected = false
        }
    }
    
    func configureView() {
        title = "Contribute"
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: Notification.Name(rawValue: "LanguageChangedNotification"), object: nil)
        refreshControl.tintColor = StyleGuide.secondaryTextColor
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    
    @objc func languageChanged() {
        viewModel.removeModels()
        initalLoad = true
        languageChangeDetected = true
    }
    
    @objc func refresh() {
        stateView?.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
           self.viewModel.fetchModels(forceRefresh: true)
        }
    }

    func configurecollectionView() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let insets: CGFloat = 10.0
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: 0, left: insets, bottom: 0, right: insets)
            layout.itemSize = CGSize(width: collectionView.frame.width - (insets * 2), height: 300)
            layout.footerReferenceSize = CGSize(width: collectionView.frame.width - (insets * 2), height: 300)
        }
        

        collectionView.backgroundColor = StyleGuide.secondaryBackgroundColor
        collectionView.register(LoadingFooterView.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionFooter", withReuseIdentifier: LoadingFooterView.identifier)
        collectionView.register(ContributeCollectionViewCell.self, forCellWithReuseIdentifier:ContributeCollectionViewCell.identifier)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let showPlaceholderCells = initalLoad
        initalLoad = false
        
        return showPlaceholderCells ? 5 : viewModel.numberOfElements
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContributeCollectionViewCell.identifier, for: indexPath) as? ContributeCollectionViewCell else {
            
            return UICollectionViewCell()
        }
        
        cell.viewModel.coordinatorDelegate = viewModel.coordinatorDelegate
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ContributeCollectionViewCell else { return }

        if let model = viewModel.model(at: indexPath) {
            cell.configureView(with: model)
        } else {
            cell.reset()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingFooterView.identifier, for: indexPath) as? LoadingFooterView else {
            return UICollectionReusableView()
        }
        
        if viewModel.numberOfElements != 0 {
            view.showFooter()
        }
        
        stateView = view
        
        return view
    }
    
    func showErrorView(with message: String) {
        guard let stateView = stateView else {
            return
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(refresh))
        stateView.addGestureRecognizer(tapGesture)
        stateView.isUserInteractionEnabled = true
        stateView.showErrorMessage(message)
    }
}

extension ContributeVC: ContributeViewModelDelegate {
    func onFetchCompleted() {
        collectionView.isScrollEnabled = true
        refreshControl.endRefreshing()
        collectionView.reloadData()
    }
    
    func onFetchFailed(message: String) {
        refreshControl.endRefreshing()
        
        collectionView.performBatchUpdates({
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }) { (result) in
            self.showErrorView(with: message)
        }
    }
}
