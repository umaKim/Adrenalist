//
//  WorkoutlistCollectionViewCell.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/15.
//
import Combine
import UIKit

final class WorkoutlistCollectionViewCell: UICollectionViewCell {
    static let identifier = "WorkoutlistCollectionViewCell"
    
    private lazy var modeView = ModeView(mode: .normal)
    
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
        self.cancellables = .init()
        super.init(frame: frame)
        
        setupUI()
        backgroundColor = .navyGray
    }
    
    private var isChecked: Bool?
    
    private var cancellables: Set<AnyCancellable>
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var model: WorkoutModel?
    
    func configure(with model: WorkoutModel, mode: WorkoutListCellMode) {
        self.model = model
        self.isChecked = model.isSelected
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
        
        self.modeView.updateMode(mode)
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.modeView.isHidden = mode == .normal
            } completion: { _ in }
        }
    }
    
    private func bind() {
        self.modeView
            .actionPublisher
            .sink { action in
                switch action {
                case .tapCheckButton(let isTapped):
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        model = nil
//        modeView = .init(mode: .delete)
        titleLabel.text = nil
        repsLabel.text = nil
        weightLabel.text = nil
        timerLabel.text = nil
    }
    
    private func setupUI() {
        layer.cornerRadius = 20
        
        backgroundColor = .navyGray
        
        let titleHStack = UIStackView(arrangedSubviews: [modeView, titleLabel])
        titleHStack.axis = .horizontal
        titleHStack.distribution = .fill
        titleHStack.alignment = .fill
        titleHStack.spacing = 16
//        titleHStack.backgroundColor = .red
        
        let labelHStack = UIStackView(arrangedSubviews: [repsLabel, weightLabel])
        labelHStack.axis = .horizontal
        labelHStack.distribution = .fill
        labelHStack.alignment = .fill
        
        let labelVStack = UIStackView(arrangedSubviews: [labelHStack, timerLabel])
        labelVStack.axis = .vertical
        labelVStack.distribution = .fill
        labelVStack.alignment = .fill
        
        [
            titleHStack,
            labelVStack
        ].forEach { uv in
            contentView.addSubview(uv)
            uv.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleHStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleHStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleHStack.trailingAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            labelVStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
}
