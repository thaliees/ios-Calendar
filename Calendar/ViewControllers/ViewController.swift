//
//  ViewController.swift
//  Calendar
//
//  Created by Thaliees on 9/30/19.
//  Copyright © 2019 Thaliees. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let FormatterDate:DateFormatter = DateFormatter()
    private var isExpanded = false
    private var keyDate:String = ""
    private var selectedDateByUser = Date()
    private var data:[CalendarEventInfo] = [CalendarEventInfo]()
    private var dictionaryDots:[String:[String]] = [:]
    private var dictionaryEvents:[String:[ScheduledEvents]] = [:]
    
    @IBOutlet weak var calendarCollection: JTACMonthView!
    @IBOutlet weak var guideCollection: UICollectionView!
    @IBOutlet weak var guide: UIButton!
    @IBOutlet weak var heightCalendar: NSLayoutConstraint!
    @IBOutlet weak var heightCollectionDate: NSLayoutConstraint!
    @IBOutlet weak var heightGuide: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureCollection()
        getDataServer()
    }
    
    @IBAction func showGuide(_ sender: UIButton) {
        if isExpanded {
            isExpanded = false
            guideCollection.isHidden = true
            heightCalendar.constant = 310
        }
        else {
            isExpanded = true
            setHeightGuide()
        }
    }
    
    @IBAction func resizeCalendarAction(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == UISwipeGestureRecognizer.Direction.down {
            sender.direction = UISwipeGestureRecognizer.Direction.up
            numberOfRows = 6
            heightCalendar.constant = 310
            heightCollectionDate.constant = 270
            heightGuide.constant = 27
            hiddenViews(value: false)
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
                self.updateCollection(date: self.selectedDateByUser)
            })
        }
        else if sender.direction == UISwipeGestureRecognizer.Direction.up {
            sender.direction = UISwipeGestureRecognizer.Direction.down
            numberOfRows = 1
            heightCalendar.constant = 100
            heightCollectionDate.constant = 90
            heightGuide.constant = 0
            hiddenViews(value: true)
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }) { completed in
                self.calendarCollection.reloadData(withAnchor: self.selectedDateByUser)
            }
        }
    }
    
    private func configureCollection() {
        calendarCollection.scrollDirection = .horizontal
        calendarCollection.selectDates([Date()])
    }
    
    private func getDataServer() {
        // Initialize dataset.
        // (This data would usually come from a local content provider or remote server)
        // For example, we will obtain 4 data of the CalendarEventInfo type
        var list = [ScheduledEvents]()
        var event:ScheduledEvents = ScheduledEvents(id: "1", title: "Event 1", color: "#D94EE3FF")
        list.append(event)
        event = ScheduledEvents(id: "2", title: "Event 2", color: "#9F10F2FF")
        list.append(event)
        var eventInfo = CalendarEventInfo(date: "25-Oct-2019T00:00:00.000Z", events: list)
        data.append(eventInfo)
        
        list = [ScheduledEvents]()
        event = ScheduledEvents(id: "3", title: "Event 3", color: "#9F10F2FF")
        list.append(event)
        eventInfo = CalendarEventInfo(date: "15-Nov-2019T00:00:00.000Z", events: list)
        data.append(eventInfo)
        
        list = [ScheduledEvents]()
        event = ScheduledEvents(id: "4", title: "Event 4", color: "#9F10F2FF")
        list.append(event)
        eventInfo = CalendarEventInfo(date: "15-Dec-2019T00:00:00.000Z", events: list)
        data.append(eventInfo)
        
        list = [ScheduledEvents]()
        event = ScheduledEvents(id: "5", title: "Event 5", color: "#4CD4C6FF")
        list.append(event)
        event = ScheduledEvents(id: "6", title: "Event 6", color: "#EA8D8DFF")
        list.append(event)
        event = ScheduledEvents(id: "7", title: "Event 7", color: "#16E484FF")
        list.append(event)
        eventInfo = CalendarEventInfo(date: "21-Dec-2019T00:00:00.000Z", events: list)
        data.append(eventInfo)
        
        // From the data obtained from the server, we will create the dictionaries
        createDictionaries()
    }
    
    private func createDictionaries() {
        // The dictionaries that we are going to create will help us to visualize the dotsViews and the guide.
        // We will go through the list of data obtained
        for position in 0..<data.count {
            // We get the date, which will be the key to our dictionaries
            let dateServer = CustomerDateFormat.FormatterServer.date(from: data[position].date)
            // For dotsViews, we need to know the full (but short) date,
            // so we indicate the format to the FormaterDate
            FormatterDate.dateFormat = CustomerDateFormat.FORMATTER_DATE
            // Now, we create our key for the first dictionary
            let kDot = FormatterDate.string(from: dateServer!)
            // For the guide, we need to know the month and year
            FormatterDate.dateFormat = CustomerDateFormat.FORMATTER_DATE_SHORT
            // Now, we create our key for the second dictionary
            let kGuide = FormatterDate.string(from: dateServer!)
            
            // We verify that the date in that position has events
            if data[position].events.count > 0 {
                var events:[ScheduledEvents] = [ScheduledEvents]()
                var colors:[String] = [String]()
                var exist = false
                
                // If in our second dictionary the key already exists, we assign the value of the key to our list
                if let saveGuide = dictionaryEvents[kGuide] {
                    events = saveGuide
                    exist = true
                }
                
                // We will go through the events to obtain:
                // the colors (first dictionary) and the events themselves (second dictionary)
                for event in data[position].events {
                    colors.append(event.color)
                    events.append(event)
                }
                
                // If in our second dictionary the key already exists, we will update the value of the key,
                // otherwise, we will assign it
                if exist { dictionaryEvents.updateValue(events, forKey: kGuide) }
                else { dictionaryEvents[kGuide] = events }
                
                // We assign the value to the key of our first dictionary
                dictionaryDots[kDot] = colors
            }
        }
        
        // We update the guide
        updateGuide(date: createDateComponent(addMonth: 0, from: Date()))
    }
    
    private func createDateComponent(addMonth: Int, from date: Date) -> DateComponents {
        let components = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month], from: date)
        var month = components.month! + addMonth
        var year = components.year!
        
        if month < 0 {
            month = 12 + month
            year = components.year! - 1
        }
        else if month > 12 {
            month = month - 12
            year = components.year! + 1
        }
        
        var dComponents = DateComponents()
        dComponents.year = year
        dComponents.month = month
        dComponents.day = 1
        
        return dComponents
    }
    
    private func updateGuide(date: DateComponents) {
        // As we define the key of the guide in month and year, we indicate to the FormatterDate
        FormatterDate.dateFormat = CustomerDateFormat.FORMATTER_DATE_SHORT
        // We get a date from the DateComponents
        let guideDate = Calendar.current.date(from: date)
        // We assign the value to the variable, which is responsible for being key to iterate our dictionary
        keyDate = FormatterDate.string(from: guideDate!)
        // Update collections
        updateCollection(date: guideDate!)
    }
    
    private func updateCollection(date: Date) {
        calendarCollection.reloadData(withAnchor: date)
        guideCollection.reloadData()
        //We set the height of the view
        setHeightGuide()
    }
    
    private func setHeightGuide() {
        guideCollection.isHidden = true
        
        if dictionaryEvents[keyDate] == nil || dictionaryEvents[keyDate]!.count <= 4 {
            heightCalendar.constant = 320
        }
        else if dictionaryEvents[keyDate]!.count > 4 && dictionaryEvents[keyDate]!.count <= 8 {
            heightCalendar.constant = 335
        }
        else {
            heightCalendar.constant = 350
        }
        
        if isExpanded {
            guideCollection.isHidden = false
            guideCollection.reloadData()
        }
        else { heightCalendar.constant = 310 }
    }
    
    private func hiddenViews(value: Bool) {
        guide.isHidden = value
        guideCollection.isHidden = value
    }
    
    func configureCell(view: JTACDayCell?, cellState: CellState) {
        guard let cell = view as? CalendarCell else { return }
        cell.dateLabel.text = cellState.text
        
        handleViews(cell: cell, cellState: cellState)
        handleTextColor(cell: cell, cellState: cellState)
        handleSelected(cell: cell, cellState: cellState)
    }
    
    func configureCellSelected(view: JTACDayCell?, cellState: CellState) {
        guard let cell = view as? CalendarCell else { return }
        
        handleTextColor(cell: cell, cellState: cellState)
        handleSelected(cell: cell, cellState: cellState)
    }
    
    func handleViews(cell: CalendarCell, cellState: CellState) {
        cell.dotView1.layer.cornerRadius = cell.dotView1.frame.width / 2
        cell.dotView2.layer.cornerRadius = cell.dotView2.frame.width / 2
        cell.dotView3.layer.cornerRadius = cell.dotView3.frame.width / 2
        cell.selectedView.layer.cornerRadius = cell.selectedView.frame.width / 2
    }
    
    func handleTextColor(cell: CalendarCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth { cell.dateLabel.textColor = UIColor.black }
        else { cell.dateLabel.textColor = UIColor.gray }
        
        // Or you can also make them hidden.
        /*if cellState.dateBelongsTo == .thisMonth {
            cell.isHidden = false
        } else {
            cell.isHidden = true
        }*/
    }
    
    func handleSelected(cell: CalendarCell, cellState: CellState) {
        if cellState.isSelected {
            cell.dateLabel.textColor = UIColor.white
            cell.selectedView.isHidden = false
            cell.dotView1.isHidden = true
            cell.dotView2.isHidden = true
            cell.dotView3.isHidden = true
            selectedDateByUser = cellState.date
        } else {
            cell.selectedView.isHidden = true
            handleDots(cell: cell, cellState: cellState)
        }
    }
    
    func handleDots(cell: CalendarCell, cellState: CellState) {
        FormatterDate.dateFormat = CustomerDateFormat.FORMATTER_DATE
        let dateString = FormatterDate.string(from: cellState.date)
        
        if dictionaryDots[dateString] == nil {
            cell.dotView1.isHidden = true
            cell.dotView2.isHidden = true
            cell.dotView3.isHidden = true
        }
        else {
            if dictionaryDots[dateString]!.count >= 3 {
                cell.dotView1.isHidden = false
                cell.dotView1.backgroundColor = UIColor(hex: dictionaryDots[dateString]![0])
                cell.dotView2.isHidden = false
                cell.dotView2.backgroundColor = UIColor(hex: dictionaryDots[dateString]![1])
                cell.dotView3.isHidden = false
                cell.dotView3.backgroundColor = UIColor(hex: dictionaryDots[dateString]![2])
            }
            else if dictionaryDots[dateString]!.count >= 2 {
                cell.dotView1.isHidden = false
                cell.dotView1.backgroundColor = UIColor(hex: dictionaryDots[dateString]![0])
                cell.dotView2.isHidden = false
                cell.dotView2.backgroundColor = UIColor(hex: dictionaryDots[dateString]![1])
            }
            else {
                cell.dotView2.isHidden = false
                cell.dotView2.backgroundColor = UIColor(hex: dictionaryDots[dateString]![0])
            }
        }
    }
    
    func handleGuideMonth(numberMonth: Int) {
        let dComponent = createDateComponent(addMonth: numberMonth, from: initDate)
        updateGuide(date: dComponent)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dictionaryEvents[keyDate] == nil { return 0 }
        return dictionaryEvents[keyDate]!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "guideCell", for: indexPath) as! GuideCollectionViewCell
        cell.dotView.backgroundColor = UIColor(hex: dictionaryEvents[keyDate]![indexPath.row].color)
        cell.dotView.layer.cornerRadius = cell.dotView.frame.width / 2
        cell.eventName.text = dictionaryEvents[keyDate]![indexPath.row].title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}
