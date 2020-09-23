//
//  ComposeViewController.swift
//  TimeTable
//
//  Created by 최승명 on 2020/09/08.
//  Copyright © 2020 최승명. All rights reserved.
//

import UIKit
import Firebase
import Floaty

class ComposeViewController: UIViewController, UITextFieldDelegate, UIAdaptivePresentationControllerDelegate {
    

    
    // MARK: Properties
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextView!
    @IBOutlet weak var locationTextField: UILabel!
    
    let floaty = Floaty()
    let formatter:DateFormatter = DateFormatter()
    
    static var location: String?
    var arrValue = [String]()
    
    var token:NSObjectProtocol?
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.formatter.dateFormat = "yyyy-MM-dd"
        dateLabel.text = formatter.string(from: ViewController.selectedDate!)
        self.titleTextField.delegate = self
        
        token = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "getLocation"), object: nil, queue: OperationQueue.main) {
            [weak self] (noti) in
            self?.locationTextField.text = ComposeViewController.location
        }
        
        floaty.addItem("위치", icon: UIImage(named: "location")!)
        floaty.addItem("그림", icon: UIImage(named: "drawing")!)
        floaty.addItem("사진", icon: UIImage(named: "picture")!)
        self.view.addSubview(floaty)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.titleTextField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.titleTextField.resignFirstResponder()
    }
    
    // MARK: Action Button
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        if titleTextField.text == "", contentTextField.text == "" {
            cancelAlert()
        }else{
            arrValue.append(dateLabel.text!)
            arrValue.append(titleTextField.text!)
            arrValue.append(contentTextField.text)
            arrValue.append(locationTextField.text!)
            
            let ref = Database.database().reference()
            ref.child("diary").child(dateLabel.text!).setValue(arrValue)
            
            doneAlert()
        }
    }

    // MARK: Func Method
    @objc func setLocation(){
        locationTextField.text = ""
    }
    
    func doneAlert(){
        let alert = UIAlertController(title: "저장", message: "저장되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default){
            [weak self] (action) in
            self?.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func cancelAlert(){
        let alert = UIAlertController(title: "경고", message: "입력된 내용이 없습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
//    public func openMenu(sender:UIBarButtonItem) {
//            let titles = ["사진", "그림", "위치"]
//            let descriptions = ["갤러리에서 사진 추가", "손그림 추가", "위치 정보 추가"]
//
//            let popOverViewController = PopOverViewController.instantiate()
//            popOverViewController.set(titles: titles)
//            popOverViewController.set(descriptions: descriptions)
//
//            // option parameteres
//            // popOverViewController.set(selectRow: 1)
//            // popOverViewController.set(showsVerticalScrollIndicator: true)
//            // popOverViewController.set(separatorStyle: UITableViewCellSeparatorStyle.singleLine)
//
//            popOverViewController.popoverPresentationController?.barButtonItem = sender
//            popOverViewController.preferredContentSize = CGSize(width: 250, height:150)
//            popOverViewController.presentationController?.delegate = self
//
//            popOverViewController.completionHandler = { selectRow in
//                switch (selectRow) {
//                case 0:
//                    break
//                case 1:
//                    break
//                case 2:
//                    guard let myVC = self.storyboard?.instantiateViewController(withIdentifier: "AddMapStoryboard") else { return }
//                    let navController = UINavigationController(rootViewController: myVC)
//                    self.navigationController?.present(navController, animated: true, completion: nil)
//                    break;
//                default:
//                    break
//                }
//
//            };
//            present(popOverViewController, animated: true, completion: nil)
//        }
        
        func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
            return UIModalPresentationStyle.none
        }

        
        func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
            return UIModalPresentationStyle.none
        }

}
