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

    private var workout: Workout?

    func configure(with workout: Workout) {
        self.workout = workout
        titleLabel.text = workout.title

        backgroundColor = .gray

        update()
    }

    func update() {
//        workout?.isDone.toggle()
//        PersistanceManager.shared.saveWorkouts(<#T##workouts: [Workout]##[Workout]#>)
//        WorkOutToDoManager.shared.completeCurrentWorkOut()
    }

    private func setupUI() {
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

//    // This function shake the collection view cells
//    func shakeIcons() {
//      let shakeAnim = CABasicAnimation(keyPath: "transform.rotation")
//      shakeAnim.duration = 0.05
//      shakeAnim.repeatCount = 2
//      shakeAnim.autoreverses = true
//      let startAngle: Float = (-2) * 3.14159/180
//      var stopAngle = -startAngle
//        shakeAnim.fromValue = NSNumber(value: startAngle)
//        shakeAnim.toValue = NSNumber(value: 3 * stopAngle)
//      shakeAnim.autoreverses = true
//      shakeAnim.duration = 0.2
//      shakeAnim.repeatCount = 10000
//      shakeAnim.timeOffset = 290 * drand48()
//
//      //Create layer, then add animation to the element's layer
//      let layer: CALayer = self.layer
//        layer.add(shakeAnim, forKey:"shaking")
//      shakeEnabled = true
//    }
//
//    // This function stop shaking the collection view cells
//    func stopShakingIcons() {
//      let layer: CALayer = self.layer
//      layer.removeAnimationForKey("shaking")
//      self.deleteButton.hidden = true
//      shakeEnabled = false
//    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
