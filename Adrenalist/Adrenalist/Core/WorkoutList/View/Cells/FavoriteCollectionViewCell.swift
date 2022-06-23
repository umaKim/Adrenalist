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
        let lb = UILabel(frame: .zero)
        lb.font = .systemFont(ofSize: 15)
        lb.textColor = .white
        lb.sizeToFit()
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
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
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}