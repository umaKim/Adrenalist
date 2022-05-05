//
//  WhatToDoManager.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/29.
//
import Combine
import UIKit

enum DataType {
    case main, suggestions
}

final class ItemManager {
    static let shared = ItemManager()
    
    @Published private(set) var suggestions: [Item] = []
    @Published private(set) var itemToDos: [Item] = []
    
    //MARK: - Public
    public func updateItemToDos(_ workouts: [Item]) {
        self.itemToDos = workouts
        self.save(workouts, for: .main)
    }
    
    public func updateSuggestions(_ suggestions: [Item]) {
        self.suggestions = suggestions
        self.save(suggestions, for: .suggestions)
    }
    
    //MARK: - Privates
    
    private let defaults = UserDefaults.standard
    private enum Keys {
        static let workouts = "workouts"
        static let suggestions = "suggestions"
    }
    
    private func save(_ workouts: [Item], for type: DataType) {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(workouts)
            defaults.setValue(encodedFavorites, forKey: type == .main ? Keys.workouts : Keys.suggestions)
        } catch {
            print(error)
        }
    }
    
    private func retrieve(_ type: DataType) -> AnyPublisher<[Item], Error> {
        guard let data = defaults.object(forKey: type == .main ? Keys.workouts : Keys.suggestions) as? Data else {
            return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        do {
            let decoder = JSONDecoder()
            let workouts = try decoder.decode([Item].self, from: data)
            return Just(workouts).setFailureType(to: Error.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    private var cancellables: Set<AnyCancellable>
    
    private init() {
        self.cancellables = .init()
        
        self.retrieve(.suggestions)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print("finished")
                }
            } receiveValue: { workouts in
                self.suggestions = workouts
            }
            .store(in: &cancellables)
        
        self.retrieve(.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { workouts in
                self.itemToDos = workouts
            }
            .store(in: &cancellables)
    }
}
