//
//  AppDelegate.swift
//  cornerDemo
//
//  Created by lichao_liu on 2018/3/29.
//  Copyright © 2018年 com.pa.com. All rights reserved.
//

import UIKit
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (_, _) in })
        } else {
            let settings = UIUserNotificationSettings(types: [.badge,.alert,.sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
        
        if let options = launchOptions, let dict = options[UIApplicationLaunchOptionsKey.remoteNotification] as? [String:Any] {
            let str = queryDictKeyAndValues(dict: dict)
            print("启动获取到的远程推送数据：\(str)")
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("falured \(error.localizedDescription)")
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenStr = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenStr)
    }
    
    //ios10 之前用这个管理
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        switch application.applicationState {
        case .active:
            //ios10之前前台收到通知
            if #available(iOS 10.0, *) {
                return
            }
            
        case .inactive:
            print("inactive")
            //ios10之前点击通知打开应用触发
            handleMessage(dict: userInfo)
        case .background:
            print("background")
            //ios10之前后台收到通知
            
        }
        completionHandler(.newData)
    }
    
    func queryDictKeyAndValues(dict:[AnyHashable:Any])->String {
        var str:String = ""
        dict.forEach {  item in
            str = "\(str) \(item.key):\(item.value) "
        }
        return str
    }
}

extension AppDelegate:UNUserNotificationCenterDelegate {
    @available(iOS 10.0, *)//前台收到通知
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userinfo = notification.request.content.userInfo
        
        if let trigger = notification.request.trigger,trigger.isKind(of: UNPushNotificationTrigger.self) {
            //前台收到远程推送
            handleMessage(dict: userinfo)
        }else {
            //前台收到本地推送
            let request:UNNotificationRequest = notification.request
            let content:UNNotificationContent = request.content
            let badge = content.badge
            let body = content.body
            let title = content.title
            let subTitle = content.subtitle
            print("badge:\(String(describing: badge)) body:\(body) title:\(title) subTitle:\(subTitle)")
        }
        completionHandler([])
    }
    @available(iOS 10.0, *)//后台点击通知触发
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func handleMessage(dict:[AnyHashable:Any]) {
        print(queryDictKeyAndValues(dict: dict))
    }
}

