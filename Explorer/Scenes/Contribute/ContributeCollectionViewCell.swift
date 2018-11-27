//
//  ContributeCollectionViewCell
//  Explorer
//
//  Created by Zagahr on 14/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import UIKit

final class ContributeCollectionViewCell: UICollectionViewCell {
    static var identifier = "ContributeTableViewCell"

    private let headerView = ContributeTableViewHeader()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var viewModel = ContributeTableViewModel() {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureView()
        configureCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    func configureView() {
        headerView.startLoading()
        
        contentView.addSubview(headerView)
        contentView.addSubview(collectionView)
        contentView.clipsToBounds = false
        backgroundColor = .clear
 
        headerView.topToSuperview(offset: 50)
        headerView.leftToSuperview(offset: 10)
        headerView.rightToSuperview(offset: -5)
        headerView.height(20)

        collectionView.topToBottom(of: headerView, offset: 10)
        collectionView.leftToSuperview(offset: 5)
        collectionView.rightToSuperview()
        collectionView.bottomToSuperview(offset: -5)
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }

        collectionView.showsHorizontalScrollIndicator = false
        collectionView.clipsToBounds = false
        collectionView.backgroundColor = StyleGuide.secondaryBackgroundColor
        collectionView.register(RepositoryCollectionViewCell.self, forCellWithReuseIdentifier: RepositoryCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: "PlaceholderCell", bundle: nil), forCellWithReuseIdentifier: "PlaceholderCell")
    }
    
    func configureView(with model: ContributeModel) {
        viewModel.swap(with: model)
        
        if viewModel.shoudReload {
            headerView.configure(with: model.title, actionHandler: viewModel.showRepositoriesTableViewController)
            
            collectionView.performBatchUpdates({
                self.collectionView.reloadSections(IndexSet(integer: 0))
            }) { (result) in
                self.viewModel.shoudReload = false
            }
        }
    }
    
    func reset() {
        headerView.startLoading()
        viewModel.swap(with: nil)
        collectionView.reloadData()
    }
}

extension ContributeCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfElements
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell?
        
        if let _ = viewModel.model(at: indexPath) {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: RepositoryCollectionViewCell.identifier, for: indexPath)
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceholderCell", for: indexPath)
        }
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? RepositoryCollectionViewCell else { return }
        
        if let model = viewModel.model(at: indexPath) {
            cell.configureView(with: model)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectCell(at: indexPath)
    }
}

extension ContributeCollectionViewCell: ContributeTableViewModelDelegate {
    func onFetchCompleted(at indexPath: IndexPath) {
        collectionView.visibleCells.enumerated().forEach({ (index, view) in
            guard let cell = view as? RepositoryCollectionViewCell else { return }
            
            let indexPath = IndexPath(item: index, section: 0)
            if let model = viewModel.model(at: indexPath) {
                cell.configureView(with: model)
            }
        })
    }
    
    func onFetchFailed(at index: IndexPath, message: String) {
        
    }
}
