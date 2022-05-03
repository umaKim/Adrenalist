//
//  WhatToDoManager.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/29.
//
import Combine
import UIKit

enum DataType {
    case workouts, suggestions
}

final class WorkoutManager {
    static let shared = WorkoutManager()
    
    @Published private(set) var suggestions: [Workout] = []
    @Published private(set) var workOutToDos: [Workout] = []
    
    //MARK: - Public
    public func updateWorkoutToDos(_ workouts: [Workout]) {
        self.workOutToDos = workouts
        self.save(workouts, for: .workouts)
    }
    
    public func updateSuggestions(_ suggestions: [Workout]) {
        self.suggestions = suggestions
        self.save(suggestions, for: .suggestions)
    }
    
    //MARK: - Privates
    
    private let defaults = UserDefaults.standard
    private enum Keys {
        static let workouts = "workouts"
        static let suggestions = "suggestions"
    }
    
    private func save(_ workouts: [Workout], for type: DataType) {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(workouts)
            defaults.setValue(encodedFavorites, forKey: type == .workouts ? Keys.workouts : Keys.suggestions)
        } catch {
            print(error)
        }
    }
    
    private func retrieve(_ type: DataType) -> AnyPublisher<[Workout], Error> {
        guard let data = defaults.object(forKey: type == .workouts ? Keys.workouts : Keys.suggestions) as? Data else {
            return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        do {
            let decoder = JSONDecoder()
            let workouts = try decoder.decode([Workout].self, from: data)
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
        
        self.retrieve(.workouts)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { workouts in
                self.workOutToDos = workouts
            }
            .store(in: &cancellables)
    }
}
