//
//  CalendarViewController.swift
//  MyRoutine_CircularDesign
//
//  Created by 김윤석 on 2021/04/09.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDelegate, FSCalendarDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WorkOutToDoManager.shared.workOutToDos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? workoutCell else { return UITableViewCell()}
        cell.workout.text = WorkOutToDoManager.shared.workOutToDos[indexPath.row].workOutName

        return cell
    }


    //@IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var dataView: UIView!

    @IBOutlet weak var totalVolume: UILabel!
    @IBOutlet weak var totalWeight: UILabel!

    //@IBOutlet weak var tableView: UITableView!
    @IBAction func saveButtonDidTapped(_ sender: Any) {
        print("save")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        drawTrackLayer()
        drawOutlineStrokeLayer()
        outlineStrokeLayer.strokeEnd = 0
        WorkOutToDoManager.shared.calculateDonePercentage()
        guard let percentage = WorkOutToDoManager.shared.donePercentage else { return }
        outlineStrokeLayer.strokeEnd = percentage / 100.0
        animateRedCircle()

        totalVolume.text = "Volume: \(WorkOutToDoManager.shared.getTotalVolume()!)Kg"
        totalWeight.text = "Total Weight:"

        calendar.delegate = self
        calendar.dataSource = self

       // calendar.backgroundColor = .systemBackground

        fakeModels.append(FakeModel(date: "01-04-2021", workOut: [WorkOut(contents: "PullUp", reps: 12, weights: 20.0, isCompleted: false),
                                                                  WorkOut(contents: "DeadLift", reps: 20, weights: 40.0, isCompleted: false)]))

        fakeModels.append(FakeModel(date: "04-04-2021", workOut: [WorkOut(contents: "BenchPress", reps: 12, weights: 60.0, isCompleted: false)]))

        fakeModels.append(FakeModel(date: "06-04-2021", workOut: [WorkOut(contents: "Squat", reps: 15, weights: 60.0, isCompleted: false)]))
    }

    var fakeModels: [FakeModel] = []
    var count = 0

    struct FakeModel {
        var date: String
        var workOut: [WorkOut]
    }

    var formatter = DateFormatter()

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        var dates: [String] = []
        fakeModels.forEach { dates.append($0.date) }
        formatter.dateFormat = "dd-MM-yyyy"

//        for index in 0..<dates.count {
//
//            print(dates[index])
//
//            let eventDate = formatter.date(from: dates[index])!
//
//
//            print(count)
//            count += 1
//
//            if date.compare(eventDate) == .orderedSame {
//                return 1
//            }
//            return 0
//        }
        let eventDate = formatter.date(from: date.description)
        print(eventDate)
        if dates.contains(date.description){
            return 1
        }
        return 0

//        formatter.dateFormat = "dd-MM-yyyy"
//        guard let eventDate = formatter.date(from: "13-04-2021") else {return 0}
//        if date.compare(eventDate) == .orderedSame {
//            return 1
//        }
//        return 0
    }


    let circularPath = UIBezierPath(arcCenter: .zero, radius: 80, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)

    let outlineStrokeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()


}

extension CalendarViewController {
    func drawOutlineStrokeLayer() {
        outlineStrokeLayer.path = circularPath.cgPath
        outlineStrokeLayer.strokeColor = UIColor(red: 234/255, green: 46/255, blue: 111/255, alpha: 1).cgColor
        outlineStrokeLayer.lineWidth = 20
        outlineStrokeLayer.fillColor = UIColor.clear.cgColor
        outlineStrokeLayer.lineCap = CAShapeLayerLineCap.round
        outlineStrokeLayer.strokeEnd = 0
        outlineStrokeLayer.position = CGPoint(x: 100, y: 100)
        outlineStrokeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 0, 1)
        //view.layer.addSublayer(outlineStrokeLayer)
        dataView.layer.addSublayer(outlineStrokeLayer)
    }

    func drawTrackLayer() {
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor(red: 56/255, green: 25/255, blue: 49/255, alpha: 1).cgColor
        trackLayer.lineWidth = 20
        trackLayer.fillColor = UIColor.black.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.position = .init(x: 100.0, y: 100.0)

        dataView.layer.addSublayer(trackLayer)
    }

    func animateRedCircle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.duration = 0.5
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        outlineStrokeLayer.add(basicAnimation, forKey: "Basic")
    }
}

class workoutCell: UITableViewCell{
    @IBOutlet weak var workout: UILabel!

}
