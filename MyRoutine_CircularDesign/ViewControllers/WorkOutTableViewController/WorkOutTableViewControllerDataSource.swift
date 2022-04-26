//
//  DescribeCells.swift
//  MyRoutine_CircularDesign
//
//  Created by 김윤석 on 2021/04/06.
//

import UIKit

//Describe Cells
extension WorkOutTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WorkOutToDoManager.shared.workOutToDos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkOutListCell") as? WorkOutListCell else { return UITableViewCell()}
        
        var workOutToDo = WorkOutToDoManager.shared.workOutToDos[indexPath.row]
        
        if workOutToDo.workOutName == ""{
            cell.workOutLabel.text = ""
        } else {
            cell.workOutLabel.text = workOutToDo.workOutName
        }
        
        if workOutToDo.reps == 0 {
            cell.repsLabel.text = ""
        } else {
            cell.repsLabel.text = String(workOutToDo.reps)
        }
        
        if workOutToDo.weights == 0.0 {
            cell.weightsLabel.text = ""
        } else {
            cell.weightsLabel.text = "\(workOutToDo.weights) \(WorkOutToDoManager.shared.weightStandard)"
        }
        
        cell.textLabel?.textColor = UIColor.cyan
        cell.updateUI(for: workOutToDo)
        
//        cell.doneButtonTapHandler = {
//            WorkOutToDoManager.shared.workOutToDos[indexPath.row].isDone = !WorkOutToDoManager.shared.workOutToDos[indexPath.row].isDone
//            cell.updateUI(for: WorkOutToDoManager.shared.workOutToDos[indexPath.row])
//            Storage.store(WorkOutToDoManager.shared.workOutToDos, to: .documents, as: "todos.json")
//            
//            let bounds = cell.bounds
//
//            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn) {
//                cell.bounds = CGRect(x: bounds.origin.x - 10, y: bounds.origin.y, width: bounds.size.width + 30, height: bounds.size.height)
//            } completion: { (sucess: Bool) in
//                if sucess {
//                    UIView.animate(withDuration: 0.1) {
//                        cell.bounds = bounds
//                    }
//                }
//            }
//        }
        
        cell.cellTapHandler = {
            
            SoundManager.shared.playSound("plasticClickButtonSound")
            HapticManager.shared.vibrateForSelection()
            let bounds = cell.bounds
            
            UIView.animate(withDuration: 0.05, delay: 0, options: .curveEaseIn) {
                cell.bounds = CGRect(x: bounds.origin.x - 10, y: bounds.origin.y, width: bounds.size.width + 30, height: bounds.size.height)
            } completion: { (sucess: Bool) in
                if sucess {
                    UIView.animate(withDuration: 0.05) {
                        cell.bounds = bounds
                    }
                }
            }
            
            workOutToDo.isDone = !workOutToDo.isDone
            cell.updateUI(for: workOutToDo)
            WorkOutToDoManager.shared.workOutToDos[indexPath.row] = workOutToDo
            Storage.store(WorkOutToDoManager.shared.workOutToDos, to: .documents, as: "todos.json")
            
           // self.deleteAllButton.isHidden = true
            self.tableView.isEditing = false
            self.enterWorkOutTextField.resignFirstResponder()
            self.enterRepsTextField.resignFirstResponder()
        }
        return cell
    }
}
