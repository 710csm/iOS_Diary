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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func calendar(calendar: FSCalendar, didSelectDate date: NSDate) {
        let ac = UIAlertController(title: "Hello!", message: "This is a test.", preferredStyle: .actionSheet)
       
        let popover = ac.popoverPresentationController
        popover?.sourceView = view
        popover?.sourceRect = CGRect(x: 32, y: 32, width: 64, height: 64)

        present(ac, animated: true)
    }
    
}

