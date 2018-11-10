//
//  ScrollStackView.swift
//  Explorer
//
//  Created by Zagahr on 24/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import UIKit

class ScrollStackView : UIScrollView {
    let stackView: UIStackView!
    fileprivate let insets: UIEdgeInsets!
    
    var backgroundView: UIView? = nil {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = backgroundView {
                insertSubview(view, belowSubview: stackView)
            }
        }
    }
    
    init() {
        stackView = UIStackView()
        self.insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        stackView.axis = .vertical
        
        super.init(frame: .zero)
        
        configureView()
        configureConstraints()
    }
    
    init(spacing: CGFloat = 0, insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), axis: NSLayoutConstraint.Axis = .vertical, distribution: UIStackView.Distribution = .fill) {
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = spacing
        self.insets = insets
        
        super.init(frame: .zero)
        
        configureView()
        configureConstraints()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func configureView() {
        keyboardDismissMode = .onDrag
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
    }
    
    func addArrangedSubview(view: UIView) {
        stackView.addArrangedSubview(view)
    }
    
    func setViews(_ views:[UIView]) {
        backgroundView = nil
        
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for view in views {
            stackView.addArrangedSubview(view)
        }
    }
    
    func isEmpty() -> Bool {
        return stackView.arrangedSubviews.isEmpty
    }
    
    func configureConstraints() {
        var constraints: [NSLayoutConstraint] = []
        
        let views:[String:UIStackView] = [
            "stackView":stackView
        ]
        
        constraints.append(NSLayoutConstraint(item: stackView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(insets.top))-[stackView]-(\(insets.bottom))-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(insets.left))-[stackView]-(\(insets.right))-|", options: [], metrics: nil, views: views)
        
        NSLayoutConstraint.activate(constraints)
    }
}
