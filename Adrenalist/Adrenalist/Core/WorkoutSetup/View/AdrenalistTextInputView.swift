//
//  AdrenalistTextInputView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/17.
//
import Combine
import CombineCocoa
import UIKit

enum AdrenalistTextInputViewAction {
    case textFieldDidChange(String)
}

class AdrenalistTextInputView: UIView {
    
    private let titleLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .white
        return lb
    }()
    
    private let textField: UITextField = {
       let tf = UITextField()
        tf.textAlignment = .right
        tf.textColor = .white
        tf.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return tf
    }()
    
    func setupValue(_ text: String) {
        self.textField.text = text
    }
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<AdrenalistTextInputViewAction, Never>()
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        bind()
        setupUI()
    }
    
    convenience init(
        title: String,
        placeholder: String,
        keyboardType: UIKeyboardType
    ) {
        self.init()
        self.titleLabel.text = title
        self.textField.placeholder = placeholder
        self.textField.keyboardType = keyboardType
    }
    
    private var action: ((UITextField) -> Void)?
    
    convenience init(
        title: String,
        placeholder: String,
        completion: @escaping (UITextField) -> Void
    ) {
        self.init()
        self.titleLabel.text = title
        self.textField.placeholder = placeholder
        self.action = completion
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(textFieldDidTap))
        textField.addGestureRecognizer(gesture)
    }
    
    @objc
    private func textFieldDidTap() {
        guard
            let action = action
        else { return }
        action(textField)
    }
    
    private func bind() {
        textField
            .textPublisher
            .compactMap({$0})
            .sink { text in
            self.actionSubject.send(.textFieldDidChange(text))
        }
        .store(in: &cancellables)
        
        textField
            .didBeginEditingPublisher
            .sink {[weak self] _ in
                self?.textField.text = ""
                self?.actionSubject.send(.textFieldDidChange(""))
        }
        .store(in: &cancellables)
    }
    
    private func setupUI() {
        layer.cornerRadius = 20
        
        let sv = UIStackView(arrangedSubviews: [titleLabel, textField])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        
        [sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            sv.centerYAnchor.constraint(equalTo: centerYAnchor),
            sv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    let fruits = ["사과", "배", "포도", "망고", "딸기", "바나나", "파인애플"]
}

//extension AdrenalistTextInputView: UIPickerViewDelegate, UIPickerViewDataSource {
//    func createPickerView() {
//        let pickerView = UIPickerView()
//        pickerView.typ
//        pickerView.delegate = self
//        textField.inputView = pickerView
//    }
//
//    func dismissPickerView() {
//        let toolBar = UIToolbar()
//        toolBar.sizeToFit()
//        let button = UIBarButtonItem(title: "선택", style: .plain, target: nil, action: nil)
//        toolBar.setItems([button], animated: true)
//        toolBar.isUserInteractionEnabled = true
//        textField.inputAccessoryView = toolBar
//    }
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//           return 1
//       }
//
//
//       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//           return fruits.count
//       }
//
//
//       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//          return fruits[row]
//       }
//
//
//       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//           textField.text = fruits[row]
//       }
//
//}
