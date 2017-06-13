//
//  InputViewController.swift
//  taskApp
//
//  Created by 里舘 徹 on 2016/09/07.
//  Copyright © 2016年 tooru.satodate. All rights reserved.
//

import UIKit
import RealmSwift

class InputViewController: UIViewController {
    
    
    @IBOutlet weak var titleTextField: UITextField!

    @IBOutlet weak var contentsTextView: UITextView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var categoryTextField: UITextField!
    
    let realm = try! Realm()
    
    var task:Task!
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date as Date
        categoryTextField.text = task.category
   
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        try! realm.write{
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date as NSDate
            self.task.category = self.categoryTextField.text!
            self.realm.add(self.task, update: true)
        }
        setNotfication(task)
        
        super.viewWillDisappear(animated)
    }
    
    
    func dismissKeyboard(){
        
        // キードードを閉じる
        view.endEditing(true)
    }
    
    //　すでに同じタスクが登録されていたらキャンセルする
    func setNotfication (_ task: Task) {
        
        for notification in UIApplication.shared.scheduledLocalNotifications! {
            if notification.userInfo!["id"] as! Int == task.id {
                UIApplication.shared.cancelLocalNotification(notification)
                break // breakに来るとforループから抜け出させる
            }
        }
        
        let notification = UILocalNotification()
        
        notification.fireDate = task.date as Date
        notification.timeZone = TimeZone.current
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["id":task.id]
        UIApplication.shared.scheduleLocalNotification(notification)
    }
}
