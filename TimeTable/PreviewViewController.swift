//
//  PreviewViewController.swift
//  TimeTable
//
//  Created by 최승명 on 2020/09/08.
//  Copyright © 2020 최승명. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import Floaty

class PreviewViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var contentText: UITextView!
    @IBOutlet weak var locationText: UILabel!
    
    let formatter:DateFormatter = DateFormatter()
    let floaty = Floaty()
    let imagePicker = UIImagePickerController()
    let someImageView: UIImageView = {
        let theImageView = UIImageView()
        theImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
        theImageView.translatesAutoresizingMaskIntoConstraints = false
        return theImageView
    }()
    
    var flag: String = "0"
    var token:NSObjectProtocol?
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.formatter.dateFormat = "yyyy-MM-dd"
        self.imagePicker.delegate = self
        
        let ref = Database.database().reference()
        ref.child("diary").child(formatter.string(from: ViewController.selectedDate!)).observeSingleEvent(of: .value) { snapshot in
            guard let arr = snapshot.value as? [String] else{
                return
            }
            self.date.text = arr[0]
            self.titleText.text = arr[1]
            self.contentText.text = arr[2]
            self.locationText.text = arr[3]
            self.flag = arr[4]
            self.downLoadImage()
        }
        
        
        token = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "getLocation"), object: nil, queue: OperationQueue.main) {
            [weak self] (noti) in
            self?.locationText.text = AddMapViewController.location
        }
        
        floaty.buttonColor = UIColor(named: "StatusbarColor")!
        floaty.plusColor = UIColor.white
        floaty.addItem("위치", icon: UIImage(named: "location")!, handler: { item in
            guard let myVC = self.storyboard?.instantiateViewController(withIdentifier: "AddMapStoryboard") else {
                return
            }
            let navController = UINavigationController(rootViewController: myVC)
            self.navigationController?.present(navController, animated: true, completion: nil)
        })
        floaty.addItem("그림", icon: UIImage(named: "drawing")!)
        floaty.addItem("사진", icon: UIImage(named: "picture")!, handler: { item in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        self.view.addSubview(floaty)
        self.view.addSubview(someImageView)
    }
    
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
        arrValue.append(locationText.text!)
        
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
    
    func someImageViewConstraints() {
        someImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        someImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        someImageView.topAnchor.constraint(equalTo: locationText.bottomAnchor, constant: 10).isActive = true
        someImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        someImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        someImageView.bottomAnchor.constraint(equalTo: contentText.topAnchor, constant: -10).isActive = true
    }
    
    func downLoadImage(){
        if flag == "1" {
            let storage = Storage.storage()
            let urlStr = "gs://timetable-d35ce.appspot.com/" + formatter.string(from: ViewController.selectedDate!)
            storage.reference(forURL: urlStr).downloadURL { (url, error) in
                guard let data = NSData(contentsOf: url!) else {
                    return
                }
                print("test")
                let image = UIImage(data: data as Data)
                self.someImageView.image = image
                self.someImageViewConstraints()
            }
        }
    }
    
}

extension PreviewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] {
            someImageView.image = image as? UIImage
            someImageViewConstraints()
        }
        dismiss(animated: true, completion: nil)
    }
}
