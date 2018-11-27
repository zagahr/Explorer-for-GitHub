//
//  SettingsViewModel.swift
//  Explorer
//
//  Created by Zagahr on 20/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import Foundation


enum Settings: CaseIterable {
    case personal
    case explorer
    
    var title: String {
        switch self {
        case .personal:
            return "Personal"
        case .explorer:
            return "Explorer"
        }
    }
    
    var entrys: [Entry] {
        switch self {
        case .personal:
            return [.language]
        case .explorer:
            return [.writeReview, .tellFriend, .licenses ]
        }
    }
    
    enum Entry {
        case language, tellFriend, licenses, writeReview
        
        var title: String {
            switch self {
            case .language:
                return "Pferrered Language"
            case .writeReview:
                return "Write a Review"
            case .tellFriend:
                return "Tell a Friend"
            case .licenses:
                return "Licences/Credits"
            }
        }
    }
}


final class SettingsViewModel {
    weak var coordinatorDelegate: SettingsCoordinatorDelegate?
    
    var numberOfSections: Int {
        return Settings.allCases.count
    }
    
    func titleFor(section: Int) -> String {
        return Settings.allCases.indices.contains(section) ? Settings.allCases[section].title : ""
    }
    
    func numberOfRows(at section: Int) -> Int {
        return Settings.allCases.indices.contains(section) ? Settings.allCases[section].entrys.count : 0
    }
    
    func model(at index: IndexPath) -> Settings.Entry {
        guard let settings = Settings.allCases[safe: index.section] else { fatalError("Section out of bounds") }
        guard let entry = settings.entrys[safe: index.row] else { fatalError("Index out of bounds") }
        
        return entry
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        guard let entry = Settings.allCases[safe: indexPath.section]?.entrys[safe: indexPath.row] else { return }
        
        switch entry {
        case .language:
            coordinatorDelegate?.showLanguageSelect()
        case .tellFriend:
            coordinatorDelegate?.showRecommendApp()
        case .licenses:
            coordinatorDelegate?.showLicences()
        case .writeReview:
            coordinatorDelegate?.writeReview()
        }
    }
}
