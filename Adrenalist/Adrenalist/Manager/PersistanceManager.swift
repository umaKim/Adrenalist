//
//  PersistanceManager.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/28.
//

import Combine
import Foundation

final class PersistanceManager {
    static let shared = PersistanceManager()
    private let defaults = UserDefaults.standard
    enum Keys {
        static let workouts = "workouts"
    }
    
    func saveWorkouts(_ workouts: [Workout]) {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(workouts)
            defaults.setValue(encodedFavorites, forKey: Keys.workouts)
        } catch {
            print(error)
        }
    }
    
    func retrieveWorkouts() -> AnyPublisher<[Workout], Error> {
        guard let data = defaults.object(forKey: Keys.workouts) as? Data else {
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
}
