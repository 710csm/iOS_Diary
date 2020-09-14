//
//  PreviewViewController.swift
//  TimeTable
//
//  Created by 최승명 on 2020/09/08.
//  Copyright © 2020 최승명. All rights reserved.
//

import UIKit
import Firebase

class PreviewViewController: UIViewController {

    // MARK: Properties
    let formatter:DateFormatter = DateFormatter()
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var contentText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.formatter.dateFormat = "yyyy-MM-dd"
        let ref = Database.database().reference()
        
        ref.child("diary").child(formatter.string(from: ViewController.selectedDate!)).observeSingleEvent(of: .value) { snapshot in
            guard let arr = snapshot.value as? [String] else{
                return
            }
            self.date.text = arr[0]
            self.titleText.text = arr[1]
            self.contentText.text = arr[2]
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Action Method
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        var arrValue = [String]()
        let ref = Database.database().reference()
        let diaryRef = ref.child("diary").child(formatter.string(from: ViewController.selectedDate!))
        
        diaryRef.removeValue()
            
        arrValue.append(date.text!)
        arrValue.append(titleText.text!)
        arrValue.append(contentText.text)
        
        ref.child("diary").child(date.text!).setValue(arrValue)
        
        doneAlert()
    }
    
    // MARK: func Method
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
