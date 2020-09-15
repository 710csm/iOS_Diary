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

class ViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UIGestureRecognizerDelegate {

    // MARK: Properties
    @IBOutlet weak var fsCalendar: FSCalendar!
    @IBOutlet weak var add: UIBarButtonItem!
    @IBOutlet weak var delete: UIToolbar!
    @IBOutlet weak var edit: UIToolbar!
    @IBOutlet weak var share: UIToolbar!
    @IBOutlet weak var mainText: UITextView!
    
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    
    var arrDate = [String]()
    var cvc: ComposeViewController?
    static var selectedDate: Date?
    
    let formatter:DateFormatter = DateFormatter()
    let ref = Database.database().reference()
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.fsCalendar, action: #selector(self.fsCalendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref.child("diary").observeSingleEvent(of: .value) { snapshot in
            guard let arr = snapshot.value as? [String] else{
                return
            }
            DispatchQueue.main.async {
                self.arrDate = arr
            }
        }
        self.view.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fsCalendar.delegate = self
        fsCalendar.dataSource = self
        fsCalendar.locale = Locale(identifier: "ko_KR")
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.fsCalendar.accessibilityIdentifier = "calendar"
        self.mainText.panGestureRecognizer.require(toFail: self.scopeGesture)
        
        self.formatter.dateFormat = "yyyy-MM-dd"
        
        guard let _ = ViewController.selectedDate else{
            add.isEnabled = false
            disableButton()
            return
        }
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor(named: "MyColor")
        navigationBarAppearace.barTintColor = UIColor(named: "MyColor")
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
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
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.constraintHeight.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
    
    // MARK: Action Method
    @IBAction func deleteData(_ sender: Any) {
        let diaryRef = ref.child("diary").child(formatter.string(from: ViewController.selectedDate!))
        
        let alert = UIAlertController(title: "삭제 확인", message: "일기를 삭제하겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "삭제", style: .destructive){
            [weak self] (action) in
            // Delete the file
            diaryRef.removeValue()
            
            self?.mainText.text = ""
            self?.disableButton()
            self?.add.isEnabled = true
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func share(_ sender: Any) {
        guard let content  = mainText?.text else {
            return
        }
        let vc = UIActivityViewController(activityItems: [content], applicationActivities: nil)
        
        if let pc = vc.popoverPresentationController {
            pc.barButtonItem = sender as? UIBarButtonItem
        }
        present(vc, animated: true, completion: nil)
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

