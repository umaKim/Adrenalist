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
    case didTapAdd
    case didTapEdit
    case titleCalendarDidTap(String)
}

final class WorkoutListView: UIView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<WorkoutListViewAction, Never>()
    
    private(set) lazy var editButton = UIBarButtonItem(title: "Edit", image: nil, primaryAction: nil, menu: UIMenu(options: .displayInline, children: menuItems))
    
    private var menuItems: [UIAction] {
        return [
            UIAction(title: "순서 변경", image: UIImage(systemName: "sun.max"), handler: { (_) in
            }),
            UIAction(title: "내일로 미루기", image: UIImage(systemName: "moon"), handler: { (_) in
            }),
            UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { (_) in
            })
        ]
    }
    
    func act() {
        
    }
    
    private(set) lazy var addButton: UIBarButtonItem = {
        let lb = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: nil, action: nil)
        lb.tintColor = .white
        return lb
    }()
    
    private(set) lazy var calendarTitleButton: UIButton = {
        let bt = UIButton()
        bt.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return bt
    }()
    
    public lazy var calendarView: MyScrollableDatepicker = {
        let cv = MyScrollableDatepicker()
        
        cv.selectedDate = Date()
        cv.delegate = self
        
        // weekend customization
        var configuration = Configuration()
        
        configuration.weekendDayStyle.dateTextColor = UIColor(red: 242.0/255.0, green: 93.0/255.0, blue: 28.0/255.0, alpha: 1.0)
        configuration.weekendDayStyle.dateTextFont = UIFont.boldSystemFont(ofSize: 20)
        configuration.weekendDayStyle.weekDayTextColor = UIColor(red: 242.0/255.0, green: 93.0/255.0, blue: 28.0/255.0, alpha: 1.0)
        
        // selected date customization
        configuration.selectedDayStyle.backgroundColor = UIColor(white: 0.9, alpha: 1)
        configuration.daySizeCalculation = .numberOfVisibleItems(5)
        
        cv.configuration = configuration
        
        return cv
    }()
    
    private lazy var dividerView = AdrenalistDivider()
    
    private(set) lazy var favoritesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.heightAnchor.constraint(equalToConstant: 70).isActive = true
        cv.backgroundColor = .red
        return cv
    }()
    
    private(set) lazy var workoutlistCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(WorkoutlistCollectionViewCell.self, forCellWithReuseIdentifier: WorkoutlistCollectionViewCell.identifier)
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .blue
        return cv
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
        addButton
            .tapPublisher
            .sink { [weak self] _ in
                self?.actionSubject.send(.didTapAdd)
            }
            .store(in: &cancellables)
        
        calendarTitleButton
            .tapPublisher
            .sink { _ in
                print("tapped cAlendar")
                //                self.actionSubject.send(.titleCalendarDidTap(<#T##String#>))
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        backgroundColor = .black
        
//        favoritesCollectionView, dividerView,
        let cvStackView = UIStackView(arrangedSubviews: [favoritesCollectionView, dividerView, workoutlistCollectionView])
        cvStackView.axis = .vertical
        cvStackView.distribution = .fill
        cvStackView.alignment = .fill
        cvStackView.spacing = 2
        
        [calendarView, cvStackView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            calendarView.centerXAnchor.constraint(equalTo: centerXAnchor),
            calendarView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            calendarView.heightAnchor.constraint(equalToConstant: 80),
            
            cvStackView.topAnchor.constraint(equalTo: calendarView.bottomAnchor),
            cvStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cvStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cvStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
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
        calendarTitleButton.setTitle("\( datepicker.dates[index.row].date.getFormattedDate(format: "yyyy년 MM월"))", for: .normal)
    }
    
    func datepicker(
        _ datepicker: MyScrollableDatepicker,
        didSelectDate date: MyScrollableDatepickerModel
    ) {
        datepicker.updateDateSet(with: date)
    }
}

final class AdrenalistDivider: UIView {
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .lightGray
        heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
