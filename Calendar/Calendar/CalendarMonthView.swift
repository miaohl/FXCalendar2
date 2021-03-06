//
//  CalendarMonthView.swift
//  WhereRU
//
//  Created by 钱志浩 on 15/7/6.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class CalendarMonthView: UIView {

    private var _calendarManager: CalendarView?
    var calendarManager: CalendarView? {
        get {
            return _calendarManager
        }
        set {
            self._calendarManager = newValue
            weekdaysView!.calendarManager = newValue
            for view in weeksViews! {
                (view as! CalendarWeekView).calendarManager = newValue
            }
        }
    }
    
    private var weekdaysView: CalendarMonthWeekDaysView?
    private var weeksViews: NSArray?
    private var currentMonthIndex: Int = 0
    private var cacheLastWeekMode: Bool?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit() {
        var views: NSMutableArray = NSMutableArray.new()
        
        weekdaysView = CalendarMonthWeekDaysView.new()
        self.addSubview(weekdaysView!)
        
        for(var i: Int = 0; i < 6; ++i) {
            var view: UIView = CalendarWeekView.new()
            views.addObject(view)
            self.addSubview(view)
        }
        
        weeksViews = views as NSArray
        
        cacheLastWeekMode = self.calendarManager?.calendarAppearance?.isWeekMode
    }
    
    override func layoutSubviews() {
        self.configureConstraintsForSubviews()
        super.layoutSubviews()
    }
    
    func configureConstraintsForSubviews() {
        var weeksToDisplay: CGFloat = 0
        if(cacheLastWeekMode != false) {
            weeksToDisplay = 2
        }
        else {
            weeksToDisplay = 7
        }
        var y: CGFloat = 0
        var width: CGFloat = self.frame.size.width
        var height: CGFloat = self.frame.size.height / weeksToDisplay
        
        for(var i: Int = 0; i < self.subviews.count; ++i) {
            var view: UIView = self.subviews[i] as! UIView
            view.frame = CGRectMake(0, y, width, height)
            y = CGRectGetMaxY(view.frame)
            if(cacheLastWeekMode == true && i == 5) {
                height = 0
            }
        }
    }
    
    func setBeginningOfMonth(date:NSDate) {
        var currentDate: NSDate = date
        var calendar: NSCalendar = self.calendarManager!.calendarAppearance!.calendar!
        var comps: NSDateComponents = calendar.components(NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth, fromDate: currentDate)
        currentMonthIndex = comps.month
        if(comps.day > 7) {
            currentMonthIndex = (currentMonthIndex % 12) + 1
        }
        for view in weeksViews! {
            (view as! CalendarWeekView).currentMonthIndex = currentMonthIndex
            (view as! CalendarWeekView).setBeginningOfWeek(currentDate)
            var dayComponent: NSDateComponents = NSDateComponents.new()
            dayComponent.day = 7
            currentDate = calendar.dateByAddingComponents(dayComponent, toDate: currentDate, options: NSCalendarOptions(0))!
            if(self.calendarManager!.calendarAppearance!.isWeekMode == true) {
                break;
            }
        }
    }
    
    func reloadData() {
        
//        for view in weeksViews! {
//            view.removeFromSuperview()
//        }
//        
//        
//        var views: NSMutableArray = NSMutableArray.new()
//        
//        weekdaysView = CalendarMonthWeekDaysView.new()
//        weekdaysView?.calendarManager = self.calendarManager
//        self.addSubview(weekdaysView!)
//        
//        for(var i: Int = 0; i < 6; ++i) {
//            var view: UIView = CalendarWeekView.new()
//            views.addObject(view)
//            self.addSubview(view)
//        }
        
        //weeksViews = views as NSArray
        for view in weeksViews! {
            (view as! CalendarWeekView).reloadData()
            if self.calendarManager!.calendarAppearance!.isWeekMode! {
                break
            }
        }
    }
    
    func reloadAppearance() {
        if cacheLastWeekMode != self.calendarManager!.calendarAppearance!.isWeekMode! {
            cacheLastWeekMode = self.calendarManager!.calendarAppearance!.isWeekMode!
            self.configureConstraintsForSubviews()
        }
        
        weekdaysView!.reloadAppearance()
        
        for view in weeksViews! {
            (view as! CalendarWeekView).reloadAppearance()
        }
    }

}
