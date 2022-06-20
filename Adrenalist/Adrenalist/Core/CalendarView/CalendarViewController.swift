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
        
        setupCalendar()
        setupUI()
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
    }
    
    private func setupUI() {
        view.backgroundColor = .darkNavy
        view.addSubview(calendar)
        
        let sv = UIStackView(arrangedSubviews: [calendar])
        sv.distribution = .fill
        sv.alignment = .fill
        
        [sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sv.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sv.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            sv.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}
