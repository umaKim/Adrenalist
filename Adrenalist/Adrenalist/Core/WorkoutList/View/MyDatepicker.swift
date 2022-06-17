//
//  MyDatepicker.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/14.
//

import UIKit.UICollectionView

struct MyScrollableDatepickerModel: Equatable {
    let date: Date
    let isSelected: Bool
}

protocol MyScrollableDatepickerDelegate: AnyObject {
    func datepicker(_ datepicker: MyScrollableDatepicker, didSelectDate date: MyScrollableDatepickerModel)
    func datepicker(_ datepicker: MyScrollableDatepicker, didScroll index: IndexPath)
}

class MyScrollableDatepicker: UIView {
    public weak var delegate: MyScrollableDatepickerDelegate?
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.register(MyScrollableDatepickerCell.self, forCellWithReuseIdentifier: MyScrollableDatepickerCell.identifier)
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .black
        return cv
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var cellConfiguration: ((_ cell: MyScrollableDatepickerCell, _ isWeekend: Bool, _ isSelected: Bool) -> Void)? {
        didSet {
            collectionView.reloadData()
        }
    }
    public var dates = [MyScrollableDatepickerModel]()
    
    public func initialUISetup() {
        collectionView.reloadData()
        let today = MyScrollableDatepickerModel(date: Date().stripTime(), isSelected: false)
        guard let index =  dates.firstIndex(of: today)?.description else { return }
        let indexInt = Int(index) ?? 0
        let indexPath = IndexPath(row: Int(indexInt), section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
    
    public func updateDateSet(with date: MyScrollableDatepickerModel) {
        let index = dates.firstIndex(of: date)?.description ?? "0"
        let indexInt = Int(index) ?? 0
        
        //TODO: Need to simplify(Refactor) this area
        dates.forEach { date in
            if date.isSelected {
                let selectedIndex = dates.firstIndex(of: date)?.description ?? "0"
                let indexInt = Int(selectedIndex) ?? 0
                self.dates[indexInt] = MyScrollableDatepickerModel(date: date.date, isSelected: false)
                let indexPath = IndexPath(row: indexInt, section: 0)
                collectionView.reloadItems(at: [indexPath])
            }
        }
        
        let newDate = MyScrollableDatepickerModel(date: date.date, isSelected: true)
        dates[indexInt] = newDate
        let indexPath = IndexPath(row: indexInt, section: 0)
        collectionView.reloadItems(at: [indexPath])
    }
    
    public var selectedDate: Date? {
        didSet {
            collectionView.reloadData()
        }
    }
    public var configuration = Configuration() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var setDates: Void {
        var dates = [MyScrollableDatepickerModel]()
        for day in 1...36500 {
            let secondsInDay = 86400
            let date = MyScrollableDatepickerModel(date: Date(timeIntervalSince1970: Double(day * secondsInDay)).stripTime(),
                                                   isSelected: false)
            dates.append(date)
        }
        self.dates = dates
    }
    
//    public func updateDates(_ dates: [MyScrollableDatepickerModel]) {
//        self.dates = dates
//    }
}

// MARK: - UICollectionViewDataSource

extension MyScrollableDatepicker: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyScrollableDatepickerCell.identifier,
                                                            for: indexPath) as? MyScrollableDatepickerCell
        else {return UICollectionViewCell()}

        let date = dates[indexPath.row]
        cell.setup(date: date)
        return cell
    }

    private func isWeekday(date: Date) -> Bool {
        return Calendar.current.isDateInWeekend(date)
    }

    private func isSelected(date: Date) -> Bool {
        guard let selectedDate = selectedDate else {
            return false
        }
        return Calendar.current.isDate(date, inSameDayAs: selectedDate)
    }
}

extension MyScrollableDatepicker: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.datepicker(self, didSelectDate: dates[indexPath.row])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MyScrollableDatepicker: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 68, height: 80)
    }
}

extension MyScrollableDatepicker: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            guard let index = collectionView.indexPath(for: cell) else { return }
            delegate?.datepicker(self, didScroll: index)
        }
    }
}


public struct Configuration {

    public enum DaySizeCalculationStrategy {
        case constantWidth(CGFloat)
        case numberOfVisibleItems(Int)
    }

    public var daySizeCalculation: DaySizeCalculationStrategy = DaySizeCalculationStrategy.numberOfVisibleItems(5)


    // MARK: - Styles

    public var defaultDayStyle: DayStyleConfiguration = {
        var configuration = DayStyleConfiguration()

        configuration.dateTextFont = .systemFont(ofSize: 20, weight: UIFont.Weight.thin)
        configuration.dateTextColor = .black

        configuration.weekDayTextFont = .systemFont(ofSize: 8, weight: UIFont.Weight.thin)
        configuration.weekDayTextColor = .black

        configuration.monthTextFont = .systemFont(ofSize: 8, weight: UIFont.Weight.light)
        configuration.monthTextColor = .gray

        configuration.selectorColor = .clear
        configuration.backgroundColor = .white

        return configuration
    }()

    public var weekendDayStyle: DayStyleConfiguration = {
        var configuration = DayStyleConfiguration()
        configuration.weekDayTextFont = .systemFont(ofSize: 8, weight: UIFont.Weight.bold)
        return configuration
    }()

    public var selectedDayStyle: DayStyleConfiguration = {
        var configuration = DayStyleConfiguration()
        configuration.selectorColor = UIColor(red: 242.0/255.0, green: 93.0/255.0, blue: 28.0/255.0, alpha: 1.0)
        return configuration
    }()


    // MARK: - Configuration
    @available(*, deprecated, message: "Use daySizeCalculation property")
    public var numberOfDatesInOneScreen: Int = 5 {
        didSet {
            daySizeCalculation = .numberOfVisibleItems(numberOfDatesInOneScreen)
        }
    }
    

    // MARK: - Initializer
    public init() {
    }


    // MARK: - Methods

    public func calculateDayStyle(isWeekend: Bool, isSelected: Bool) -> DayStyleConfiguration {
        var style = defaultDayStyle

        if isWeekend {
            style = style.merge(with: weekendDayStyle)
        }

        if isSelected {
            style = style.merge(with: selectedDayStyle)
        }

        return style
    }
}


public struct DayStyleConfiguration {

    public var dateTextFont: UIFont?
    public var dateTextColor: UIColor?

    public var weekDayTextFont: UIFont?
    public var weekDayTextColor: UIColor?

    public var monthTextFont: UIFont?
    public var monthTextColor: UIColor?

    public var selectorColor: UIColor?
    public var backgroundColor: UIColor?


    // MARK: - Initializer
    public init() {
    }


    public func merge(with style: DayStyleConfiguration) -> DayStyleConfiguration {
        var newStyle = DayStyleConfiguration()

        newStyle.dateTextFont = style.dateTextFont ?? dateTextFont
        newStyle.dateTextColor = style.dateTextColor ?? dateTextColor

        newStyle.weekDayTextFont = style.weekDayTextFont ?? weekDayTextFont
        newStyle.weekDayTextColor = style.weekDayTextColor ?? weekDayTextColor

        newStyle.monthTextFont = style.monthTextFont ?? monthTextFont
        newStyle.monthTextColor = style.monthTextColor ?? monthTextColor

        newStyle.selectorColor = style.selectorColor ?? selectorColor
        newStyle.backgroundColor = style.backgroundColor ?? backgroundColor

        return newStyle
    }

}
