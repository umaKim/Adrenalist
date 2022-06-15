//
//  FavoriteCollectionViewCell.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/15.
//

import UIKit

final class FavoriteCollectionViewCell: UICollectionViewCell {
    static let identifier = "FavoriteCollectionViewCell"
    
    private lazy var starImageView: UIImageView = {
        let uv = UIImageView()
        uv.image = UIImage(systemName: "star.fill")
        uv.tintColor = .purpleBlue
        uv.widthAnchor.constraint(equalToConstant: 16).isActive = true
        uv.heightAnchor.constraint(equalToConstant: 16).isActive = true
        return uv
    }()
    
    private lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Bench "
        lb.font = .systemFont(ofSize: 15)
        lb.textColor = .white
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
        titleLabel.text = model.title
    }
    
    func calculateCellWidth(text: String) -> CGFloat {
        titleLabel.text = text
        titleLabel.sizeToFit()
        let horizontalPadding: CGFloat = 14 * 2
        return titleLabel.frame.width + horizontalPadding + 20
    }
    
    private func setupUI() {
        layer.cornerRadius = 20
        
        backgroundColor = .vaguePurpleBlue
        
        let stackView = UIStackView(arrangedSubviews: [starImageView, titleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.distribution = .fill
        stackView.alignment = .center
        
        [stackView]
            .forEach { uv in
                uv.translatesAutoresizingMaskIntoConstraints = false
                addSubview(uv)
            }
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}
