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
    case add
    
    case tapTitleCalendar(ContentViewController)
    
    case delete
    case createSet
    case bottomNavigationBarDidTapCancel
    case start
    
    case didSelectDate(MyScrollableDatepickerModel)
    
    case bottomSheetDidTapDelete
    case bottomSheetDidTapCreateSet
}

final class WorkoutListView2: UIView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<WorkoutListView2Action, Never>()
    
    private(set) lazy var calendarTitleButton: UIButton = {
        var config = UIButton.Configuration.plain()
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 17)
        config.attributedTitle = AttributedString("\(Date().getFormattedDate(format: "yyyy년 MM월"))", attributes: container)
        config.image = UIImage(systemName: "chevron.down")
        config.imagePlacement = .trailing
        config.imagePadding = 6.2
        config.baseForegroundColor = .white
        config.titleAlignment = .center
        let bt = UIButton()
        bt.configuration = config
        bt.widthAnchor.constraint(equalToConstant: 50).isActive = true
        return bt
    }()
    
    private(set) lazy var editButton: UIBarButtonItem = {
        let bt = UIBarButtonItem(title: "Edit", image: nil, menu: UIMenu(
            options: .displayInline,
            children: [createSet, delete])
        )
        bt.tintColor = .white
        return bt
    }()
    
    private lazy var createSet = UIAction(title: "Create Set", handler: {[weak self] _ in
        self?.actionSubject.send(.createSet)
        self?.bottomNavigationView.show(.createSet)
    })
    
    private lazy var delete = UIAction(title: "Delete", handler: {[weak self] _ in
        self?.actionSubject.send(.delete)
        self?.bottomNavigationView.show(.delete)
    })
    
    private(set) lazy var addButton: UIBarButtonItem = {
        let bt = UIBarButtonItem(
            image:UIImage(systemName: "plus"),
            style: .done,
            target: nil,
            action: nil
        )
        bt.tintColor = .white
        return bt
    }()
    
    private(set) lazy var moveToCircularButton: UIBarButtonItem = {
        let bt = UIBarButtonItem(
            image: UIImage(systemName: "chevron.right"),
            style: .plain, target: nil, action: nil
        )
        bt.tintColor = .white
        return bt
    }()
    
    public lazy var calendarView: MyScrollableDatepicker = {
        let cv = MyScrollableDatepicker()
        cv.delegate = self
        return cv
    }()
    
    func setDates(min: Int, max: Int, dates: [Date]) {
        calendarView.setDates(min: min, max: max, dotDates: dates)
    }
    
    func initialUISetup() {
        calendarView.initialUISetup()
    }
    
    func scrollToDate(_ date: Date) {
        calendarView.scrollToDate(date)
    }
    
    func deleteDot(of date: Date) {
        calendarView.removeDot(of: date)
    }
    
    private let divider = AdrenalistDividerView()
    
    private(set) lazy var suggestedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
        cv.register(
            FavoriteFooterCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: FavoriteFooterCell.identifier
        )
        cv.register(
            FavoriteCollectionViewCell.self,
            forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier
        )
        
        cv.showsHorizontalScrollIndicator = false
        cv.heightAnchor.constraint(equalToConstant: 70).isActive = true
        return cv
    }()
    
    func isFavoriteEmpty(_ isEmpty: Bool) {
        if isEmpty {
            self.divider.isHidden = isEmpty
            self.suggestedCollectionView.isHidden = isEmpty
        } else {
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut) {
                self.divider.isHidden = isEmpty
                self.suggestedCollectionView.isHidden = isEmpty
            } completion: { _ in }
        }
    }
    
    func isWorkoutEmpty(_ isEmpty: Bool) {
        
    }
    
    private(set) lazy var workoutListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
        cv.register(
            WorkoutlistCollectionViewCell.self,
            forCellWithReuseIdentifier: WorkoutlistCollectionViewCell.identifier
        )
        cv.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "UICollectionReusableView"
        )
        cv.contentInset = .init(top: 0, left: 0, bottom: UIScreen.main.height / 4, right: 0)
        return cv
    }()
    
    private lazy var bottomNavigationView = AdrenalistBottomNavigationBarView(configurator: .init(height: 110,
                                                                                                  backgroundColor: .lightDarkNavy))
    
    private var cancellables: Set<AnyCancellable>
    
    public func dismissBottomNavigationView() {
        self.bottomNavigationView.hideBottomNavigationView()
    }
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        bind()
        setupUI()
    }
    
    private func bind() {
        calendarTitleButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else { return }
                self.actionSubject.send(.tapTitleCalendar(self.calendarViewController))
            }
            .store(in: &cancellables)
        
        addButton
            .tapPublisher
            .sink { _ in
                self.actionSubject.send(.add)
            }
            .store(in: &cancellables)
        
        bottomNavigationView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else { return }
                switch action {
                case .delete:
                    self.actionSubject.send(.bottomSheetDidTapDelete)
                    
                case .cancel:
                    self.actionSubject.send(.bottomNavigationBarDidTapCancel)
                    
                case .createSet:
                    self.actionSubject.send(.bottomSheetDidTapCreateSet)
                    
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        moveToCircularButton
            .tapPublisher
            .sink {[weak self] in
                guard let self = self else { return }
                self.actionSubject.send(.start)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        backgroundColor = .black
        
        suggestedCollectionView.autoresizingMask   = [.flexibleWidth, .flexibleHeight]
        workoutListCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let cvStackView = UIStackView(arrangedSubviews: [suggestedCollectionView,
                                                         divider,
                                                         workoutListCollectionView])
        cvStackView.axis = .vertical
        cvStackView.distribution = .fill
        cvStackView.alignment = .fill
        cvStackView.spacing = 2
        
        [calendarView,
         cvStackView,
        ].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        addSubview(bottomNavigationView)
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            calendarView.heightAnchor.constraint(equalToConstant: 80),
            
            cvStackView.topAnchor.constraint(equalTo: calendarView.bottomAnchor),
            cvStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cvStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cvStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private(set) lazy var calendarViewController = ContentViewController()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WorkoutListView2: MyScrollableDatepickerDelegate {
    func datepicker(
        _ datepicker: MyScrollableDatepicker,
        didScroll index: IndexPath
    ) {
        
    }
    
    func datepicker(
        _ datepicker: MyScrollableDatepicker,
        didSelectDate date: MyScrollableDatepickerModel
    ) {
        updateCalendarTitleButton(date.date)
        datepicker.updateDateSet(with: date)
        datepicker.scrollToDate(date.date, at: .centeredHorizontally)
        calendarViewController.update(with: date.date)
        actionSubject.send(.didSelectDate(date))
    }
    
    func updateCalendarTitleButton(_ date: Date) {
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 17)
        calendarTitleButton.configuration?.attributedTitle = AttributedString("\(date.getFormattedDate(format: "yyyy년 MM월"))", attributes: container)
    }
}
