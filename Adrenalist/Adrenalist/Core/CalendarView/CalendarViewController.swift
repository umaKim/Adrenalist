//
//  CalendarViewController.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/19.
//

import Combine
import FSCalendar
import UIKit

protocol ContentViewControllerDelegate: AnyObject {
    func didSelectDate(_ date: Date)
    func contentViewControllerDidTapDismiss()
}

final class ContentViewController: UIViewController {
    private lazy var grabberView: UIView = {
        let uv = UIView()
        uv.backgroundColor = .systemGray
        uv.heightAnchor.constraint(equalToConstant: 5).isActive = true
        uv.widthAnchor.constraint(equalToConstant: 30).isActive = true
        uv.layer.cornerRadius = 2.5
        return uv
    }()
    
    private let dismissButton: UIBarButtonItem = {
       let bt = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: nil, action: nil)
        bt.tintColor = .white
        return bt
    }()
    
    private let calendar = FSCalendar()
    
    weak var delegate: ContentViewControllerDelegate?
    
    private var workoutResponses: [WorkoutResponse] = []
    
    var selectedDate: Date = Date().stripTime()
    
    private let workoutManager = Manager.shared
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
        
//        workoutManager
//            .$workoutResponses
//            .sink { responses in
//                self.workouts = responses
//                self.calendar.reloadData()
//            }
//            .store(in: &cancellables)
        
//        workoutManager.$selectedWorkouts.sink { responses, date in
//            self.workouts = responses
//            self.calendar.reloadData()
//        }
//        .store(in: &cancellables)
        
//        workoutManager.$workoutlist.sink { workouts in
//            self.workouts = workouts
//            self.calendar.reloadData()
//        }
//        .store(in: &cancellables)
        
        self.workoutResponses = workoutManager.workoutResponses
        
        dismissButton
            .tapPublisher
            .sink { _ in
                self.delegate?.contentViewControllerDidTapDismiss()
            }
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCalendar()
        setupUI()
    }
    
    public func update(with date: Date) {
        self.selectedDate = date.stripTime()
        self.calendar.select(self.selectedDate)
        self.calendar.reloadData()
    }
    
    private func setupCalendar() {
        calendar.dataSource = self
        calendar.delegate = self
        
        calendar.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: -상단 헤더 뷰 관련
        //        calendar.headerHeight = 66 // YYYY년 M월 표시부 영역 높이
        //        calendar.weekdayHeight = 41 // 날짜 표시부 행의 높이
        //        calendar.appearance.headerMinimumDissolvedAlpha = 0.0 //헤더 좌,우측 흐릿한 글씨 삭제
        calendar.appearance.headerDateFormat = "YYYY년 M월" //날짜(헤더) 표시 형식
        calendar.appearance.headerTitleColor = .white //2021년 1월(헤더) 색
        //        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24) //타이틀 폰트 크기
        
        //MARK: -캘린더(날짜 부분) 관련
        //        calendar.backgroundColor = .white // 배경색
        calendar.appearance.weekdayTextColor = .white //요일(월,화,수..) 글씨 색
        calendar.appearance.selectionColor = .purpleBlue.withAlphaComponent(0.5) //선택 된 날의 동그라미 색
        calendar.appearance.titleWeekendColor = .white //주말 날짜 색
        calendar.appearance.titleDefaultColor = .white //기본 날짜 색
        
        //MARK: -오늘 날짜(Today) 관련
        calendar.appearance.titleTodayColor = .white //Today에 표시되는 특정 글자색
        calendar.appearance.todayColor = .purpleBlue //Today에 표시되는 선택 전 동그라미 색
        //        calendar.appearance.todaySelectionColor = .none
        
        calendar.select(self.selectedDate)
    }
}

//MARK: -
extension ContentViewController: FSCalendarDataSource, FSCalendarDelegate  {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        workoutResponses.contains(where: {$0.date == date}) ? 1 : 0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        delegate?.didSelectDate(date.stripTime())
    }
}

//MARK: - UI
extension ContentViewController {
    private func setupUI() {
        view.backgroundColor = .darkNavy
        
        navigationItem.rightBarButtonItems = [dismissButton]
        
        let sv = UIStackView(arrangedSubviews: [calendar])
        sv.distribution = .fill
        sv.alignment = .fill
        sv.axis = .vertical
        sv.spacing = 12
        
        [grabberView,sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            grabberView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            grabberView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            
            sv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sv.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sv.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sv.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}
