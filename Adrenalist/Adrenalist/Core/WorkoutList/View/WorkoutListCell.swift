//
//  WorkoutListCell.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/28.
//
import Combine
import UIKit.UICollectionViewCell

enum WorkoutListCellAction: Equatable {
    case edit(Int)
    case delete(Int)
}

protocol WorkoutListCellDelegate: AnyObject {
    func delete(at index: Int)
    func delete(cell: UICollectionViewCell)
    func edit(at index: Int)
}

final class WorkoutListCell: UICollectionViewCell {
    static let identifier = "WorkoutListCell"
    
    private lazy var editButton     = AdrenalistImageButton(image: UIImage(systemName: Constant.ButtonImage.editting))
    private lazy var deleteButton   = AdrenalistImageButton(image: UIImage(systemName: Constant.ButtonImage.xmark))
    private lazy var circleButton   = AdrenalistCircleButton()
    private lazy var titleLabel     = AdrenalistLabel(text: "")
    private lazy var repsLabel      = AdrenalistLabel(text: "")
    private lazy var weightLabel    = AdrenalistLabel(text: "")
    
    private(set) lazy var actionPublisher    = actionSubject.eraseToAnyPublisher()
    private let actionSubject      = PassthroughSubject<WorkoutListCellAction, Never>()
    
    private var cancellables: Set<AnyCancellable>
    
    weak var delegate: WorkoutListCellDelegate?
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        
        bind()
        setupWorkoutUI()
        setupTimerUI()
        
        backgroundColor = .darkGray
    }
    
    private func bind() {
        deleteButton
            .tapPublisher
            .sink { _ in
//                self.actionSubject.send(.delete(self.tag))
//                self.delegate?.delete(at: self.tag)
                self.delegate?.delete(cell: self)
            }
            .store(in: &cancellables)
        
        editButton
            .tapPublisher
            .sink { _ in
//                self.actionSubject.send(.edit(self.tag))
                self.delegate?.edit(at: self.tag)
            }
            .store(in: &cancellables)
    }
    
    func configure(with workout: Item, mode: UpdateMode?) {
        let image = workout.isDone ? UIImage(systemName: "circle.fill") : UIImage(systemName: "circle")
        circleButton.setImage(image, for: .normal)
        titleLabel.text = workout.title
        
        if let reps = workout.reps {
            repsLabel.text = "\(reps)"
        }
        
        if let weight = workout.weight {
            weightLabel.text = "\(weight) kg"
        }
        
        switch mode {
        case .delete:
            deleteButton.isHidden = false
            editButton.isHidden = true
            circleButton.isHidden = true
//            shakeIcons()
            
        case .edit:
            deleteButton.isHidden = true
            editButton.isHidden = false
            circleButton.isHidden = true
//            shakeIcons()
            
        case .none:
            deleteButton.isHidden = true
            editButton.isHidden = true
            circleButton.isHidden = false
//            stopShakingIcons()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        repsLabel.text = nil
        weightLabel.text = nil
    }
    
    private func setupWorkoutUI() {
        layer.cornerRadius = 12
        
        [editButton, deleteButton, circleButton, titleLabel, repsLabel, weightLabel].forEach { uv in
            self.contentView.addSubview(uv)
            uv.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            editButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            editButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            circleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            circleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: circleButton.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 5),
            
            repsLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 16),
            repsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            weightLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupTimerUI() {
        
    }
    
    private func shakeIcons() {
        let shakeAnim = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnim.duration = 0.05
        shakeAnim.repeatCount = 2
        shakeAnim.autoreverses = true
        //        let startAngle: Float = (-2) * 3.14159/180
        let startAngle: Float = (-1) * 3.14159/180
        let stopAngle = -startAngle
        shakeAnim.fromValue = NSNumber(value: startAngle)
        shakeAnim.toValue = NSNumber(value: 3 * stopAngle)
        shakeAnim.autoreverses = true
        shakeAnim.duration = 0.2
        shakeAnim.repeatCount = 10000
        shakeAnim.timeOffset = 290 * drand48()
        
        //Create layer, then add animation to the element's layer
        let layer: CALayer = self.layer
        layer.add(shakeAnim, forKey:"shaking")
    }
    
    // This function stop shaking the collection view cells
    private func stopShakingIcons() {
        let layer: CALayer = self.layer
        layer.removeAnimation(forKey: "shaking")
        self.deleteButton.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
