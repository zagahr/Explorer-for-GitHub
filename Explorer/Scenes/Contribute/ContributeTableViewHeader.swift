//
//  ContributeTableViewHeader.swift
//  Explorer
//
//  Created by Zagahr on 14/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import UIKit

typealias ActionHandler = () -> Void

final class ContributeTableViewHeader: UIView {
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let actionButton = UIButton()
    
   
    private var actionHandler: ActionHandler?
    
    init() {
        super.init(frame: .zero)
        
        configureView()
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        addSubview(stackView)
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(actionButton)
        
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        titleLabel.backgroundColor = StyleGuide.secondaryBackgroundColor
        titleLabel.text = "Default value"
        titleLabel.adjustsFontSizeToFitWidth = true
        actionButton.isHidden = true
        actionButton.setTitle("Show more", for: .normal)
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        actionButton.setTitleColor(StyleGuide.highlightColor, for: .normal)
        actionButton.setTitleColor(StyleGuide.secondaryTextColor, for: .highlighted)
        actionButton.addTarget(self, action:  #selector(triggerAction), for: .touchUpInside)
        actionButton.width(66)
    }
    
    func configureConstraints() {
        stackView.edgesToSuperview()
    }
    
    func configure(with title: String, actionHandler: ActionHandler? = nil) {
        stopLoading()
        
        titleLabel.textColor = StyleGuide.primaryTextColor
        titleLabel.backgroundColor = .clear
        titleLabel.text = title
        self.actionHandler = actionHandler
        actionButton.isHidden = actionHandler == nil
    }
    
    func startLoading() {
        actionButton.isHidden = true
        titleLabel.text = ""
    }
    
    func stopLoading() {
        backgroundColor = StyleGuide.secondaryBackgroundColor
        actionButton.isHidden = false
    }
    
    @objc func triggerAction() {
        actionHandler?()
    }
}
