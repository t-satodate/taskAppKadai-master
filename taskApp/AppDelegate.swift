//
//  AppDelegate.swift
//  taskApp
//
//  Created by 里舘 徹 on 2016/09/07.
//  Copyright © 2016年 tooru.satodate. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // ユーザーの通知の許可を求める
        let settings = UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        
        //　通知からの起動かどうかを確認する
        if let notifcation = launchOptions? [UIApplicationLaunchOptionsKey.localNotification] as? UILocalNotification {
            // 通知領域から削除する
            application.cancelLocalNotification(notifcation)
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didReceive notifcation: UILocalNotification) {
        
        // アプリがフォアグランドにいる時に通知が届いた時
        if application.applicationState == UIApplicationState.active {
            
            //　アラートを表示する
            let alertController = UIAlertController(title: "時間になりました", message: notifcation.alertBody, preferredStyle: .alert)
            let defautAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
            alertController.addAction(defautAction)
            
            window?.rootViewController!.present(alertController, animated: true, completion: nil)
            
        }else {
            // バックグランドのいる時に通知が届いた時はログに出力するだけ
            print("\(String(describing: notifcation.alertBody))")
        }
        
          //　通知両危機から削除する
        application.cancelLocalNotification(notifcation)
            
    }



    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

