//
//  WorkoutListCell.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/28.
//

import UIKit.UICollectionViewCell

final class WorkoutListCell: UICollectionViewCell {
    static let identifier = "WorkoutListCell"
    
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private var workout: Workout?
    
    func configure(with workout: Workout) {
        self.workout = workout
        titleLabel.text = workout.title
        
        update()
    }
    
    func update() {
        let uv = UIView()
        guard let workout = workout else {
            uv.backgroundColor = .blue
            selectedBackgroundView = uv
            return
        }

        uv.backgroundColor = workout.isDone ? .red : .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
