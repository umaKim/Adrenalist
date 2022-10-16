//
//  SetupFavoriteSetView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/07/12.
//

import Combine
import CombineCocoa
import UIKit.UIView

enum SetupFavoriteSetViewAction {
    case dismiss
    case confirm
    case delete
    case addNewWorkout
    
    case titleTextFieldDidChange(String)
    
    case bottomSheetDidTapDelete
    case bottomSheetDidTapCancel
    
    case titleTextFieldViewDidDismissKeyboard
}

class SetupFavoriteSetView: UIView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SetupFavoriteSetViewAction, Never>()
    
    private var cancellables: Set<AnyCancellable>
    
    private(set) lazy var confirmButton: UIBarButtonItem = {
        let bt = UIBarButtonItem(title: "Done", style: .done, target: nil, action: nil)
        bt.tintColor = .purpleBlue
        return bt
    }()
    
    private(set) lazy var dismissButton: UIBarButtonItem = {
        let bt = UIBarButtonItem(title: "Cancel", style: .done, target: nil, action: nil)
        bt.tintColor = .purpleBlue
        return bt
    }()
    
    private(set) lazy var deleteButton: UIBarButtonItem = {
        let bt = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: nil, action: nil)
        bt.tintColor = .purpleBlue
        return bt
    }()
    
    private(set) lazy var addButton: UIBarButtonItem = {
        let bt = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: nil, action: nil)
        bt.tintColor = .purpleBlue
        return bt
    }()
    
    private lazy var titleTextField = AdrenalistTitleView(placeholder: "Set name")
    
    private(set) lazy var workoutListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .darkNavy
        cv.register(WorkoutlistCollectionViewCell.self, forCellWithReuseIdentifier: WorkoutlistCollectionViewCell.identifier)
        cv.contentInset = .init(top: 0, left: 0, bottom: UIScreen.main.height / 4, right: 0)
        return cv
    }()
    private lazy var bottomNavigationView = AdrenalistBottomNavigationBarView(configurator: .init(height: 110,
                                                                                                  backgroundColor: .lightDarkNavy))
    
    private func dismissBottomNavigationView() {
        self.bottomNavigationView.hideBottomNavigationView()
    }
    
    var isModal: Bool = false
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        bind()
        setupUI()
    }
    
    public func setSetName(_ text: String) {
        self.titleTextField.setupTitleTextField(text)
    }
    
    private func bind() {
        titleTextField.actionPublisher.sink {[weak self] action in
            guard let self = self else { return }
            switch action {
            case .titleTextFieldDidChange(let text):
                self.actionSubject.send(.titleTextFieldDidChange(text))
                
            case .done:
                self.actionSubject.send(.titleTextFieldViewDidDismissKeyboard)
            }
        }
        .store(in: &cancellables)
        
        confirmButton.tapPublisher.sink {[weak self] _ in
            guard let self = self else { return }
            self.actionSubject.send(.confirm)
        }
        .store(in: &cancellables)
        
        dismissButton.tapPublisher.sink {[weak self] _ in
            guard let self = self else { return }
            self.actionSubject.send(.dismiss)
        }
        .store(in: &cancellables)
        
        deleteButton.tapPublisher.sink {[weak self] _ in
            guard let self = self else { return }
            self.actionSubject.send(.delete)
            self.bottomNavigationView.show(.delete,
                                           self.isModal ? .modal : .overallFullScreen)
//            self.showBottomNavigationView()
        }
        .store(in: &cancellables)
        
        addButton.tapPublisher.sink {[weak self] _ in
            guard let self = self else { return }
            self.actionSubject.send(.addNewWorkout)
        }
        .store(in: &cancellables)
        
        bottomNavigationView
            .actionPublisher
            .sink { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .delete:
                    self.actionSubject.send(.bottomSheetDidTapDelete)
                    
                case .cancel:
                    self.actionSubject.send(.bottomSheetDidTapCancel)
                    self.dismissBottomNavigationView()
                    
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
//    
//    private func showBottomNavigationView() {
//        let window = UIApplication.shared.windows.first
//        let bottomPadding = window?.safeAreaInsets.bottom
//
//        print(64 + bottomPadding! + 16)
//
//        let buttonHeight: CGFloat = 64
//        let safeAreaPadding = bottomPadding
//
//        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
//            self.bottomNavigationView.frame.origin = .init(x: 0, y: UIScreen.main.height - buttonHeight - safeAreaPadding!)
//        } completion: { _ in }
//        
//        print(UIScreen.main.height - buttonHeight - safeAreaPadding!)
//    }
    
    private func setupUI() {
        backgroundColor = .darkNavy
        
        let sv = UIStackView(arrangedSubviews: [titleTextField, workoutListCollectionView])
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 32
        
        [sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        addSubview(bottomNavigationView)
        
        NSLayoutConstraint.activate([
            titleTextField.heightAnchor.constraint(equalToConstant: 64),
            
            sv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            sv.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            sv.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
