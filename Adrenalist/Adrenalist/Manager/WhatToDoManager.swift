//
//  WhatToDoManager.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/29.
//
import Combine
import UIKit

enum DataType: String {
    case workouts = "workouts"
    case suggestions = "suggestions"
    case history = "history"
}

final class ItemManager {
    static let shared = ItemManager()
    
    @Published private(set) var suggestions: [Item] = []
    @Published private(set) var itemToDos: [Item] = []
    
    //MARK: - Public
    public func appendWorkoutToDos(_ workout: Item) {
        self.itemToDos.append(workout)
        self.save(itemToDos, for: .workouts)
    }
    
    public func updateWorkoutToDos(_ workouts: [Item]) {
        self.itemToDos = workouts
        self.save(workouts, for: .workouts)
    }
    
    public func appendSuggetion(_ suggestion: Item) {
        self.suggestions.append(suggestion)
        self.save(suggestions, for: .suggestions)
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
        static let history = "history"
    }
    
    private func save(_ workouts: [Item], for type: DataType) {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(workouts)
            defaults.setValue(encodedFavorites, forKey: type.rawValue)
        } catch {
            print(error)
        }
    }
    
    private func retrieve(_ type: DataType) -> AnyPublisher<[Item], Error> {
        guard let data = defaults.object(forKey: type.rawValue) as? Data else {
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
        
        bind()
    }
    
    private func bind() {
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
        
        self.retrieve(.workouts)
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
