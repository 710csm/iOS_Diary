//
//  ComposeViewController.swift
//  TimeTable
//
//  Created by 최승명 on 2020/09/08.
//  Copyright © 2020 최승명. All rights reserved.
//

import UIKit
import Firebase

class ComposeViewController: UIViewController, UITextFieldDelegate {

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
        
        ref.child("날짜").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let arr = snapshot.value as? [String] else{
                return
            }
            self.arrDate = arr
            self.arrDate.append(self.dateLabel.text!)
            ref.child("날짜").setValue(self.arrDate)
        }) { (error) in
            print(error.localizedDescription)
        }
        
        doneAlert()
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
    

}
