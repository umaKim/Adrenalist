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
    
    case reorder
    case postpone
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
        // 1
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
        let bt = UIBarButtonItem(title: "Edit", image: nil, menu: UIMenu(options: .displayInline,
                                                                         children: [createSet, delete]))
        bt.tintColor = .white
        return bt
    }()
    
    private lazy var reorder = UIAction(title: "Reoder",
                                        handler: {[weak self] _ in
        self?.actionSubject.send(.reorder)
        self?.bottomNavigationView.show(.move)
    })
    
    private lazy var postpone = UIAction(title: "Postpone",
                                         handler: {[weak self] _ in
        self?.actionSubject.send(.postpone)
        self?.bottomNavigationView.show(.done)
    private lazy var createSet = UIAction(title: "Create Set", handler: {[weak self] _ in
        self?.actionSubject.send(.createSet)
        self?.bottomNavigationView.show(.createSet)
    })
    
    private lazy var delete = UIAction(title: "Delete",
                                       handler: {[weak self] _ in
    private lazy var delete = UIAction(title: "Delete", handler: {[weak self] _ in
        self?.actionSubject.send(.delete)
        self?.bottomNavigationView.show(.delete)
    })
    
    private(set) lazy var addButton: UIBarButtonItem = {
        let bt = UIBarButtonItem(image:
                                    UIImage(systemName: "plus"),
                                 style: .done,
                                 target: nil,
                                 action: nil)
        bt.tintColor = .white
        return bt
    }()
    
    private(set) lazy var moveToCircularButton: UIBarButtonItem = {
        let bt = UIBarButtonItem(image: UIImage(systemName: "chevron.right"),
                                 style: .plain, target: nil, action: nil)
        bt.tintColor = .white
        return bt
    }()
    
    public lazy var calendarView: MyScrollableDatepicker = {
        let cv = MyScrollableDatepicker()
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
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
    
    func dismissCalendarView() {
        
    }
    
    private let divider = AdrenalistDividerView()
    
    private(set) lazy var suggestedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
        cv.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
        cv.register(FavoriteLastCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteLastCollectionViewCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.heightAnchor.constraint(equalToConstant: 70).isActive = true
        return cv
    }()
    
    func isFavoriteEmpty(_ isEmpty: Bool) {
        self.divider.isHidden = isEmpty
        self.suggestedCollectionView.isHidden = isEmpty
    }
    
    private(set) lazy var workoutListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
        cv.register(WorkoutlistCollectionViewCell.self, forCellWithReuseIdentifier: WorkoutlistCollectionViewCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private lazy var bottomNavigationView = AdrenalistBottomNavigationBarView(configurator: .init(height: 110,
                                                                                                  backgroundColor: .lightDarkNavy))
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        bind()
        setupUI()
    }
    
    private func bind() {
        calendarTitleButton
            .tapPublisher
            .sink {[unowned self] _ in
                self.actionSubject.send(.tapTitleCalendar(self.calendarViewController))
            }
            .store(in: &cancellables)
        
        addButton
            .tapPublisher
            .sink { [weak self] in
                self?.actionSubject.send(.add)
            }
            .store(in: &cancellables)
        
        bottomNavigationView
            .actionPublisher
            .sink { action in
                switch action {
                case .move:
                    print("move")
                    break
                    
                case .delete:
                    self.actionSubject.send(.bottomSheetDidTapDelete)
                    break
                    
                case .done:
                    print("done")
                    break
                    
                case .cancel:
                    self.actionSubject.send(.bottomNavigationBarDidTapCancel)
                    break
                }
            }
            .store(in: &cancellables)
        
        moveToCircularButton
            .tapPublisher
            .sink { _ in
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
//        var container = AttributeContainer()
//        container.font = UIFont.boldSystemFont(ofSize: 17)
//
//        var config = UIButton.Configuration.plain()
//        config.attributedTitle = AttributedString("\(datepicker.dates[index.row].date.getFormattedDate(format: "yyyy년 MM월"))", attributes: container)
//        print("\(datepicker.dates[index.row].date.getFormattedDate(format: "yyyy년 MM월"))")
//        config.image = UIImage(systemName: "chevron.down")
//        config.imagePlacement = .trailing
//        config.imagePadding = 6.2
//        config.baseForegroundColor = .white
//
//        calendarTitleButton.configuration = config
    }
    
    func datepicker(
        _ datepicker: MyScrollableDatepicker,
        didSelectDate date: MyScrollableDatepickerModel
    ) {
        updateCalendarTitleButton(date.date)
        datepicker.updateDateSet(with: date)
        
//        guard let btVC = bottomSheetViewController as? ContentViewController else {return }
        calendarViewController.update(with: date.date)
        actionSubject.send(.didSelectDate(date))
    }
    
    private func updateCalendarTitleButton(_ date: Date) {
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 17)
        calendarTitleButton.configuration?.attributedTitle = AttributedString("\(date.getFormattedDate(format: "yyyy년 MM월"))", attributes: container)
    }
}
