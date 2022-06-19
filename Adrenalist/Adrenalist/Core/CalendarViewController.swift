//
//  CalendarViewController.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/19.
//

import FSCalendar
import UIKit

final class ContentViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    private let calendar = FSCalendar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        calendar.dataSource = self
        calendar.delegate = self
        
        calendar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(calendar)
        NSLayoutConstraint.activate([
            calendar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calendar.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            calendar.topAnchor.constraint(equalTo: view.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendar.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}
