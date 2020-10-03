//
//  ComposeViewController.swift
//  TimeTable
//
//  Created by 최승명 on 2020/09/08.
//  Copyright © 2020 최승명. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import Floaty

class ComposeViewController: UIViewController, UITextFieldDelegate, UIAdaptivePresentationControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextView!
    @IBOutlet weak var locationTextField: UILabel!
    
    let floaty = Floaty()
    let formatter:DateFormatter = DateFormatter()
    let imagePicker = UIImagePickerController()
    
    let someImageView: UIImageView = {
        let theImageView = UIImageView()
        theImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
        theImageView.translatesAutoresizingMaskIntoConstraints = false
        return theImageView
    }()

    var arrValue = [String]()
    var flag: String = "0"
    
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
        self.titleTextField.delegate = self
        self.imagePicker.delegate = self
        
        dateLabel.text = formatter.string(from: ViewController.selectedDate!)
        
        token = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "getLocation"), object: nil, queue: OperationQueue.main) {
            [weak self] (noti) in
            self?.locationTextField.text = AddMapViewController.location
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
    
    override func viewDidAppear(_ animated: Bool){
        self.titleTextField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.titleTextField.resignFirstResponder()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
            
            if let image = someImageView.image {
                upLoadImage(img: image)
                flag = "1"
            }
            arrValue.append(flag)
            
            let ref = Database.database().reference()
            ref.child("diary").child(dateLabel.text!).setValue(arrValue)
            
            doneAlert()
        }
    }

    // MARK: Func Method
    func doneAlert(){
        let alert = UIAlertController(title: "저장", message: "저장되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default){
            [weak self] (action) in
            
            NotificationCenter.default.post(
                        name: NSNotification.Name(rawValue: "saveData"),
                object: nil)
            
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
        
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
        
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func someImageViewConstraints() {
        someImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        someImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        someImageView.topAnchor.constraint(equalTo: locationTextField.bottomAnchor, constant: 10).isActive = true
        someImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        someImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        someImageView.bottomAnchor.constraint(equalTo: contentTextField.topAnchor, constant: -10).isActive = true
        
        contentTextField.topAnchor.constraint(equalTo: someImageView.bottomAnchor, constant: -10).isActive = true
    }
    
    func upLoadImage(img: UIImage){
        var data = Data()
        data = img.jpegData(compressionQuality: 0.8)!
        
        let storage = Storage.storage()
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        
        storage.reference().child(dateLabel.text!).putData(data, metadata: metaData){
            (metaData, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                print("성공")
            }
        }
    }
}

extension ComposeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] {
            someImageView.image = image as? UIImage
            someImageViewConstraints() //This function is outside the viewDidLoad function that controls the constraints
        }
        dismiss(animated: true, completion: nil)
    }
}
