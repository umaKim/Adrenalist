//
//  WorkoutListView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/28.
//

import Combine
import CombineCocoa
import UIKit

enum WorkoutListView2Action {
    case addWorkoutButtonDidTap(String?, String?, String?)
    case edit
    case delete
    case tapBackground
    case dismiss
}

final class WorkoutListView2: UIView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<WorkoutListView2Action, Never>()
    
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
    
    private(set) lazy var dismissButton = UIBarButtonItem(image: UIImage(systemName: Constant.ButtonImage.xmark),
                                                          style: .done,
                                                          target: nil,
                                                          action: nil)
    public lazy var calendarView: MyScrollableDatepicker = {
        let cv = MyScrollableDatepicker()
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private(set) lazy var suggestedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
//        cv.register(SuggestionListCell.self, forCellWithReuseIdentifier: SuggestionListCell.identifier)
        cv.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    private(set) lazy var workoutListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
//        cv.register(WorkoutListCell.self, forCellWithReuseIdentifier: WorkoutListCell.identifier)
        cv.register(WorkoutlistCollectionViewCell.self, forCellWithReuseIdentifier: WorkoutlistCollectionViewCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
//    private(set) lazy var inputAccessory = InputView()
    
    func showKeyboard(_ frame: CGRect) {
        self.recognizer?.isEnabled = true
        UIView.animate(withDuration: 0.3) {
            self.inputAccessoryBottomAnchor?.constant = frame.height * -1 + 34
            self.layoutIfNeeded()
        }
    }
    
    func hideKeyboard() {
        endEditing(true)
        self.recognizer?.isEnabled = false
        
        UIView.animate(withDuration: 0.3) {
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
//        inputAccessory
//            .actionPublisher
//            .sink {[weak self] action in
//                switch action {
//                case .addButton(let workout, let reps, let weight):
//                    self?.actionSubject.send(.addWorkoutButtonDidTap(workout, reps, weight))
//                }
//            }
//            .store(in: &cancellables)
        
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
//        addSubview(inputAccessory)
        addSubview(calendarView)
        
        suggestedCollectionView.autoresizingMask   = [.flexibleWidth, .flexibleHeight]
        workoutListCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            calendarView.heightAnchor.constraint(equalToConstant: 80),
            
            suggestedCollectionView.topAnchor.constraint(equalTo: calendarView.bottomAnchor),
            suggestedCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            suggestedCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            suggestedCollectionView.heightAnchor.constraint(equalToConstant: 60),
            
            workoutListCollectionView.topAnchor.constraint(equalTo: suggestedCollectionView.bottomAnchor),
            workoutListCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            workoutListCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            workoutListCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
//            inputAccessory.leadingAnchor.constraint(equalTo: leadingAnchor),
//            inputAccessory.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
//        inputAccessoryBottomAnchor = inputAccessory.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
//        inputAccessoryBottomAnchor?.isActive = true
    }
    
    private var inputAccessoryBottomAnchor: NSLayoutConstraint?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WorkoutListView2: MyScrollableDatepickerDelegate {
    func datepicker(
        _ datepicker: MyScrollableDatepicker,
        didScroll index: IndexPath
    ) {
//        calendarTitleButton.setTitle("\( datepicker.dates[index.row].date.getFormattedDate(format: "yyyy년 MM월"))", for: .normal)
    }
    
    func datepicker(
        _ datepicker: MyScrollableDatepicker,
        didSelectDate date: MyScrollableDatepickerModel
    ) {
        datepicker.updateDateSet(with: date)
    }
}
