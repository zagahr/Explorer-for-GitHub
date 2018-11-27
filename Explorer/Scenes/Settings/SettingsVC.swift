//
//  SettingsVC.swift
//  Explorer
//
//  Created by Zagahr on 20/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import UIKit

class SettingsVC: UITableViewController {
    lazy var footerView = LoadingFooterView()
    
    weak var viewModel: SettingsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }
    
    func configureView() {
        title = "Settings"
        footerView.frame.size = CGSize(width: footerView.frame.width, height: 200)
        footerView.showFooterWithVersion()
    }
    
    func configureTableView() {
        tableView.tableFooterView = footerView
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(at: section)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleFor(section: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectCell(at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? SettingsTableViewCell else { return }
        
        let model = viewModel.model(at: indexPath)
        cell.configureView(with: model)
    }
}

final class SettingsTableViewCell: UITableViewCell {
    lazy var stackView = UIStackView()
    lazy var titleLabel = UILabel()
    
    static let identifier = "SettingsTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        stackView.subviews.forEach { $0.removeFromSuperview()}
    }
    
    private func configureView() {
        addSubview(stackView)
        stackView.spacing = 3
    }
    
    private func configureConstraints() {
        let right: CGFloat = accessoryType != .none ? 35 : 15
        
        stackView.edgesToSuperview(insets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: right))
    }
    
    func configureView(with entry: Settings.Entry) {
        titleLabel.textColor = StyleGuide.primaryTextColor
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        stackView.addArrangedSubview(titleLabel)
        titleLabel.text = entry.title
        
        switch entry {
            case .language:
                configureLanguage()
            case .licenses:
                accessoryType = .disclosureIndicator
            case .tellFriend:
                let image = UIImage(named: "share")
                configure(image: image)
            case .writeReview:
                let image = UIImage(named: "compose")
                configure(image: image)
            }
        
        configureConstraints()
    }
    
    private func configureLanguage() {
        let language = UserCoordinator.shared.user?.language
        
        self.accessoryType = .disclosureIndicator
        let label = UILabel()
        label.text = language?.name ?? "Select"
        label.textColor = StyleGuide.primaryTextColor
        label.font = UIFont.systemFont(ofSize: 12)
        
        let languageContainer = UIView()
        languageContainer.width(15)

        let languageColorView = UIView()
        languageContainer.addSubview(languageColorView)
        
        if let language = language {
            languageColorView.backgroundColor = UIColor().colorWithHexString(hexString: language.color)
        } else {
            languageColorView.backgroundColor = .white
        }
        
        languageColorView.centerInSuperview()
        languageColorView.width(8)
        languageColorView.height(8)
        languageColorView.layer.cornerRadius = 4
        
        stackView.addArrangedSubview(languageContainer)
        stackView.addArrangedSubview(label)
    }
    
    private func configure(image: UIImage?) {
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor(red:0.64, green:0.64, blue:0.64, alpha:1.0)
        imageView.contentMode = .scaleAspectFit
        imageView.width(20)
        stackView.addArrangedSubview(imageView)
    }
}
