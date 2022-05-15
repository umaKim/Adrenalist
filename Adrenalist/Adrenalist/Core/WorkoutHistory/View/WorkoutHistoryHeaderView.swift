//
//  WorkoutHistoryHeaderView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import Combine
import FSCalendar
import UIKit

enum WorkoutHistoryHeaderViewAction {
    case didTapDate
}

final class WorkoutHistoryHeaderView: UITableViewHeaderFooterView {
    static let identifier = "WorkoutHistoryHeaderTableViewCell"
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<WorkoutHistoryHeaderViewAction, Never>()
    
    private let fsCalendar = FSCalendar()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        fsCalendar.appearance.titleDefaultColor = .white
        
        setupHeaderView()
        configureLayout()
    }
    
    private func setupHeaderView() {
        fsCalendar.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(fsCalendar)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            fsCalendar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            fsCalendar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            fsCalendar.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 3)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension WorkoutHistoryHeaderView: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        3
    }
}

extension WorkoutHistoryHeaderView: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
    }
}
