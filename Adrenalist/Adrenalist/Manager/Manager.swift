//
//  Manager.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/24.
//

import Combine
import Foundation

final class FavoriteManager {
    static let shared = FavoriteManager()
    
    private let defaults = UserDefaults.standard
    
    enum Key {
        static let favorites = "favorites"
    }
    
    func save(_ workouts: [WorkoutModel]) {
        do {
            let encoder = JSONEncoder()
            let encodedFavorties = try encoder.encode(workouts)
            defaults.setValue(encodedFavorties, forKey: Key.favorites)
        } catch {
            print(error)
        }
    }
    
    func retrieve() -> AnyPublisher<[WorkoutModel], Error> {
        guard
            let data = defaults.object(forKey: Key.favorites) as? Data
        else { return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()}
        
        do {
            let decoder = JSONDecoder()
            let workouts = try decoder.decode([WorkoutModel].self, from: data)
            return Just(workouts).setFailureType(to: Error.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}

final class Manager {
    static let shared = Manager()
    
    private let defaults = UserDefaults.standard
    
    enum Key {
        static let workoutResponse = "workoutResponse"
    }
    
    func save(_ workoutResponse: [WorkoutResponse]) {
        do {
            let encoder = JSONEncoder()
            let encodedFavorties = try encoder.encode(workoutResponse)
            defaults.setValue(encodedFavorties, forKey: Key.workoutResponse)
        } catch {
            print(error)
        }
    }
    
    func retrieve() -> AnyPublisher<[WorkoutResponse], Error> {
        guard
            let data = defaults.object(forKey: Key.workoutResponse) as? Data
        else { return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()}
        
        do {
            let decoder = JSONDecoder()
            let workouts = try decoder.decode([WorkoutResponse].self, from: data)
            return Just(workouts).setFailureType(to: Error.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
