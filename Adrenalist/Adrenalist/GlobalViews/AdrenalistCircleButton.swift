//
//  AdrenalistCircleButton.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/05/03.
//

import UIKit.UIButton

final class AdrenalistCircleButton: UIButton {

    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    private func setupUI() {
        let image = self.isSelected ? UIImage(systemName: "circle") : UIImage(systemName: "circle.fill")
        tintColor = .pinkishRed
        
        var configuration = Configuration.plain()
        configuration.image = image
        self.configuration = configuration
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class AdrenalistImageButton: UIButton {
    init(
        image: UIImage?
    ) {
        super.init(frame: .zero)
        tintColor = .pinkishRed
        
        var configuration = Configuration.plain()
        configuration.image = image
        self.configuration = configuration
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let biggerFrame = bounds.insetBy(dx: -10, dy: -10)
        return biggerFrame.contains(point)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
