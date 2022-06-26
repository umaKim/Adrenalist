//
//  FavoriteDetailView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/26.
//
import CombineCocoa
import Combine
import UIKit

enum FavoriteDetailViewAction {
    case dismiss
}

class FavoriteDetailView: UIView {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<FavoriteDetailViewAction, Never>()
    
    private(set) lazy var backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: nil, action: nil)
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        bind()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        backButton.tapPublisher.sink { _ in
            self.actionSubject.send(.dismiss)
        }.store(in: &cancellables)
    }
    
    private func setupUI() {
        
    }
}
