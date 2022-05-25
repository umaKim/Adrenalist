//
//  WorkoutListView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/28.
//

import Combine
import CombineCocoa
import UIKit

enum WorkoutListViewAction {
    case addWorkoutButtonDidTap
    case edit
    case delete
    case tapBackground
    case dismiss
}

final class WorkoutListView: UIView {
    
    private(set) lazy var upwardImageView = UIImageView(image: UIImage(systemName: Constant.ButtonImage.upArrow))
    private(set) lazy var updateButton = UIBarButtonItem(title: "",
                                                         image: UIImage(systemName: Constant.ButtonImage.editting),
                                                         menu: UIMenu(options: .displayInline,
                                                                      children: [edit, delete]))
    
    private lazy var edit = UIAction(title: "Update",
                                     handler: {[weak self] _ in
        self?.actionSubject.send(.edit)
        self?.recognizer?.isEnabled = true
    })
    
    private lazy var delete = UIAction(title: "Delete",
                                       handler: {[weak self] _ in
        self?.actionSubject.send(.delete)
        self?.recognizer?.isEnabled = true
    })
    
    private(set) lazy var addWorkoutButton = UIBarButtonItem(image: UIImage(systemName: Constant.ButtonImage.addWorkout), style: .done, target: nil, action: nil)
    
    private(set) lazy var dismissButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: nil, action: nil)
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<WorkoutListViewAction, Never>()
    
    private(set) lazy var suggestedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
        cv.register(SuggestionListCell.self, forCellWithReuseIdentifier: SuggestionListCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    private(set) lazy var workoutListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
        cv.register(WorkoutListCell.self, forCellWithReuseIdentifier: WorkoutListCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private(set) lazy var inputAccessory = InputView()
    
    func showKeyboard(_ frame: CGRect) {
        self.recognizer?.isEnabled = true
        UIView.animate(withDuration: 1) {
            self.inputAccessoryBottomAnchor?.constant = frame.height * -1 + 34
            self.layoutIfNeeded()
        }
    }
    
    func hideKeyboard() {
        endEditing(true)
        UIView.animate(withDuration: 0.5) {
            self.inputAccessoryBottomAnchor?.constant = 0
            self.layoutIfNeeded()
        }
    }
    
    private var recognizer: UITapGestureRecognizer?
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        bind()
        setupUI()
    }
    
    private func bind() {
        addWorkoutButton
            .tapPublisher
            .sink {[weak self] in
                guard let self = self else { return }
                self.actionSubject.send(.addWorkoutButtonDidTap)
            }
            .store(in: &cancellables)
        
        dismissButton
            .tapPublisher
            .sink { [weak self] in
                self?.actionSubject.send(.dismiss)
            }
            .store(in: &cancellables)
            
        recognizer = UITapGestureRecognizer(target: self, action: #selector(tapBackground))
        addGestureRecognizer(recognizer ?? UITapGestureRecognizer())
    }
   
    @objc
    private func tapBackground() {
        actionSubject.send(.tapBackground)
        recognizer?.isEnabled = false
        
        self.hideKeyboard()
        self.endEditing(true)
    }
    
    private func setupUI() {
        backgroundColor = .black
        addSubview(suggestedCollectionView)
        addSubview(workoutListCollectionView)
        addSubview(inputAccessory)
        
        suggestedCollectionView.autoresizingMask   = [.flexibleWidth, .flexibleHeight]
        workoutListCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        NSLayoutConstraint.activate([
            suggestedCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            suggestedCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            suggestedCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            suggestedCollectionView.heightAnchor.constraint(equalToConstant: 60),
            
            workoutListCollectionView.topAnchor.constraint(equalTo: suggestedCollectionView.bottomAnchor),
            workoutListCollectionView.bottomAnchor.constraint(equalTo: inputAccessory.topAnchor),
            workoutListCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            workoutListCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            inputAccessory.leadingAnchor.constraint(equalTo: leadingAnchor),
            inputAccessory.trailingAnchor.constraint(equalTo: trailingAnchor),
//            inputAccessory.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
//            inputAccessory.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -200)
        ])
        
        inputAccessoryBottomAnchor = inputAccessory.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        inputAccessoryBottomAnchor?.isActive = true
    }
    
    private var inputAccessoryBottomAnchor: NSLayoutConstraint?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
