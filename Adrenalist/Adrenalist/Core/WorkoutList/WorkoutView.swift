//
//  WorkoutListView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

//import ScrollableDatepicker
import CombineCocoa
import Combine
import UIKit.UIView

enum WorkoutListViewAction {
    case changeOrder
    case postponeToTommorow
    case delete
    
    case didTapAdd
    case titleCalendarDidTap
    
    case back
}

final class WorkoutListView: UIView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<WorkoutListViewAction, Never>()
    
//    private(set) lazy var editButton = UIBarButtonItem(title: "Edit",
//                                                       image: nil,
//                                                       primaryAction: nil,
//                                                       menu: UIMenu(options: .displayInline,
//                                                                    children: menuItems))
//    private(set) lazy var editButton: UIBarButtonItem = {
//        let bt = UIBarButtonItem(title: "Edit",
//                                 image: nil,
//                                 primaryAction: nil,
//                                 menu: UIMenu(options: .displayInline,
//                                              children: menuItems))
//        bt.tintColor = .white
//        return bt
//    }()
//
//    func isAddButtonHidden(_ isHidden: Bool) {
//        self.addButton.customView?.isHidden = isHidden
//    }
//
//    private var menuItems: [UIAction] {
//        return [
//            UIAction(title: "순서 변경",
//                     image: nil,
//                     handler: { (_) in
//                self.actionSubject.send(.changeOrder)
//            }),
//
//            UIAction(title: "내일로 미루기",
//                     image: nil,
//                     handler: { (_) in
//                self.actionSubject.send(.postponeToTommorow)
//            }),
//
//            UIAction(title: "삭제",
//                     image: nil,
//                     attributes: .destructive,
//                     handler: { (_) in
//                self.actionSubject.send(.delete)
//            })
//        ]
//    }
//
//    private(set) lazy var addButton: UIBarButtonItem = {
//        let lb = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: nil, action: nil)
//        lb.tintColor = .white
//        return lb
//    }()
    
//    private(set) lazy var calendarTitleButton: UIButton = {
//        let bt = UIButton()
//        bt.setTitle(Date().getFormattedDate(format: "yyyy년 MM월"), for: .normal)
//        bt.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        return bt
//    }()
//
//    public lazy var calendarView: MyScrollableDatepicker = {
//        let cv = MyScrollableDatepicker()
//        cv.delegate = self
//        return cv
//    }()
//
//    private lazy var dividerView = AdrenalistDividerView()
//
//    private(set) lazy var favoritesCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 12
//        layout.scrollDirection = .horizontal
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
//        cv.showsHorizontalScrollIndicator = false
//        cv.heightAnchor.constraint(equalToConstant: 70).isActive = true
//        cv.backgroundColor = .black
//        return cv
//    }()
//
//    private(set) lazy var workoutlistCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 12
//        layout.scrollDirection = .vertical
//        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
//
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.register(WorkoutlistCollectionViewCell.self, forCellWithReuseIdentifier: WorkoutlistCollectionViewCell.identifier)
//        cv.backgroundColor = .black
//        return cv
//    }()
    
    private(set) lazy var backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: nil, action: nil)
    
    private let circularView = CircularView()
    
    private lazy var skipButton: AdrenalistTextRectangleButton = {
        let bt = AdrenalistTextRectangleButton(title: "SKIP", backgroundColor: .navyGray)
//        bt.widthAnchor.constraint(equalToConstant: UIScreen.main.width / 3).isActive = true
//        bt.frame = .init(x: 0, y: 0, width: UIScreen.main.width / 3, height: 64)
        bt.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.width/3).isActive = true
        return bt
    }()
    
    private lazy var nextButton: AdrenalistTextRectangleButton = {
        let bt = AdrenalistTextRectangleButton(title: "NEXT", backgroundColor: .purpleBlue)
//        bt.widthAnchor.constraint(equalToConstant: (UIScreen.main.width / 3) * 2 - 14).isActive = true
//        bt.frame = .init(x: 0, y: 0, width: UIScreen.main.width / 2, height: 64)
//        bt.widthAnchor.constraint(equalTo: UIScreen.main.width / 2, multiplier: <#T##CGFloat#>)
        bt.widthAnchor.constraint(greaterThanOrEqualToConstant: UIScreen.main.width / 2).isActive = true
        return bt
    }()
    
    private lazy var finishButton: AdrenalistTextRectangleButton = {
        let bt = AdrenalistTextRectangleButton(title: "FINISH", backgroundColor: .purpleBlue)
//        bt.widthAnchor.constraint(equalToConstant: UIScreen.main.width - 12).isActive = true
        return bt
    }()
    
    private lazy var resumeButton: AdrenalistTextRectangleButton = {
        let bt = AdrenalistTextRectangleButton(title: "RESUME")
        return bt
    }()
    
    private lazy var pauseButton: AdrenalistTextRectangleButton = {
        let bt = AdrenalistTextRectangleButton(title: "PAUSE")
        return bt
    }()
    
    private lazy var nextWorkoutLabel: UILabel = {
       let lb = UILabel()
        lb.text = "next"
        lb.textColor = .brightGrey
        lb.backgroundColor = .red
        return lb
    }()
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        bind()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupUI()
    }
    
    //MARK: - Private Methods
    private func bind() {
//        addButton
//            .tapPublisher
//            .sink { [weak self] _ in
//                self?.actionSubject.send(.didTapAdd)
//            }
//            .store(in: &cancellables)
//
//        calendarTitleButton
//            .tapPublisher
//            .sink { _ in
//                self.actionSubject.send(.titleCalendarDidTap)
//            }
//            .store(in: &cancellables)
        
        backButton.tapPublisher.sink { _ in
            self.actionSubject.send(.back)
        }
        .store(in: &cancellables)
    }
    
    private lazy var resumeButtonStackView: UIStackView = {
       let bt = UIStackView(arrangedSubviews: [skipButton, nextButton])
        bt.distribution = .fill
        bt.alignment = .fill
        bt.spacing = 8
        return bt
    }()
    
    private func setupUI() {
        backgroundColor = .black
//
//        let cvStackView = UIStackView(arrangedSubviews: [favoritesCollectionView, dividerView, workoutlistCollectionView])
//        cvStackView.axis = .vertical
//        cvStackView.distribution = .fill
//        cvStackView.alignment = .fill
//        cvStackView.spacing = 2
//
//        [calendarView, cvStackView].forEach {
//            addSubview($0)
//            $0.translatesAutoresizingMaskIntoConstraints = false
//        }
//
//        NSLayoutConstraint.activate([
//            calendarView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            calendarView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
//            calendarView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            calendarView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            calendarView.heightAnchor.constraint(equalToConstant: 80),
//
//            cvStackView.topAnchor.constraint(equalTo: calendarView.bottomAnchor),
//            cvStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            cvStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            cvStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
//        ])
        
        let btHStack = UIStackView(arrangedSubviews: [finishButton])
        btHStack.axis = .horizontal
        btHStack.alignment = .center
        btHStack.distribution = .equalSpacing
        btHStack.spacing = 8
        
//        let totalStack = UIStackView(arrangedSubviews: [circularView, btHStack])
//        btHStack.axis = .vertical
//        btHStack.alignment = .fill
//        btHStack.distribution = .fill
        
        let resumeStack = UIStackView(arrangedSubviews: [finishButton])
        resumeStack.axis = .horizontal
        resumeStack.alignment = .center
        resumeStack.distribution = .equalSpacing
        resumeStack.spacing = 8
        
        let nextStack = UIStackView(arrangedSubviews: [skipButton, nextButton])
        nextStack.axis = .horizontal
        nextStack.alignment = .center
        nextStack.distribution = .equalSpacing
        nextStack.spacing = 8
        
        [circularView,
         nextWorkoutLabel,
         nextStack].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            circularView.centerXAnchor.constraint(equalTo: centerXAnchor),
            circularView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -UIScreen.main.height/15),
            
            nextWorkoutLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
////            nextWorkout.bottomAnchor.constraint(equalTo: btHStack.topAnchor, constant: -UIScreen.main.height/8),
            nextWorkoutLabel.centerYAnchor.constraint(equalTo: centerYAnchor,
                                                      constant: UIScreen.main.height / 4),

//            btHStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
//            btHStack.centerXAnchor.constraint(equalTo: centerXAnchor),
//            btHStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
//            btHStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            nextStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            nextStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            nextStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nextStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WorkoutListView: MyScrollableDatepickerDelegate {
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
