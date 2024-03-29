//
//  FavoriteDetailViewModel.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/26.
//
import Combine
import Foundation

enum FavoriteDetailViewModelNotification {
    case reload
}

class FavoriteDetailViewModel {
    
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<FavoriteDetailViewModelNotification, Never>()
    
    private let favoriteSetManager = FavoriteSetManager.shared
    
    private(set) var favorites = [WorkoutResponse]()
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        
        favoriteSetManager
            .$favorites
            .receive(on: RunLoop.main)
            .sink {[weak self] favorites in
                guard let self = self else { return }
                self.favorites = favorites
                self.notifySubject.send(.reload)
            }
            .store(in: &cancellables)
    }
    
    func retrieve() {
        
    }
    
    var status: FavoriteCollectionViewCellStatus = .usual
    
    public func deleteItem(at index: Int) {
        favoriteSetManager.delete(favoriteAt: index)
        notifySubject.send(.reload)
    }
}
