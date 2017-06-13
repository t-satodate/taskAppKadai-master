//
//  ViewController.swift
//  taskApp
//
//  Created by 里舘 徹 on 2016/09/07.
//  Copyright © 2016年 tooru.satodate. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController,UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var searchBar: UISearchBar!
    
    // Realmインスタンスを取得する
    let realm = try! Realm()
    
    // DBないのタスクが格納されるリスト
    //　日付近い順＼順でソート：降順
    //　以降内容をアップデートするとリスト内は自動的に更新される
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: false)
  
    
    // MARK: - Life Cycle
    
    // 入力画面から戻ってきた時に　TableViewを更新させる
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupSearchBar()
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - サーチバー設置
    func setupSearchBar(){
        
        if let navigationBarFrame = navigationController?.navigationBar.bounds {
            let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
            searchBar.delegate = self
            searchBar.placeholder = "Search"
            searchBar.showsCancelButton = true
            searchBar.autocapitalizationType = UITextAutocapitalizationType.none
            searchBar.keyboardType = UIKeyboardType.default
            navigationItem.titleView = searchBar
            navigationItem.titleView?.frame = searchBar.frame
            self.searchBar = searchBar
            searchBar.becomeFirstResponder()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        
        searchBar.resignFirstResponder()
    }

    // 検索ボタン押下時の呼び出し
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let search = searchBar.text
        print(taskArray)
        
        taskArray = try! Realm().objects(Task.self).filter("category BEGINSWITH[c] %@", search!)
      
        searchBar.becomeFirstResponder()
            
        searchBar.endEditing(true)
        
        tableView.reloadData()
    }
    
    
    
    // MARK: - UITableViewDataSourceプロトコルのメソッド
    // データーの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return taskArray.count
    }
    
    //　各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
     

        // 再利用可能な　cell を得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // CEllに値を設定する
        let task = taskArray[indexPath.row]
        
        cell.textLabel?.text = task.title
  
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: task.date as Date)
        cell.detailTextLabel?.text = dateString
               return cell
        
     
    }

    // MARK: UITableViewDelegate
    //　各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        performSegue(withIdentifier: "cellSegue",sender: nil) // ←追加する
    }

    
    //　セルが削除が可能なことを伝えるメソッド
    func tableView(_ tablewView: UITableView, editingStyleorRowAtIndexPath: IndexPath) -> UITableViewCellEditingStyle{
        
        return UITableViewCellEditingStyle.delete
    }
    
    // Deleteボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: IndexPath ){
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            // データーベースから削除する
            let task = taskArray[indexPath.row]
            
            for notification in UIApplication.shared.scheduledLocalNotifications!{
            
            if notification.userInfo!["id"] as! Int == task.id {
                UIApplication.shared.cancelLocalNotification(notification)
                break
              }
   
            }
        
        // データーベースから削除
            try! realm.write{
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
        }
        
    }
    
    // segueで画面遷移する時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let inputViewController:InputViewController = segue.destination as! InputViewController
        
        if segue.identifier == "cellSegue" {
            let indxPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indxPath!.row]
            
        } else{
            let task = Task()
            task.date = Date() as NSDate
            
            if taskArray.count != 0 {
               task.id = taskArray.max(ofProperty: "id")! + 1
            }
            
            inputViewController.task = task
        }
    }

}

