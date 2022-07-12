//
//  Manager.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/24.
//

import Combine
import Foundation

final class FavoriteSetManager {
    static let shared = FavoriteSetManager()
    
    private let defaults = UserDefaults.standard
    
    enum Key {
        static let favorites = "favorites"
    }
    
//    @Published private(set) var favorites = [WorkoutModel]()
    @Published private(set) var favorites = [WorkoutResponse]()
    
    func setFavorites(_ favorites: [WorkoutResponse]) {
        self.favorites = favorites
        self.save(favorites)
    }
    
    func addFavorites(_ favorite: WorkoutResponse) {
        self.favorites.append(favorite)
        self.save(favorites)
    }
    
    func addWorkouts(with workouts: [WorkoutModel], of favorite: WorkoutResponse) {
        guard let index = favorites.firstIndex(of: favorite) else { return }
        favorites[index].workouts.append(contentsOf: workouts)
        self.save(favorites)
    }
    
    func setWorkout(with workout: WorkoutModel, of favorite: WorkoutResponse) {
        guard
            let index = favorites.firstIndex(of: favorite),
            let workoutIndex = favorites[index].workouts.firstIndex(where: {$0.uuid == workout.uuid})
        else { return }
        favorites[index].workouts[workoutIndex] = workout
        self.save(favorites)
    }
    
    func setWorkouts(with workouts: [WorkoutModel], of favorite: WorkoutResponse) {
        guard
            let index = favorites.firstIndex(of: favorite)
        else { return }
        favorites[index].workouts = workouts
        self.save(favorites)
    }
    
    private func save(_ workouts: [WorkoutResponse]) {
        do {
            let encoder = JSONEncoder()
            let encodedFavorties = try encoder.encode(workouts)
            defaults.setValue(encodedFavorties, forKey: Key.favorites)
        } catch {
            print(error)
        }
    }
    
    private func retrieve() -> AnyPublisher<[WorkoutResponse], Error> {
        guard
            let data = defaults.object(forKey: Key.favorites) as? Data
        else { return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()}
        
        do {
            let decoder = JSONDecoder()
            let workouts = try decoder.decode([WorkoutResponse].self, from: data)
            return Just(workouts).setFailureType(to: Error.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    private var cancellables: Set<AnyCancellable>
    
    private init() {
        self.cancellables = .init()
        
        retrieve()
            .sink { completion in
                
            } receiveValue: { favorites in
                self.favorites = favorites
            }
            .store(in: &cancellables)
    }
}

final class Manager {
    static let shared = Manager()
    
    private let defaults = UserDefaults.standard
    
    enum Key {
        static let workoutResponse = "workoutResponse"
    }
    
    @Published private(set) var selectedDate = Date().stripTime()
    @Published private(set) var workoutDates = [Date]()
    @Published private(set) var workoutlist = [WorkoutModel]()
    private(set) var workoutResponses = [WorkoutResponse]()
    
    func selectedWorkoutlist(of date: Date) {
        self.selectedDate = date.stripTime()
        self.workoutlist = workoutResponses
            .filter({$0.date == date.stripTime()})
            .flatMap({$0.workouts})
    }
    
    func setWorkoutlist(with workoutlist: [WorkoutModel]) {
        self.workoutlist = workoutlist
        self.setResponse(with: workoutlist)
    }
    
    func addWorkout(with workout: WorkoutModel) {
        self.workoutlist.append(workout)
        self.setResponse(with: workoutlist)
    }
    
    private func setWorkoutDates() {
        self.workoutDates = workoutResponses.compactMap({$0.date})
    }
    
    private func setResponse(with workoutlist: [WorkoutModel]) {
        // when new Response still exist
        if let index = workoutResponses.firstIndex(where: {$0.date == selectedDate.stripTime()}) {
            if workoutlist.isEmpty {
                self.workoutResponses.remove(at: index)
            } else {
                self.workoutResponses[index].workouts = workoutlist
            }
        } else {
            // when new Response is Required
            let newResponse = WorkoutResponse(date: selectedDate, workouts: workoutlist)
            self.workoutResponses.append(newResponse)
        }
        self.save(workoutResponses)
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
    
    private var cancellables: Set<AnyCancellable>
    
    private init() {
        self.cancellables = .init()
        
        retrieve()
            .sink { completion in
                
            } receiveValue: { responses in
                self.workoutResponses = responses
                self.selectedWorkoutlist(of: self.selectedDate)
                self.setWorkoutDates()
            }
            .store(in: &cancellables)
    }
}
