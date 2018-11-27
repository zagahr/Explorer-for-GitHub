//
//  RCValues.swift
//  Explorer
//
//  Created by Zagahr on 17/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

class RCValues {
    static let shared = RCValues()
    var loadingDoneCallback: (() -> Void)?
    var fetchComplete = false
    var languages: [Language] = []
    
    enum ValueKey: String {
        case contributeDefault
    }
    
    private init() {
        loadDefaultValues()
        fetchColudValues()
    }
    
    func loadDefaultValues() {
        languages = loadLanguages(filename: "languages")
        let contributeContentValues = loadDefaultModels(filename: ValueKey.contributeDefault.rawValue)
            
        let appDefaults: [String: Any?] = [
            "appPrimaryColor": "#FBB03B",
            ValueKey.contributeDefault.rawValue: contributeContentValues
        ]
        
        RemoteConfig.remoteConfig().setDefaults(appDefaults as? [String: NSObject])
    }
    
    func fetchColudValues() {
        let fetchDuration: TimeInterval = 0
        activateDebugMode()
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: fetchDuration) { [weak self] (status, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            RemoteConfig.remoteConfig().activateFetched()
            
            self?.fetchComplete = true
            self?.loadingDoneCallback?()
        }
    }
    
    func contributeContent() -> [ContributeModel] {
        let values = RemoteConfig.remoteConfig()[ValueKey.contributeDefault.rawValue].dataValue
        let decoder = JSONDecoder()
        
        if var models = try? decoder.decode([ContributeModel].self, from: values) {
            return replaceLanguageTemplate(models: &models)
        } else {
            var models =  loadDefaultModels(filename: ValueKey.contributeDefault.rawValue)
            return replaceLanguageTemplate(models: &models)
        }
    }
    
    func replaceLanguageTemplate(models: inout [ContributeModel]) -> [ContributeModel] {
        let preferredLanguageTitle = UserCoordinator.shared.user?.language.name ?? "Swift"
        let preferredLanguageQuery = preferredLanguageTitle
        
        
        models = models.compactMap({( model) -> ContributeModel in
            var copy = model
            copy.replaceQyeryPlaceholder(value: preferredLanguageQuery)
            copy.replaceTitlePlaceholder(value: preferredLanguageTitle)
            
            return copy
        })
        
        return models
    }
    
    func activateDebugMode() {
        let debugSettings = RemoteConfigSettings(developerModeEnabled: true)
        RemoteConfig.remoteConfig().configSettings = debugSettings
    }
    
    func loadDefaultModels(filename fileName: String) -> [ContributeModel] {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([ContributeModel].self, from: data)
                return jsonData
            } catch {
                fatalError("Could not load default values")
            }
        }
        fatalError("Could not load default values")
    }
    
    func loadLanguages(filename fileName: String) -> [Language] {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Language].self, from: data)
                return jsonData
            } catch {
                fatalError("Could not load default values")
            }
        }
        fatalError("Could not load default values")
    }
}

struct ContributeModel: Codable {
    var title: String
    var query: String
    var repositories: [RepositoryModel]
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        query = try values.decode(String.self, forKey: .query)
        repositories = []
    }
    
    mutating func replaceTitlePlaceholder(value: String) {
        self.title = title.replacingOccurrences(of: "{language}", with: value)
    }
    
    mutating func replaceQyeryPlaceholder(value: String) {
        self.query = query.replacingOccurrences(of: "{language}", with: value)
    }
    
    mutating func addRepositories(_ repositories: [RepositoryModel]) {
        self.repositories.append(contentsOf: repositories)
    }
}
