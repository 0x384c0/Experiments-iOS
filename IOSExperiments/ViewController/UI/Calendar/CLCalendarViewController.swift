//
//  CLCalendarViewController.swift
//  CalendarPickerExperiments
//
//  Created by Andrew Ashurow on 16.11.16.
//  Copyright © 2016 Andrew Ashurow. All rights reserved.
//

import UIKit
import FSCalendar

class CLCalendarViewController: UIViewController {
    
    @IBOutlet weak var calendarView: FSCalendar!
    let range = DateRange()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.scrollDirection = .vertical
        
//        calendarView.handleScopeGesture(<#T##sender: UIPanGestureRecognizer##UIPanGestureRecognizer#>)
//        calendarView.scopeGesture.isEnabled = true
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.placeholderType = .none
        calendarView.collectionView
            .register(
                CustomHeader.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "header"
        )
        
        
        print(calendarView.dataSource?.minimumDate ?? "nil")
    }
}


class DateRange{
    var
    start:Date?,
    end:Date?
    
    func dateTap(_ date:Date){
        if start == nil , end == nil{
            print("case 1")
            start = date
            return
        }
        if start != nil, end == nil{
            print("case 2")
            if start!.timeIntervalSince1970 > date.timeIntervalSince1970 {
                end = start
                self.start = date
            } else {
                end = date
            }
            return
        }
        if start != nil && end != nil {
            print("case 3")
            start = date
            end = nil
            return
        }
        print("ERROR")
    }
    
    func generateDateRange() -> [Date]{
        return generateDateRange(start:start,end:end)
    }
    
    private func generateDateRange(start:Date?,end:Date?) -> [Date]{
        var result = [Date]()
        if let start = start,let end = end{
            var dateTmp = start
            result.append(start)
            
            while dateTmp.addingTimeInterval(24*60*60).timeIntervalSince1970 <= end.timeIntervalSince1970{
                dateTmp = dateTmp.addingTimeInterval(24*60*60)
                result.append(dateTmp)
            }
            
        } else if let start = start{
            result.append(start)
        }
        return result
    }
}

extension CLCalendarViewController : FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        dateTap(calendar,didDeselect: date)
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        dateTap(calendar,didDeselect: date)
    }
    func dateTap(_ calendar: FSCalendar, didDeselect date: Date){
        print(date)
        range.dateTap(date)
        
        for date in calendar.selectedDates{
            if date.timeIntervalSince1970 != range.start?.timeIntervalSince1970{
                calendar.deselect(date)
            }
        }
        for date in range.generateDateRange(){
            calendar.select(date,scrollToDate: false)
        }
    }
}

extension CLCalendarViewController : FSCalendarDataSource{
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}


class CustomHeader : FSCalendarStickyHeader {
    override init(frame: CGRect) {
        super.init(frame: frame)
        clearBorder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        clearBorder()
    }
    
    
    
    func clearBorder(){
        subviews[safe:0]?.subviews[safe:1]?.backgroundColor = UIColor.red
    }
    
}
