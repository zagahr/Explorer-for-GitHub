//
//  RepositoryCollectionViewCell.swift
//  Explorer
//
//  Created by Zagahr on 14/11/2018.
//

import UIKit

final class RepositoryCollectionViewCell: UICollectionViewCell {
    static var identifier = "RepositoryCollectionViewCell"
    private let repositoryCell = RepositoryCell(frame: .zero, canLoad: false)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        repositoryCell.prepareForReuse()
    }
    
    func configureView() {
        contentView.addSubview(repositoryCell)
        contentView.backgroundColor = StyleGuide.primaryBackgoundColor
        contentView.layer.cornerRadius = 5
        contentView.addShadowWithOffset(CGSize(width: 0, height: 6), color: .black, opacity: 0.1, shadowRadius: 5)
        repositoryCell.edgesToSuperview(insets: .init(top: 5, left: 5, bottom: 0, right: 5))
    }
    
    func configureView(with model: RepositoryModel) {
        repositoryCell.configureView(with: model)
    }
}

