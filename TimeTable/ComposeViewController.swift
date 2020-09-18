//
//  ComposeViewController.swift
//  TimeTable
//
//  Created by 최승명 on 2020/09/08.
//  Copyright © 2020 최승명. All rights reserved.
//

import UIKit
import Firebase
import PopOverMenu

class ComposeViewController: UIViewController, UITextFieldDelegate, UIAdaptivePresentationControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextView!
    
    let formatter:DateFormatter = DateFormatter()
    var arrValue = [String]()
    var arrDate = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.formatter.dateFormat = "yyyy-MM-dd"
        dateLabel.text = formatter.string(from: ViewController.selectedDate!)
        
        self.titleTextField.delegate = self
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
        arrValue.append(dateLabel.text!)
        arrValue.append(titleTextField.text!)
        arrValue.append(contentTextField.text)
        
        let ref = Database.database().reference()
        ref.child("diary").child(dateLabel.text!).setValue(arrValue)
        
        doneAlert()
    }
    @IBAction func addPic(_ sender: Any) {
        openMenu(sender: sender as! UIBarButtonItem)
    }
    
    
    // MARK: Func Method
    func doneAlert(){
        let alert = UIAlertController(title: "저장", message: "저장되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default){
            [weak self] (action) in
            self?.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    public func openMenu(sender:UIBarButtonItem) {
            let titles = ["사진", "그림"]
            let descriptions = ["갤러리에서 사진 추가", "손그림 추가"]
            
            let popOverViewController = PopOverViewController.instantiate()
            popOverViewController.set(titles: titles)
            popOverViewController.set(descriptions: descriptions)

            // option parameteres
            // popOverViewController.set(selectRow: 1)
            // popOverViewController.set(showsVerticalScrollIndicator: true)
            // popOverViewController.set(separatorStyle: UITableViewCellSeparatorStyle.singleLine)

            popOverViewController.popoverPresentationController?.barButtonItem = sender
            popOverViewController.preferredContentSize = CGSize(width: 250, height:100)
            popOverViewController.presentationController?.delegate = self
            popOverViewController.completionHandler = { selectRow in
                switch (selectRow) {
                case 0:
                    break
                case 1:
                    break
                default:
                    break
                }
                
            };
            present(popOverViewController, animated: true, completion: nil)
        }
        
        func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
            return UIModalPresentationStyle.none
        }

        
        func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
            return UIModalPresentationStyle.none
        }
    

}
