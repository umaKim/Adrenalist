//
//  WorkoutListCell.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/28.
//
import Combine
import UIKit.UICollectionViewCell


final class WorkoutListCell: UICollectionViewCell {
    static let identifier = "WorkoutListCell"
    
    private lazy var circleButton   = AdrenalistCircleButton()
    private lazy var titleLabel     = AdrenalistLabel(text: "")
    private lazy var repsLabel      = AdrenalistLabel(text: "")
    private lazy var weightLabel    = AdrenalistLabel(text: "")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    func configure(with workout: Workout) {
        let image = workout.isDone ? UIImage(systemName: "circle.fill") : UIImage(systemName: "circle")
        circleButton.setImage(image, for: .normal)
        titleLabel.text     = workout.title
        repsLabel.text      = "\(workout.reps)"
        weightLabel.text    = "\(workout.weight) kg"
        
        backgroundColor     = workout.isDone ? .red : .white
    }
    
    private func setupUI() {
        [circleButton, titleLabel, repsLabel, weightLabel].forEach { uv in
            self.contentView.addSubview(uv)
            uv.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            circleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            circleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: circleButton.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            repsLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            repsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            weightLabel.leadingAnchor.constraint(equalTo: repsLabel.trailingAnchor),
            weightLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
