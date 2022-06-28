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
    
    private func save(_ workoutResponse: [WorkoutResponse]) {
        do {
            let encoder = JSONEncoder()
            let encodedFavorties = try encoder.encode(workoutResponse)
            defaults.setValue(encodedFavorties, forKey: Key.workoutResponse)
        } catch {
            print(error)
        }
    }
    
    private func retrieve() -> AnyPublisher<[WorkoutResponse], Error> {
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
    
//    public func updateByAdding(_ workoutResponse: WorkoutResponse) {
////        self.workoutResponses.append(workoutResponse)
//        self.save(workoutResponse)
//    }
    
    public func updateByReplacing(_ workoutResponses: [WorkoutResponse]) {
//        self.workoutResponses = workoutResponses
        self.save(workoutResponses)
    }
    
    public func updateCetainWorkouts(_ workouts: [WorkoutModel]) {
        
    }
    
//    private(set) var workoutRes = PassthroughSubject<([WorkoutResponse], Date), Never>()
    
//    @Published private(set) var workoutResponses = [WorkoutResponse]()
    
//    private(set) var selectedWorkouts = PassthroughSubject<([WorkoutResponse], selectedDate), Never>()
    
    typealias selectedDate = Date
    
    @Published private(set) var selectedWorkouts: ([WorkoutResponse], selectedDate) = ([], Date().stripTime())
    
//    @Published private(set) var selectedDate = Date().stripTime()
//
//    func setSelectedDate(_ date: Date) {
//        selectedDate = date
//    }
    
    func sendSelectedDateWorkout(_ workouts: [WorkoutResponse], date: Date) {
//        self.selectedWorkouts.send((workouts, date))
        self.selectedWorkouts = (workouts, date)
    }
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        
        retrieve()
            .receive(on: RunLoop.main)
            .sink { completion in

            } receiveValue: { responses in
                self.sendSelectedDateWorkout(responses, date: Date().stripTime())
            }
            .store(in: &cancellables)
    }
}
