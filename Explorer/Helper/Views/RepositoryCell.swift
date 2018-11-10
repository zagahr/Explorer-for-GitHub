//
//  RepoTableViewCell.swift
//  Explorer
//
//  Created by Zagahr on 11/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import UIKit

final class RepositoryCell: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var userLabel: UILabel!
    @IBOutlet private weak var spacerLabel: UILabel!
    @IBOutlet private weak var repoNameLabel: UILabel!
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    @IBOutlet private weak var languageStackView: UIStackView!
    @IBOutlet private weak var languageColorView: UIView!
    @IBOutlet private weak var languageLabel: UILabel!
    
    @IBOutlet private weak var starImage: UIImageView!
    @IBOutlet private weak var starLabel: UILabel!
    
    @IBOutlet private weak var forkImage: UIImageView!
    @IBOutlet private weak var forkLabel: UILabel!
    
    init(frame: CGRect, canLoad: Bool) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("RepositoryCell", owner: self, options: nil)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        configureView()
    }
    
    func prepareForReuse() {
        
    }
    
    func configureView() {
        userLabel.textColor = StyleGuide.blueTextColor
        spacerLabel.textColor = StyleGuide.blueTextColor
        repoNameLabel.textColor = StyleGuide.blueTextColor
        repoNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)

        descriptionLabel.textColor = StyleGuide.secondaryTextColor
        
        languageColorView.layer.cornerRadius = languageColorView.frame.width / 2
        languageLabel.textColor = StyleGuide.secondaryTextColor
        starLabel.textColor = StyleGuide.secondaryTextColor
        forkLabel.textColor = StyleGuide.secondaryTextColor
    }


    func configureView(with model: RepositoryModel) {
        userLabel.text = model.owner.username
        repoNameLabel.text = model.name
        
        languageLabel.text = model.primaryLanguage
        if let colorString = model.languageColor {
            languageColorView.backgroundColor = UIColor().colorWithHexString(hexString: colorString)
        }
        
        descriptionLabel.text = model.description
        
        starLabel.text = "\(model.starCount)"
        forkLabel.text = "\(model.forkCount)"
    }
}

protocol IssueLabelDelegate: class {
    func didSelect(label: Label)
}

final class IssueLabel: UIView {
    private let contentView = UIView()
    private let label = UILabel()
    
    var labelModel: Label?
    var active: Bool = true
    weak var delegate: IssueLabelDelegate?
    
    init() {
        super.init(frame: .zero)
       
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    func configureView() {
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
      
        contentView.layer.cornerRadius = 5
        
        addSubview(contentView)
        contentView.addSubview(label)
        
        label.center(in: contentView)
        contentView.width(to: label).constant += 10
        
        contentView.edgesToSuperview()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        self.addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        if let labelModel = labelModel {
            
            if active {
                contentView.backgroundColor = StyleGuide.primaryBackgoundColor
            } else {
                contentView.backgroundColor = labelModel.color
            }
            
            active.toggle()
            
            delegate?.didSelect(label: labelModel)
        }
    }
    
    func configureView(model: Label, asFilter: Bool = false) {
        self.labelModel = model
        self.active = !asFilter
        
        label.text = model.title.lowercased()
        
        if model.title == "All values" {
            label.text = "Filter by:"
            contentView.backgroundColor = .clear
        } else {
            label.text = model.title
            contentView.backgroundColor = asFilter ? StyleGuide.primaryBackgoundColor : model.color
        }
    }
    
    
    func configureView(title: String, color: UIColor) {
        label.text = title.lowercased()
        
        if title == "All values" {
            label.text = "Filter by:"
            contentView.backgroundColor = .clear
        } else {
            label.text = title
            contentView.backgroundColor = color
        }
    }
}
