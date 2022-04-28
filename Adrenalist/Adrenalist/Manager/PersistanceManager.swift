//
//  PersistanceManager.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/28.
//

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
//            return Just(.successful).setFailureType(to: .self).eraseToAnyPublisher()
        } catch {
//            return Fail(error: .error).eraseToAnyPublisher()
        }
    }
    
    func retrieveWorkouts() -> [Workout] {
        guard let data = defaults.object(forKey: Keys.workouts) as? Data else { return [] }
        
        do {
            let decoder = JSONDecoder()
            let workouts = try decoder.decode([Workout].self, from: data)
            return workouts
        } catch {
            return []
        }
    }
}
