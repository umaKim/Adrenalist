//
//  HapticManager.swift
//  MyRoutine_CircularDesign
//
//  Created by 김윤석 on 2021/04/21.
//

import UIKit

final class HapticManager {
    static let shared = HapticManager()

    func vibrateForImpactFeedback(intensity: CGFloat) {
        let generator = UIImpactFeedbackGenerator()
        generator.prepare()
        generator.impactOccurred()
        generator.impactOccurred(intensity: intensity)
    }

    func vibrateForSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }

    func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    private init() {}
}
