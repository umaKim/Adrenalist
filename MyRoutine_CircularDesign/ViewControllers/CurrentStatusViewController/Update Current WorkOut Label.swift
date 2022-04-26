//
//  extension.swift
//  MyRoutine_CircularDesign
//
//  Created by 김윤석 on 2021/04/07.
//

import Foundation

extension CurrentStatusViewController {
    func showCurrentWorkOutLabel() {
        DispatchQueue.main.async {

            if WorkOutToDoManager.shared.workOutToDos.isEmpty {
                self.currentWorkOutLabel.text = ""
                self.nextWorkOutLabel.text = ""
                self.currentWorkOutRepsLabel.text = ""
                self.currentWorkOutWeightLabel.text = ""
                self.repsLabel.text = ""
                self.weightStandard.text = ""
                return
            }
            
            self.currentWorkOutLabel.text = WorkOutToDoManager.shared.getCurrentWorkOut()?.workOutName.description.uppercased()
            self.nextWorkOutLabel.text = WorkOutToDoManager.shared.getNextWorkOut()?.workOutName.description.uppercased()
            
            guard let reps = WorkOutToDoManager.shared.getCurrentWorkOut()?.reps,
                  let weights = WorkOutToDoManager.shared.getCurrentWorkOut()?.weights else { return }
            
            
            if reps == 0 {
                self.currentWorkOutRepsLabel.text = ""
                self.repsLabel.text = ""
            } else {
                self.currentWorkOutRepsLabel.text = "\(reps)"
                self.repsLabel.text = "Reps"
            }
            
            if weights == 0 {
                self.currentWorkOutWeightLabel.text = ""
                self.weightStandard.text = ""
            } else {
                self.currentWorkOutWeightLabel.text = "\(weights)"
                self.weightStandard.text = "\(WorkOutToDoManager.shared.weightStandard)"
            }
            
            self.currentWorkOutRepsLabel.textColor = .white
            self.repsLabel.textColor = .white
            self.currentWorkOutWeightLabel.textColor = .white
            self.weightStandard.textColor = .white
        }
    }
}
