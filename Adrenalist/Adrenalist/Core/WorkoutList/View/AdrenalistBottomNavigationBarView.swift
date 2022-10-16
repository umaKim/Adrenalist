//
//  AdrenalistBottomNavigationBarView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/20.
//
import Combine
import UIKit

struct AdrenalistBottomNavigationBarViewConfigurator {
    let height: CGFloat
    let backgroundColor: UIColor
    
    init(height: CGFloat, backgroundColor: UIColor) {
        self.height = height
        self.backgroundColor = backgroundColor
    }
}

enum AdrenalistBottomNavigationBarViewScreenType {
    case modal, overallFullScreen
}

enum AdrenalistBottomNavigationBarViewType {
    case delete, normal, createSet, done
}

enum AdrenalistBottomNavigationBarViewAction {
    case createSet
    case delete
    case cancel
    case done
}

class AdrenalistBottomNavigationBarView: UIView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<AdrenalistBottomNavigationBarViewAction, Never>()
    
    private var cancellables: Set<AnyCancellable>
    
    
    private lazy var cancelButton: UIButton = {
       let bt = UIButton()
        bt.setTitle("Cancel", for: .normal)
        bt.setTitleColor(.purpleBlue, for: .normal)
        return bt
    }()
    
    private let deleteButton: UIButton = {
       let bt = UIButton()
        bt.setTitle("Delete", for: .normal)
        bt.setTitleColor(.red, for: .normal)
        return bt
    }()
    
    private let createSetButton: UIButton = {
       let bt = UIButton()
        bt.setTitle("Create", for: .normal)
        bt.setTitleColor(.purpleBlue, for: .normal)
        return bt
    }()
    
    private let moveButton: UIButton = {
       let bt = UIButton()
        bt.setTitle("Move", for: .normal)
        bt.setTitleColor(.purpleBlue, for: .normal)
        return bt
    }()
    
    private let doneButton: UIButton = {
       let bt = UIButton()
        bt.setTitle("Done", for: .normal)
        bt.setTitleColor(.purpleBlue, for: .normal)
        return bt
    }()
    
    private var sv: UIStackView = UIStackView()
    
    init(
        configurator: AdrenalistBottomNavigationBarViewConfigurator
    ) {
        self.cancellables = .init()
        super.init(frame:
                .init(x: 0,
                      y: UIScreen.main.height,
                      width: UIScreen.main.width,
                      height: configurator.height))
        
        self.backgroundColor = configurator.backgroundColor
        
        bind()
        setupUI()
    }
    
    private var screenType: AdrenalistBottomNavigationBarViewScreenType = .overallFullScreen
    
    func show(
        _ type: AdrenalistBottomNavigationBarViewType,
        _ screenType: AdrenalistBottomNavigationBarViewScreenType = .overallFullScreen
    ) {
        self.screenType = screenType
        
        sv.subviews.forEach { uv in
            uv.removeFromSuperview()
        }
        
        sv.addArrangedSubview(cancelButton)
        
        switch type {
        case .delete:
            sv.addArrangedSubview(deleteButton)
            
        case .normal:
            sv.addArrangedSubview(UIView())
            
        case .createSet:
            sv.addArrangedSubview(createSetButton)
            
        case .done:
            cancelButton.removeFromSuperview()
            sv.addArrangedSubview(UIView())
            sv.addArrangedSubview(doneButton)
        }
        
        self.showBottomNavigationView()
    }
    
    private func bind() {
        cancelButton.tapPublisher.sink {[weak self] _ in
            guard let self = self else { return }
            self.actionSubject.send(.cancel)
            self.hideBottomNavigationView()
        }
        .store(in: &cancellables)
        
        createSetButton.tapPublisher.sink {[weak self] _ in
            guard let self = self else { return }
            self.actionSubject.send(.createSet)
        }
        .store(in: &cancellables)
        
        deleteButton.tapPublisher.sink {[weak self] _ in
            guard let self = self else { return }
            self.actionSubject.send(.delete)
            self.hideBottomNavigationView()
        }
        .store(in: &cancellables)
        
        doneButton.tapPublisher.sink {[weak self] _ in
            guard let self = self else { return }
            self.actionSubject.send(.done)
            self.hideBottomNavigationView()
        }
        .store(in: &cancellables)
    }
    
    private func setupUI() {
        sv.axis = .horizontal
        sv.distribution = .equalCentering
        sv.alignment = .center
        sv.spacing = 8
        
        [sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            sv.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
        ])
    }
    
    private func showBottomNavigationView() {
        let window = UIApplication.shared.windows.first
        let bottomPadding = window?.safeAreaInsets.bottom
        
        var buttonHeight: CGFloat = 0.0
        
        switch screenType {
        case .modal:
            buttonHeight = 64 * 2
            
        case .overallFullScreen:
            buttonHeight = 64
        }
        
        let safeAreaPadding = bottomPadding
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            self.frame.origin = .init(x: 0, y: UIScreen.main.height - buttonHeight - safeAreaPadding!)
        } completion: { _ in }
    }
    
    func hideBottomNavigationView() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            self.frame.origin = .init(x: 0, y: UIScreen.main.height)
        } completion: { _ in }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
