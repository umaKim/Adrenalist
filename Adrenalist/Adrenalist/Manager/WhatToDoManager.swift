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

    @Published private(set) var suggestions: [WorkoutModel] = []
    @Published private(set) var itemToDos: [WorkoutModel] = []

    //MARK: - Public
    public func appendWorkoutToDos(_ workout: WorkoutModel) {
        self.itemToDos.append(workout)
        self.save(itemToDos, for: .workouts)
    }

    public func updateWorkoutToDos(_ workouts: [WorkoutModel]) {
        self.itemToDos = workouts
        self.save(workouts, for: .workouts)
    }

    public func appendSuggetion(_ suggestion: WorkoutModel) {
        self.suggestions.append(suggestion)
        self.save(suggestions, for: .suggestions)
    }

    public func updateSuggestions(_ suggestions: [WorkoutModel]) {
        self.suggestions = suggestions
        self.save(suggestions, for: .suggestions)
    }

    public func fetchWorkoutlist(at date: Date) {
//        self.fetchWorkoutlist(at: date)
        self.retrieve(.workouts)
    }

    //MARK: - Privates

    private let defaults = UserDefaults.standard
    private enum Keys {
        static let workouts = "workouts"
        static let suggestions = "suggestions"
        static let history = "history"
    }

    private func save(_ workouts: [WorkoutModel], for type: DataType) {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(workouts)
            defaults.setValue(encodedFavorites, forKey: type.rawValue)
        } catch {
            print(error)
        }
    }

    private func retrieve(_ type: DataType) -> AnyPublisher<[WorkoutModel], Error> {
        guard
            let data = defaults.object(forKey: type.rawValue) as? Data
        else {
            return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        do {
            let decoder = JSONDecoder()
            let workouts = try decoder.decode([WorkoutModel].self, from: data)
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


final class WorkoutManager {
    static let shared = WorkoutManager()

    private let defaults = UserDefaults.standard

    @Published private(set) var favorites: [WorkoutModel] = []
    @Published private(set) var workoutList: [WorkoutModel] = []

    //------->
    func saveWorkoutList(_ workout: WorkoutResponse) {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(workout.workouts)
            defaults.setValue(encodedFavorites, forKey: workout.date.description)
        } catch {
            print(error)
        }
    }

    func retrieveWorkoutList(of date: Date) -> AnyPublisher<[WorkoutModel], Error> {
        guard let data = defaults.object(forKey: date.description) as? Data else {
            return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        do {
            let decoder = JSONDecoder()
            let workouts = try decoder.decode([WorkoutModel].self, from: data)
            return Just(workouts).setFailureType(to: Error.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    func saveFavorite(of workouts: [WorkoutModel])   {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(workouts)
            defaults.setValue(encodedFavorites, forKey: "favorites")
        } catch {
            print(error)
        }
    }

    func retrieveFavorites() -> AnyPublisher<[WorkoutModel], Error> {
        guard let data = defaults.object(forKey: "favorites") as? Data else {
            return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        do {
            let decoder = JSONDecoder()
            let workouts = try decoder.decode([WorkoutModel].self, from: data)
            return Just(workouts).setFailureType(to: Error.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    init() {

    }
}
