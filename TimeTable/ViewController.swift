//
//  ViewController.swift
//  TimeTable
//
//  Created by 최승명 on 2020/09/07.
//  Copyright © 2020 최승명. All rights reserved.
//

import UIKit
import FSCalendar
import Firebase

class ViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {

    // MARK: Properties
    @IBOutlet weak var fsCalendar: FSCalendar!
    @IBOutlet weak var add: UIBarButtonItem!
    @IBOutlet weak var delete: UIToolbar!
    @IBOutlet weak var edit: UIToolbar!
    @IBOutlet weak var share: UIToolbar!
    @IBOutlet weak var mainText: UITextView!
    
    var arrDate = [String]()
    var cvc: ComposeViewController?
    static var selectedDate: Date?
    
    let formatter:DateFormatter = DateFormatter()
    let ref = Database.database().reference()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref.child("날짜").observeSingleEvent(of: .value) { snapshot in
            guard let arr = snapshot.value as? [String] else{
                return
            }
            DispatchQueue.main.async {
                self.arrDate = arr
            }
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fsCalendar.delegate = self
        fsCalendar.dataSource = self
        fsCalendar.locale = Locale(identifier: "ko_KR")
        
        self.formatter.dateFormat = "yyyy-MM-dd"
        
        guard let _ = ViewController.selectedDate else{
            add.isEnabled = false
            disableButton()
            return
        }
        
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    // MARK: FSCalendar
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
        ViewController.selectedDate = date
        
        ref.child("diary").child(formatter.string(from: date)).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let arr = snapshot.value as? [String] else{
                self.mainText.text = ""
                self.disableButton()
                self.add.isEnabled = true
                return
            }
            self.mainText.text = arr[2]
            self.activeButton()
            self.add.isEnabled = false
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        return true
    }
    
    func calendar(calendar: FSCalendar, didSelectDate date: NSDate) {
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        for i in self.arrDate {
//            print(i)
//        }
        
        if self.arrDate.contains(formatter.string(from: date)){
            return 1
        }else{
            return 0
        }
    }
    
    // MARK: Action Method
    @IBAction func deleteData(_ sender: Any) {
        let desertRef = ref.child("diary").child(formatter.string(from: ViewController.selectedDate!))
        
        let alert = UIAlertController(title: "삭제 확인", message: "일기를 삭제하겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "삭제", style: .destructive){
            [weak self] (action) in
            // Delete the file
            desertRef.removeValue()
            self?.mainText.text = ""
            self?.disableButton()
            self?.add.isEnabled = true
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: func Method
    func saveDate(arrDate: [String]){
        self.arrDate = arrDate
    }
    
    func activeButton(){
        delete.isHidden = false
        edit.isHidden = false
        share.isHidden = false
    }
    
    func disableButton(){
        delete.isHidden = true
        edit.isHidden = true
        share.isHidden = true
    }
        
}

extension UIApplication {

    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }

}

