//
//  TrendingTableViewController.swift
//  Explorer
//
//  Created by Zagahr on 11/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import Foundation
import XLPagerTabStrip
import TinyConstraints

final class RepositoriesListController: UICollectionViewController, UICollectionViewDataSourcePrefetching, IndicatorInfoProvider {
    private lazy var itemInfo = IndicatorInfo(title: "View")
    private lazy var refreshControl = UIRefreshControl()
    
    private var stateView: LoadingFooterView?
    
    var footerView: LoadingFooterView?
    
    var viewModel: RepositoriesListViewModel! {
        didSet {
            viewModel.delegate = self
            itemInfo.title = viewModel.title
        }
    }
    
    var initalLoad: Bool = true
    var languageChangeDetected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if initalLoad && languageChangeDetected {
            collectionView.reloadData()
        }
        
        if viewModel.type == .trending {
            collectionView.isScrollEnabled = !initalLoad
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.viewModel.fetchRepositories(forceRefresh: self.languageChangeDetected)
                self.languageChangeDetected = false
            }
        }
    }
    
    func configureView() {
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: Notification.Name(rawValue: "LanguageChangedNotification"), object: nil)
        refreshControl.tintColor = StyleGuide.secondaryTextColor
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    func configureCollectionView() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let insets: CGFloat = 10.0
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
            layout.itemSize = CGSize(width: collectionView.frame.width - (insets * 2), height: 200)
            layout.footerReferenceSize = CGSize(width: collectionView.frame.width - (insets * 2), height: 200)
        }
        
        collectionView.backgroundColor = StyleGuide.secondaryBackgroundColor
        collectionView.register(RepositoryCollectionViewCell.self, forCellWithReuseIdentifier:RepositoryCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: "PlaceholderCell", bundle: nil), forCellWithReuseIdentifier: "PlaceholderCell")
        collectionView.prefetchDataSource = self
        collectionView.register(LoadingFooterView.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionFooter", withReuseIdentifier: LoadingFooterView.identifier)
    }
    
    @objc func languageChanged() {
        viewModel.removeModels()
        initalLoad = true
        languageChangeDetected = true
    }
    
    @objc func refresh() {
        stateView?.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModel.fetchRepositories(forceRefresh: true)
        }
    }
    
    @objc func loadMore() {
        stateView?.startAnimating()
        
        self.viewModel.fetchRepositories()
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let showPlaceholderCells = initalLoad && viewModel.type == .trending
        initalLoad = false
        
        return showPlaceholderCells ? 10 : viewModel.numberOfElements
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell?
        
        if viewModel.model(at: indexPath) != nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: RepositoryCollectionViewCell.identifier, for: indexPath)
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceholderCell", for: indexPath)
            cell?.layer.cornerRadius = 5
            cell?.addShadowWithOffset(CGSize(width: 0, height: 6), color: .black, opacity: 0.1, shadowRadius: 5)
        }
        
        return cell ?? UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? RepositoryCollectionViewCell else { return }
        
        if let model = viewModel.model(at: indexPath) {
            cell.configureView(with: model)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingFooterView.identifier, for: indexPath) as? LoadingFooterView else {
            return UICollectionReusableView()
        }
        
        if viewModel.numberOfElements != 0 {
            view.showFooter()
        }
        
        if viewModel.type == .detail && viewModel.canLoadMore {
            view.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(loadMore))
            view.addGestureRecognizer(tapGesture)
            view.showErrorMessage("Load more")
        } else {
            view.isUserInteractionEnabled = false
        }
        
        stateView = view
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if viewModel.type == .detail {
            indexPaths.forEach({ (index) in
                if viewModel.model(at: index) == nil {
                    viewModel.fetchRepositories(forceRefresh: true, indexPath: index)
                }
            })
        }
    }
    
   override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectCell(at: indexPath)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

extension RepositoriesListController: RepositoriesListViewModelDelegate {
    func onFetchCompleted() {
        collectionView.isScrollEnabled = true
        refreshControl.endRefreshing()
        
        collectionView.performBatchUpdates({
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }, completion: nil)
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
