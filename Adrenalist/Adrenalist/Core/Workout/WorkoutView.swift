//
//  WorkoutListView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//
import ScrollableDatepicker
import CombineCocoa
import Combine
import UIKit.UIView

enum WorkoutListViewAction {
    case doubleTap
    case didTapCalendar
    case didTapSetting
    case didTap(MyScrollableDatepickerModel)
}

final class WorkoutListView: UIView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<WorkoutListViewAction, Never>()
    
    private(set) lazy var calendarButton = UIBarButtonItem(image: UIImage(systemName: Constant.ButtonImage.calendar), style: .done, target: nil, action: nil)
    private(set) lazy var settingButton = UIBarButtonItem(image: UIImage(systemName: Constant.ButtonImage.setting), style: .done, target: nil, action: nil)
    
    lazy var calendarView: MyScrollableDatepicker = {
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
    
    private lazy var favoritesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.dataSource = self
//        cv.delegate = self
        cv.register(MyScrollableDatepickerCell.self, forCellWithReuseIdentifier: MyScrollableDatepickerCell.identifier)
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .black
        return cv
    }()
    
    private lazy var workoutlistCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.dataSource = self
//        cv.delegate = self
        cv.register(MyScrollableDatepickerCell.self, forCellWithReuseIdentifier: MyScrollableDatepickerCell.identifier)
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .black
        return cv
    }()
    
    private let circularView = CircularView()
    
    private var workoutLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = UIFont.systemFont(ofSize: 42, weight: .heavy)
        return lb
    }()
    
    private var nextLabel:  UILabel = {
        let lb = UILabel()
        lb.textColor = .systemGray3
        lb.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        return lb
    }()
    
    private var repsLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        return lb
    }()
    
    private var weightLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        return lb
    }()
    
    var updateWorkout: Item? {
        didSet {
            guard let updateWorkout = updateWorkout else { return }
            self.workoutLabel.text = updateWorkout.title
            
            if let reps = updateWorkout.reps {
                self.repsLabel.text = "\(reps) Reps"
            }
        
            if let timer = updateWorkout.timer {
                self.repsLabel.text = "\(timer) sec"
            }
            
            if let weight = updateWorkout.weight {
                self.weightLabel.text = "\(weight) Kg"
            }
        }
    }
    
    var nextWorkout: Item? {
        didSet{
            self.nextLabel.text = nextWorkout?.title
        }
    }
    
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
    
    //MARK: - Public Methods
    public func updatePulse(_ duration: CFTimeInterval) {
        circularView.animatePulse(duration)
    }
    
    public func updateOutline(_ strokeEnd: CGFloat) {
        circularView.animateOutlineStroke(strokeEnd)
    }
    
    public func updateInline(_ strokeEnd: CGFloat) {
        circularView.animateInlineStroke(strokeEnd)
    }
    
    //MARK: - Private Methods
    private func bind() {
        calendarButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return }
                self.actionSubject.send(.didTapCalendar)
            }
            .store(in: &cancellables)
        
        settingButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return }
                self.actionSubject.send(.didTapSetting)
            }
            .store(in: &cancellables)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        tapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func didTap() {
        self.actionSubject.send(.doubleTap)
    }
    
    private func setupUI() {
        backgroundColor = .black
        
        let labelStackView = UIStackView(arrangedSubviews: [repsLabel, weightLabel])
        labelStackView.axis = .vertical
        labelStackView.distribution = .fill
        labelStackView.alignment = .center
        labelStackView.spacing = 12
        
        [calendarView,
//         circularView,
         workoutLabel, nextLabel, labelStackView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            calendarView.centerXAnchor.constraint(equalTo: centerXAnchor),
            calendarView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            calendarView.heightAnchor.constraint(equalToConstant: 80),
            
            workoutLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            workoutLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            nextLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nextLabel.topAnchor.constraint(equalTo: workoutLabel.bottomAnchor, constant: frame.height / 13),
            
            labelStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelStackView.topAnchor.constraint(equalTo: centerYAnchor, constant: frame.height / 3.5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WorkoutListView: MyScrollableDatepickerDelegate {
    func datepicker(_ datepicker: MyScrollableDatepicker, didSelectDate date: MyScrollableDatepickerModel) {
//        let date = MyScrollableDatepickerModel(date: date.date, isSelected: true)
//        self.actionSubject.send(.didTap(date))
//        let index = datepicker.dates.firstIndex(of: date)?.description ?? "0"
//        let indexInt = Int(index) ?? 0
//
//        datepicker.dates[indexInt] = date
//        let indexPath = IndexPath(row: indexInt, section: 0)
//        datepicker.collectionView.reloadItems(at: [indexPath])
        datepicker.updateDateSet(with: date)
        
    }
}
