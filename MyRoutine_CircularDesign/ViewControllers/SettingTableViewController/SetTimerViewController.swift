//
//  SetTimerViewController.swift
//  MyRoutine_CircularDesign
//
//  Created by 김윤석 on 2021/04/19.
//

import UIKit

class SetTimerViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        counter = TimerManager.shared.timeToBeSaved.countUptoThisSec
        //print(timeLabel.text)
        updateTimeLabel(with: counter)
        view.backgroundColor = .black
    }
    @IBAction func closeButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addFiveSecondDidTapped(_ sender: Any) {
        counter += 5
        updateTimeLabel(with: counter)
        
    }
    
    @IBAction func addTenSecondDidTapped(_ sender: Any) {
        counter += 10
        updateTimeLabel(with: counter)
    }
    
    @IBAction func addThirtySecondDidTapped(_ sender: Any) {
        counter += 30
        updateTimeLabel(with: counter)
    }
    
    @IBAction func resetButtonDidTapped(_ sender: Any) {
        counter = 0
        updateTimeLabel(with: counter)
    }
    
    private func updateTimeLabel(with counter: Int){
        timeLabel.text = "\(counter) Sec"
        HapticManager.shared.vibrateForSelection()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        TimerManager.shared.timeToBeSaved.countUptoThisSec = counter
        Storage.store(TimerManager.shared.timeToBeSaved, to: .documents, as: "TimeToBeSaved.json")
    }
}
