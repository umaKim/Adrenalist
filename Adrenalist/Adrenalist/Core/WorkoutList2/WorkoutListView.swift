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
    //    case addWorkoutButtonDidTap(String?, String?, String?)
    //    case edit
    
    //    case tapBackground
    case add
    
    case tapTitleCalendar(UIViewController)
    
    case reorder
    case postpone
    case delete
    case bottomNavigationBarDidTapCancel
    case start
}

final class WorkoutListView2: UIView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<WorkoutListView2Action, Never>()
    
    //    private(set) lazy var upwardImageView = UIImageView(image: UIImage(systemName: Constant.ButtonImage.upArrow))
    
    private(set) lazy var calendarTitleButton: UIButton = {
        let bt = UIButton()
        bt.setTitle(Date().getFormattedDate(format: "yyyy년 MM월"), for: .normal)
        bt.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return bt
    }()
    
    private(set) lazy var editButton = UIBarButtonItem(title: "Edit",
                                                       image: nil,
                                                       menu: UIMenu(options: .displayInline,
                                                                    children: [reorder,
                                                                               postpone,
                                                                               delete]))
    
    private lazy var reorder = UIAction(title: "Reoder",
                                        handler: {[weak self] _ in
        self?.actionSubject.send(.reorder)
        self?.bottomNavigationView.show(.move)
    })
    
    private lazy var postpone = UIAction(title: "Postpone",
                                         handler: {[weak self] _ in
        self?.actionSubject.send(.postpone)
        self?.bottomNavigationView.show(.done)
    })
    
    private lazy var delete = UIAction(title: "Delete",
                                       handler: {[weak self] _ in
        self?.actionSubject.send(.delete)
        self?.bottomNavigationView.show(.delete)
    })
    
    private(set) lazy var addButton = UIBarButtonItem(image:
                                                        UIImage(systemName: "plus"),
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
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
        cv.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.heightAnchor.constraint(equalToConstant: 70).isActive = true
        return cv
    }()
    
    private(set) lazy var workoutListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
        cv.register(WorkoutlistCollectionViewCell.self, forCellWithReuseIdentifier: WorkoutlistCollectionViewCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private lazy var startButton = AdrenalistTextRectangleButton(title: "Start")
    
    func isStartButtonHidden(_ isHidden: Bool) {
        self.startButton.isHidden = isHidden
    }
    
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
                self.actionSubject.send(.tapTitleCalendar(self.bottomSheetViewController))
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
                    print("delete")
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
        
        startButton
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
                                                         AdrenalistDividerView(),
                                                         workoutListCollectionView])
        cvStackView.axis = .vertical
        cvStackView.distribution = .fill
        cvStackView.alignment = .fill
        cvStackView.spacing = 2
        
        [calendarView,
         cvStackView,
         startButton,
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
            cvStackView.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -2),
            
            startButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
    }
    
    private var bottomSheetViewController: UIViewController {
        let viewControllerToPresent = ContentViewController()
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        return viewControllerToPresent
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WorkoutListView2: MyScrollableDatepickerDelegate {
    func datepicker(
        _ datepicker: MyScrollableDatepicker,
        didScroll index: IndexPath
    ) {
        calendarTitleButton.setTitle("\( datepicker.dates[index.row].date.getFormattedDate(format: "yyyy년 MM월"))", for: .normal)
    }
    
    func datepicker(
        _ datepicker: MyScrollableDatepicker,
        didSelectDate date: MyScrollableDatepickerModel
    ) {
        datepicker.updateDateSet(with: date)
    }
}
