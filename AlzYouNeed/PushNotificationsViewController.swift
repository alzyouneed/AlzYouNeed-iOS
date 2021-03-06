//
//  PushNotificationsViewController.swift
//  AlzYouNeed
//
//  Created by Connor Wybranowski on 8/4/16.
//  Copyright © 2016 Alz You Need. All rights reserved.
//

import UIKit
import UserNotifications

// TODO: Reimplement elsewhere in app (after onboarding)

class PushNotificationsViewController: UIViewController {
    
    @IBOutlet var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5, animations: {
            self.progressView.setProgress(0.5, animated: true)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        self.navigationItem.hidesBackButton = true
    }
    
    @IBAction func enablePush(_ sender: UIButton) {
        registerLocalNotifications()
    }
    
    @IBAction func disablePush(_ sender: UIButton) {
        // Show alert with tip on how to enable later
        let alertController = UIAlertController(title: "Tip", message: "You can enable notifications in Settings if you change your mind", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Got it", style: .default) { (action) in
            // Transition to next step in onboarding
            self.performSegue(withIdentifier: "familyStage", sender: self)
        }
        let cancelAction = UIAlertAction(title: "I change my mind...", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Push Notifications
    func registerLocalNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if error != nil {
                print("Error requesting push notification auth:", error!)
            } else {
                if granted {
                    print("Push notification auth granted")
                } else {
                    print("Push notification auth denied")
                }
                
                UserDefaultsManager.setNotificationStatus(status: granted)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "familyStage", sender: self)
                }
            }
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
}
