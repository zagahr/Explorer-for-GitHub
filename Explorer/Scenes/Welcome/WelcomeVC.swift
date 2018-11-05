//
//  WelcomeVC.swift
//  Explorer
//
//  Created by Zagahr on 26.08.18.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {
    
    weak var viewModel: WelcomeViewModel!
    
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    func configureView() {
        view.backgroundColor = StyleGuide.primaryBackgoundColor
        descriptionLabel.textColor = StyleGuide.primaryTextColor
        skipButton.tintColor = StyleGuide.highlightColor
        loginButton.backgroundColor = StyleGuide.highlightColor
        loginButton.layer.cornerRadius = 5
    }
    
    @IBAction func didSelectLoginButton(_ sender: Any) {
        viewModel.login()
    }
    
    @IBAction func didSelectSkipButton(_ sender: Any) {
        viewModel.skip()
    }
}
