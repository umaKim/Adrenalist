//
//  MyDatePickerCell.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/14.
//


import FlexLayout
import PinLayout
import UIKit.UICollectionViewCell

final class MyScrollableDatepickerCell: UICollectionViewCell {
    static let identifier = "MyScrollableDatepickerCell"
    
    private lazy var dayLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .white
        lb.font = lb.font.withSize(13)
        lb.numberOfLines = 0 // Allow multiple lines
        lb.lineBreakMode = .byWordWrapping // Handle text wrapping
        lb.textAlignment = .center // Optional: Center the text
        return lb
    }()
    
    private lazy var dateLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = UIFont.boldSystemFont(ofSize: 25)
        return lb
    }()
    
    private lazy var dot: UIView = {
       let uv = UIView()
        uv.backgroundColor = .purpleBlue
        uv.widthAnchor.constraint(equalToConstant: 6).isActive = true
        uv.heightAnchor.constraint(equalToConstant: 6).isActive = true
        uv.layer.cornerRadius = 3
        return uv
    }()
    
    // MARK: - Setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        layer.borderColor = nil
        
        dateLabel.text = nil
        dayLabel.text = nil
    }
    
    func setup(date: MyScrollableDatepickerModel) {
        let formatter = DateFormatter()

        formatter.dateFormat = "dd"
        dateLabel.text = formatter.string(from: date.date)
        dateLabel.textColor = .white

        formatter.dateFormat = "EEE"
        dayLabel.text = formatter.string(from: date.date).uppercased()
        dayLabel.textColor = .white
        
        backgroundColor = date.date == Date().stripTime() ? .purpleBlue : .darkNavy
        
        if date.isSelected {
            layer.borderColor = UIColor.purpleBlue.cgColor
        }
        
        self.dot.isHidden = !date.isDot
    }
    
    private let rootFlexContainer = UIView()

    
    private func setupUI() {
        layer.cornerRadius = 16
        layer.borderWidth = 1
        
        let sv = UIStackView(arrangedSubviews: [dayLabel, dateLabel, dot])
        sv.distribution = .fill
        sv.alignment = .center
        sv.axis = .vertical
        sv.spacing = 2
        
        [sv].forEach { uv in
            addSubview(uv)
            uv.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            sv.centerXAnchor.constraint(equalTo: centerXAnchor),
            sv.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
//    private func setupUI() {
//           layer.cornerRadius = 16
//           layer.borderWidth = 1
//        
//        contentView.addSubview(rootFlexContainer)
////        rootFlexContainer.flex
////            .alignItems(.center)
////            .justifyContent(.center)
////            .define { (flex) in
////                flex.addItem(dayLabel)
////                flex.addItem(dateLabel).marginTop(2)
////                flex.addItem(dot).size(6).marginTop(2)
////            }
//        
//        rootFlexContainer.flex
//            .alignItems(.center)
//            .justifyContent(.center)
////            .padding(0)
//            .define { (flex) in
//                flex.addItem(dayLabel).grow(1).shrink(1)
//                flex.addItem(dateLabel).marginTop(2).shrink(1).grow(1)
//                flex.addItem(dot).size(6).marginTop(2)
//            }
//    }
    
//    override func layoutSubviews() {
//            super.layoutSubviews()
//            rootFlexContainer.pin.all()
//            rootFlexContainer.flex.layout()
//        }
}
