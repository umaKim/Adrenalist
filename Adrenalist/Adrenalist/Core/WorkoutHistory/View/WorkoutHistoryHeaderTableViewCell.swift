//
//  WorkoutHistoryHeaderTableViewCell.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import FSCalendar
import UIKit

final class WorkoutHistoryHeaderTableViewCell: UITableViewHeaderFooterView {
    static let identifier = "WorkoutHistoryHeaderTableViewCell"
    
    private let fsCalendar = FSCalendar()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupHeaderView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
}
