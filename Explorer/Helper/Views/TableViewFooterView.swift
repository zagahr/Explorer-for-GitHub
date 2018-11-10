//
//  TableViewFooterView.swift
//  Explorer
//
//  Created by Zagahr on 15/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import UIKit

extension UITableView {
    var loadingFooterView:LoadingFooterView! {
        if let loadingFooterView = tableFooterView as? LoadingFooterView {
            return loadingFooterView
        }
        tableFooterView = LoadingFooterView()
        return tableFooterView as? LoadingFooterView
    }
}


final class LoadingFooterView: UICollectionReusableView {
    class var identifier: String { return "LoadingTableFooterViewIdentifier"}
    
    let loadingView = LoadingView()
    let messageLabel = UILabel()
    let imageView = UIImageView()
    
    var imageCenterContraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureConstraints()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        loadingView.isHidden = true
        addSubview(loadingView)
        
        messageLabel.textAlignment = NSTextAlignment.center
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        messageLabel.textColor = StyleGuide.secondaryTextColor
        messageLabel.isHidden = true
        messageLabel.text = "Explorer"
        
        addSubview(messageLabel)
        
        imageView.image = UIImage(named: "explorer_frame")
        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFit
        
        addSubview(imageView)
    }
    
    private func configureConstraints() {
        imageView.height(50)
        imageView.width(50)
        imageView.center(in: self, offset: CGPoint(x: 0, y: -20))

        messageLabel.centerX(to: self)
        messageLabel.topToBottom(of: imageView, offset: 10)
    }
    
    func startAnimating() {
        resetSubviews()
        loadingView.isHidden = false
        loadingView.startAnimating()
    }
    
    func stopAnimating() {
        resetSubviews()
        loadingView.isHidden = true
        loadingView.stopAnimating()
    }
    
    func showErrorMessage(_ message: String) {
        stopAnimating()
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 18)
        messageLabel.isHidden = false
        imageView.image = UIImage(named: "refresh")
        imageView.isHidden = false
        imageCenterContraint?.constant = 20
    }
    
    func showMessage(_ message:String) {
        stopAnimating()
        messageLabel.text = message
        messageLabel.isHidden = false
        imageCenterContraint?.constant = 20
    }
    
    func showBanner() {
        stopAnimating()
        imageView.isHidden = false
    }
    
    func showFooter() {
        stopAnimating()
        messageLabel.text = "Explorer"
        imageView.isHidden = false
        messageLabel.isHidden = false
    }
    
    func showFooterWithVersion() {
        showFooter()
        
        messageLabel.text = "Explorer \n \(Bundle.main.prettyVersionString)"
    }
    
    func configure(_ pagesAvailable:Bool) {
        if pagesAvailable {
            startAnimating()
        } else {
            showBanner()
        }
    }
    
    fileprivate func resetSubviews() {
        backgroundColor = UIColor.clear
        imageView.image = UIImage(named: "explorer_frame")
        loadingView.isHidden = true
        messageLabel.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        messageLabel.isHidden = true
        imageView.isHidden = true
    }
}

class LoadingView: UIView {
    let size: CGFloat
    
    internal var colorCircle = StyleGuide.secondaryTextColor
    internal let circleView = UIActivityIndicatorView(style: .whiteLarge)
    
    convenience init() {
        self.init(size: 50, linewidth: 2.0, colorImage: UIColor.darkGray, colorCircle: UIColor.darkGray)
    }
    
    init(size:CGFloat, linewidth:CGFloat, colorImage:UIColor, colorCircle:UIColor) {
        self.colorCircle = colorCircle
        self.size = size
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        
        configureView()
        configureConstraints()
    }
    
    override func didMoveToSuperview() {
        if let superview = superview {
            translatesAutoresizingMaskIntoConstraints = false
            var constraints: [NSLayoutConstraint] = []
            constraints.append(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0.0))
            constraints.append(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: 0.0))
            NSLayoutConstraint.activate(constraints)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        backgroundColor = UIColor.clear
        circleView.color = colorCircle
        addSubview(circleView)
    }
    
    func configureConstraints() {
        circleView.centerInSuperview()
    }

    func startAnimating() {
        circleView.startAnimating()
    }
    
    func stopAnimating() {
        circleView.stopAnimating()
    }
    
    func isAnimating() -> Bool {
        return circleView.isAnimating
    }
}
