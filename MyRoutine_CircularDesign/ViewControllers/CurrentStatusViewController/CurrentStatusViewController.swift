//
//  ViewController.swift
//  MyRoutine_CircularDesign
//
//  Created by 김윤석 on 2021/04/02.
//

import UIKit
import UserNotifications

class CurrentStatusViewController: UIViewController, WorkOutTableViewControllerDelegate, UISceneDelegate {
    
    let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationItem.accessibilityElementsHidden = true
        
        view.backgroundColor = .black
        
        bringDataAndTime()
        
        drawLayers()
        
        animateCircle()
        showCurrentWorkOutLabel()
        
        appDelegate?.delegate = self
        
        TimerManager.shared.isTimeRunning = false
        
        let tappedForNextWorkOut = UITapGestureRecognizer(target: self, action: #selector(tappedForNextWorkout))
        tappedForNextWorkOut.numberOfTapsRequired = 2
        view.addGestureRecognizer(tappedForNextWorkOut)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateCircle()
    }
    
    func workOutTableViewControllerIsClosed(_ workOutTableViewController: WorkOutTableViewController) {
        animateCircle()
        showCurrentWorkOutLabel()
    }
    
    func settingTableViewControllerIsClosed(_ settingTableViewController: SettingTableViewController) {
        guard let weights = WorkOutToDoManager.shared.getCurrentWorkOut()?.weights else { return }
        
        if weights == 0 {
            self.currentWorkOutWeightLabel.text = ""
            self.currentWorkOutWeightLabel.text = ""
        } else {
            self.currentWorkOutWeightLabel.text = "\(weights)"
            self.weightStandard.text = "\(WorkOutToDoManager.shared.weightStandard)"
        }
    }
    
    @IBAction func settingViewButtonDidTapped(_ sender: Any) {
        guard let settingTableViewController = storyboard?.instantiateViewController(withIdentifier: "SettingTableViewController") as? SettingTableViewController else {return }

        HapticManager.shared.vibrateForSelection()
        settingTableViewController.delegate = self
        
        settingTableViewController.modalPresentationStyle = .pageSheet
        present(settingTableViewController, animated: true)
    }
    
    @IBAction func workOutTableViewButtonDidTapped(_ sender: Any) {
        HapticManager.shared.vibrateForSelection()
        presentWorkOutTableViewController()
    }
    
    func presentWorkOutTableViewController(){
        guard let workOutTableViewController = storyboard?.instantiateViewController(withIdentifier: "WorkOutTableViewController") as? WorkOutTableViewController else { return }
        //let workOutTableViewController = WorkOutTableViewController()
        workOutTableViewController.delegate = self
        present(workOutTableViewController, animated: true)
    }
    
    fileprivate func bringDataAndTime(){
        WorkOutToDoManager.shared.workOutToDos = Storage.retrive("todos.json", from: .documents, as: [WorkOut].self) ?? []
        TimerManager.shared.timeToBeSaved = Storage.retrive("TimeToBeSaved.json", from: .documents, as: TimeToBeSaved.self) ?? TimeToBeSaved()
        CalendarManager.shared.workOutWithDate = Storage.retrive("workOutCalendar.json", from: .documents, as: WorkOutWithDate.self) ?? WorkOutWithDate()
    }
    
    let pulsingLayer = CAShapeLayer()
    let outlineStrokeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    let timerInsideStrokeLayer = CAShapeLayer()
    
    @IBOutlet weak var currentWorkOutLabel: UILabel!
    @IBOutlet weak var nextWorkOutLabel: UILabel!
    
    @IBOutlet weak var currentWorkOutRepsLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var currentWorkOutWeightLabel: UILabel!
    @IBOutlet weak var weightStandard: UILabel!
    
    let circularPath = UIBezierPath(arcCenter: .zero, radius: 150, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
}
