//
//  ViewController.swift
//  TimeTable
//
//  Created by 최승명 on 2020/09/07.
//  Copyright © 2020 최승명. All rights reserved.
//

import UIKit
import FSCalendar

class ViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {

    // MARK: Properties
    @IBOutlet weak var fsCalendar: FSCalendar!
    @IBOutlet weak var add: UIBarButtonItem!
    @IBOutlet weak var delete: UIToolbar!
    @IBOutlet weak var edit: UIToolbar!
    @IBOutlet weak var share: UIToolbar!
    
    var cvc: ComposeViewController?
    static var selectedDate: Date? = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fsCalendar.delegate = self
        fsCalendar.dataSource = self
        
        guard let _ = ViewController.selectedDate else{
            add.isEnabled = false
            delete.isHidden = true
            edit.isHidden = true
            share.isHidden = true
            return
        }
    }
    
    // MARK: FSCalendar
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
        ViewController.selectedDate = date
        
        add.isEnabled = true
        delete.isHidden = false
        edit.isHidden = false
        share.isHidden = false
        
        return true
    }
    
    func calendar(calendar: FSCalendar, didSelectDate date: NSDate) {
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
    }
    
}

