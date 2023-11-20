//
//  WorkoutlistCollectionViewCell.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/15.
//
import Combine
import UIKit

protocol WorkoutlistCollectionViewCellDelegate: AnyObject {
    func workoutlistCollectionViewCellDidTapComplete(_ isTapped: Bool, indexPathRow: Int)
}

final class WorkoutlistCollectionViewCell: UICollectionViewCell {
    static let identifier = "WorkoutlistCollectionViewCell"
    
    private lazy var modeView = ModeView()
    
    weak var delegate: WorkoutlistCollectionViewCellDelegate?
    
    private lazy var titleLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .white
        lb.numberOfLines = 2
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
        bind()
        setupUI()
    }
    
    private var cancellables: Set<AnyCancellable>
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var model: WorkoutModel?
    
    func configure(
        with model: WorkoutModel,
        mode: WorkoutListCellMode
    ) {
        self.model = model
        
        self.titleLabel.text = model.title
        
        if let reps = model.reps, reps != 0 {
            self.repsLabel.text = "\(reps) x "
        }
        
        if let weight = model.weight, weight != 0 {
            self.weightLabel.text = "\(weight) Kg"
        }
        
        if let timer = model.timer, timer != 0 {
            self.timerLabel.text = "\(timer) sec"
        }
        
        self.modeView.updateMode(mode, of: model)
    }
    func configureFavoriteDetail(with model: WorkoutResponse) {
        self.titleLabel.text = model.name
        self.modeView.isHidden = true
    }
    
    private func bind() {
        self.modeView
            .actionPublisher
            .sink { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .tapCheckButton(let isTapped):
                    self.delegate?.workoutlistCollectionViewCellDidTapComplete(
                        isTapped,
                        indexPathRow: self.tag
                    )
                    
                case .tapDeleteButton(let isTapped):
                    self.delegate?.workoutlistCollectionViewCellDidTapComplete(
                        isTapped,
                        indexPathRow: self.tag
                    )
                }
            }
            .store(in: &cancellables)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        model = nil
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
        
        let labelHStack = UIStackView(arrangedSubviews: [repsLabel, weightLabel])
        labelHStack.axis = .horizontal
        labelHStack.distribution = .fill
        labelHStack.alignment = .fill
        
        let labelVStack = UIStackView(arrangedSubviews: [labelHStack, timerLabel])
        labelVStack.axis = .vertical
        labelVStack.distribution = .fill
        labelVStack.alignment = .fill
        
        [titleHStack,labelVStack]
            .forEach { uv in
                contentView.addSubview(uv)
                uv.translatesAutoresizingMaskIntoConstraints = false
            }
        
        NSLayoutConstraint.activate([
            titleHStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleHStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleHStack.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 30),
            
            labelVStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
}
