//
//  LanguageListViewController.swift
//  Explorer
//
//  Created by Zagahr on 20/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import UIKit

class LanguageListViewController: UITableViewController {

    
    let languages: [Language] = RCValues.shared.languages
    let currentLanguage = UserCoordinator.shared.user?.language
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Select preferred Language"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath) as? LanguageCell else{
            return UITableViewCell()
        }

        let language = languages[indexPath.row]
        
        if let currentLanguage = currentLanguage {
            if currentLanguage.urlParam == language.urlParam {
                cell.accessoryType = .checkmark
            }
        }
        
        cell.configureView(with: language)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let language = languages[indexPath.row]
        
        UserCoordinator.shared.update(language: language)
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "LanguageChangedNotification")))
        self.navigationController?.popViewController(animated: true)
    }
}

final class LanguageCell: UITableViewCell {
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var languageColorView: UIView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        accessoryType = .none
    }
    
    func configureView(with model: Language) {
        languageLabel.textColor = StyleGuide.primaryTextColor
        languageLabel.font = UIFont.systemFont(ofSize: 14)
        languageLabel.text = model.name
        languageColorView.backgroundColor = UIColor().colorWithHexString(hexString: model.color)
        languageColorView.layer.cornerRadius = languageColorView.frame.size.width / 2
    }
    
}
