//
//  WorkOutTableViewController.swift
//  MyRoutine_CircularDesign
//
//  Created by 김윤석 on 2021/04/02.
//

import UIKit
import AVFoundation

protocol WorkOutTableViewControllerDelegate {
    func workOutTableViewControllerIsClosed(_ workOutTableViewController: WorkOutTableViewController)
}

class WorkOutTableViewController: UIViewController, UITextFieldDelegate {

    let workoutSuggestions  = [
        "chest fly", "Chest fly", "bench press", "dip", "incline bench press", "decline bench press", "cable crossover", "pull over", "push up",
        "pull up", "row", "deadlift", "back extension", "bent over row", "chin up", "lat pulldown", "pendlay row", "seated row", "shrug", "summo deadlift",
        "military press", "lateral raise", "rear raise", "front raise", "shoulder press",
        "front squat", "wide squat", "lunge", "squat", "glute kickback", "hack squat", "hip thrust", "jump squat", "calf raise", "leg curl", "leg press", "zercher squat", "arnold press", "face pull", "side lateral raise", "overhead press", "reverse fly", "upright row", "kick back", "preacher curl", "reverse curl", "crunch", "hanging leg raise", "hanging knee raise", "oblique cruch", "plank", "side bend", "side plank", "superman", "russian twist",
        "tricep extension", "bicep curl", "hammer curl", "tricep pushdown", "skullcrush", "bench dip",
        "burpee",
        "v up", "sit up", "ab wheel",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .black

        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tableView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(cellDidPressed)))
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellDidTapped)))
        
        enterWorkOutTextField.delegate = self
        
        //deleteAllButton.isHidden = true
        
        if WorkOutToDoManager.shared.workOutToDos.isEmpty{
            deleteAllButton.isHidden = true
            doneForTodayButton.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !isCellCommingUpAnimated {
            manyCellsCommingUpAnimation()
            self.isCellCommingUpAnimated = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.delegate?.workOutTableViewControllerIsClosed(self)
    }
    
    @IBOutlet weak var enterWorkOutTextField: UITextField!
    @IBOutlet weak var enterRepsTextField: UITextField!
    @IBOutlet weak var enterWeightsTextField: UITextField!
    
    @IBAction func workOutTextFieldDidTapped(_ sender: Any) {
        enterWorkOutTextField.text = ""
    }
    
    @IBAction func repsTextFieldDidTapped(_ sender: Any) {
        enterRepsTextField.text = ""
    }
    
    @IBAction func weightsTextFieldDidTapped(_ sender: Any) {
        enterWeightsTextField.text = ""
    }
    
    
    @IBAction func addWorkOutButtonDidTapped(_ sender: Any) {
        HapticManager.shared.vibrateForSelection()
        WorkOutToDoManager.shared.createWorkOutTodo(enterWorkOutTextField.text ?? "", reps: Int(enterRepsTextField.text ?? "") ?? 0, weight: Double(enterWeightsTextField.text ?? "") ?? 0.0)
        oneCellCommingUpAnimation()
        Storage.store(WorkOutToDoManager.shared.workOutToDos, to: .documents, as: "todos.json")
        
        DispatchQueue.main.async {
                let indexPath = IndexPath(row: WorkOutToDoManager.shared.workOutToDos.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        
        self.deleteAllButton.isHidden = false
        self.doneForTodayButton.isHidden = false
    }
    
    @IBAction func deleteAllButtonDidTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete All?", message: "Are you sure you want to delete all of your workout list?", preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: UIAlertAction.Style.default,
                                         handler: {
                                            (action : UIAlertAction!) -> Void in })
        
        let deleteAllAction = UIAlertAction(title: "Delete All", style: UIAlertAction.Style.default, handler: { [weak self] alert -> Void in
            
            
            self?.deleteAllButton.isHidden = true
            self?.doneForTodayButton.isHidden = true
            
            WorkOutToDoManager.shared.workOutToDos.removeAll()
            
            self?.tableView.reloadData()
            
            self?.tableView.isEditing = false
            //self?.deleteAllButton.isHidden = true
            
            Storage.store(WorkOutToDoManager.shared.workOutToDos, to: .documents, as: "todos.json")
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAllAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func doneForTodayButtonDidTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Yes", message: "Are you sure you want to stop for this workout and save them?", preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: UIAlertAction.Style.default,
                                         handler: {
                                            (action : UIAlertAction!) -> Void in })
        
        let deleteAllAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { [weak self] alert -> Void in
            
            self?.deleteAllButton.isHidden = true
            self?.doneForTodayButton.isHidden = true
            
            let todayDate = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            if CalendarManager.shared.workOutWithDate.selectedDateWorkOutWithTime.contains(where: {
                $0.key == formatter.string(from: todayDate)
            }){
                CalendarManager.shared.workOutWithDate.selectedDateWorkOutWithTime[formatter.string(from: todayDate)]?.append(WorkOutWithTime(time: Date().description(with: .current), workOut: WorkOutToDoManager.shared.workOutToDos))
            } else {
                CalendarManager.shared.workOutWithDate.selectedDateWorkOutWithTime.updateValue([WorkOutWithTime(time: Date().description(with: .current), workOut: WorkOutToDoManager.shared.workOutToDos)], forKey: formatter.string(from: todayDate))
            }
            
            WorkOutToDoManager.shared.workOutToDos.removeAll()
            
            self?.tableView.reloadData()
            self?.tableView.isEditing = false
            
            Storage.store(CalendarManager.shared.workOutWithDate, to: .documents, as: "workOutCalendar.json")
            Storage.store(WorkOutToDoManager.shared.workOutToDos, to: .documents, as: "todos.json")
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAllAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var deleteAllButton: UIButton!
    @IBOutlet weak var doneForTodayButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var viewBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomSpace: NSLayoutConstraint!
    
    var delegate: WorkOutTableViewControllerDelegate?
    
    var isCellCommingUpAnimated: Bool = false
}
