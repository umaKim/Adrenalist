//
//  WorkoutHistoryTableViewCell.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import UIKit

final class WorkoutHistoryTableViewCell: UITableViewCell {
    static let identifier = "WorkoutHistoryTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
