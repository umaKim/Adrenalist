//
//  WorkOutListCell.swift
//  MyRoutine_CircularDesign
//
//  Created by 김윤석 on 2021/04/07.
//

import UIKit

class WorkOutListCell: UITableViewCell {
    var doneButtonTapHandler: (() -> Void)?
    var cellTapHandler: (()->Void)?
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var workOutLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var weightsLabel: UILabel!
    
    @IBAction func cellButtonDidTapped(_ sender: Any) {
        cellTapHandler?()
    }
    
    @IBAction func doneButtonDidTapped(_ sender: Any) {
        doneButtonTapHandler?()
    }
    
    func updateUI(for workOutToDo: WorkOut) {
        doneButton.isSelected = workOutToDo.isDone
        
        if workOutToDo.workOutName == ""{
            workOutLabel.text = ""
        } else {
            workOutLabel.text = workOutToDo.workOutName
        }
        
        if workOutToDo.reps == 0 {
            repsLabel.text = ""
        } else {
            repsLabel.text = String(workOutToDo.reps)
        }
        
        if workOutToDo.weights == 0.0 {
            weightsLabel.text = ""
        } else {
            weightsLabel.text = "\(workOutToDo.weights) \(WorkOutToDoManager.shared.weightStandard)"
        }
        
        workOutLabel.alpha = workOutToDo.isDone ? 0.2 : 1
        repsLabel.alpha = workOutToDo.isDone ? 0.2 : 1
        weightsLabel.alpha = workOutToDo.isDone ? 0.2 : 1
    }
}
