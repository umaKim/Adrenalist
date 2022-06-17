//
//  WorkoutlistCollectionViewCell.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/15.
//

import UIKit

final class WorkoutlistCollectionViewCell: UICollectionViewCell {
    static let identifier = "WorkoutlistCollectionViewCell"
    
    private lazy var titleLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .white
        lb.font = .boldSystemFont(ofSize: 17)
        return lb
    }()
    
    private lazy var repsLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = .boldSystemFont(ofSize: 16)
        return lb
    }()
    
    private lazy var weightLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = .boldSystemFont(ofSize: 16)
        return lb
    }()
    
    private lazy var timerLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = .boldSystemFont(ofSize: 16)
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: WorkoutModel) {
        self.titleLabel.text = model.title
        
        if let reps = model.reps{
            self.repsLabel.text = "\(reps) x "
        }
        
        if let weight = model.weight {
            self.weightLabel.text = "\(weight) Kg"
        }
        
        if let timer = model.timer {
            self.timerLabel.text = "\(timer) sec"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        repsLabel.text = nil
        weightLabel.text = nil
        timerLabel.text = nil
    }
    
    private func setupUI() {
        layer.cornerRadius = 20
        
        backgroundColor = .navyGray
        
        let labelHStack = UIStackView(arrangedSubviews: [repsLabel, weightLabel])
        labelHStack.axis = .horizontal
        labelHStack.distribution = .fill
        labelHStack.alignment = .fill
        
        let labelVStack = UIStackView(arrangedSubviews: [labelHStack, timerLabel])
        labelVStack.axis = .vertical
        labelVStack.distribution = .fill
        labelVStack.alignment = .fill
        
        [titleLabel, labelVStack].forEach { uv in
            addSubview(uv)
            uv.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            labelVStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelVStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
}
