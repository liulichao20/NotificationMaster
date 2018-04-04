//
//  ViewController.swift
//  cornerDemo
//
//  Created by lichao_liu on 2018/3/29.
//  Copyright © 2018年 com.pa.com. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let shadowView = UIView(frame: CGRect.init(x: 50, y: 50, width: 100, height: 100))
        shadowView.layer.shadowOffset = CGSize.init(width: 3, height: 2)
        shadowView.layer.shadowOpacity = 0.8
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowRadius = 4
        
        let imageView = UIView(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        imageView.backgroundColor = UIColor.orange
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        shadowView.addSubview(imageView)
        
        view.addSubview(shadowView)
        
        
        let cornerView = UIView(frame: CGRect.init(x: 50, y: 200, width: 200, height: 200))
        cornerView.backgroundColor = UIColor.blue
        let maskLayer = CAShapeLayer()
        maskLayer.frame = cornerView.bounds
        
        let maskPath = UIBezierPath(roundedRect: cornerView.bounds, byRoundingCorners: [UIRectCorner.bottomLeft,UIRectCorner.bottomRight,UIRectCorner.topLeft], cornerRadii: CGSize.init(width: 10, height: 10))
        maskLayer.path = maskPath.cgPath
        cornerView.layer.mask = maskLayer
        view.addSubview(cornerView)
        
        
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            content.title = "title"
            content.subtitle = "subtitle"
            content.body = "body"
            content.badge = 1
            
            let path = Bundle.main.path(forResource: "a", ofType: "png")!
            if let att = try? UNNotificationAttachment(identifier: "att1", url: URL.init(fileURLWithPath: path), options: nil) {
                content.attachments = [att]
            }
            let sound = UNNotificationSound.default()
            content.sound = sound
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: "request", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
}

