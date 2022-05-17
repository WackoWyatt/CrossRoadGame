//
//  GameViewController.swift
//  CrossRoadGame
//
//  Created by Sam  Sedziol on 4/14/22.
//
// CrossRoadGame
// 5/5/22 7:20pm
// Wyatt Roberson wyarober
// Sam Sedziol ssedziol
// Ethan Tang ewtang

import Foundation
import UIKit
import SpriteKit
import GameplayKit
import UserNotifications

class GameViewController: UIViewController, UNUserNotificationCenterDelegate {

    var appDelegate : AppDelegate?
    var myGameData : GameDataModel?
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    func updateScoreLabel() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.scoreLabel.text = "Score: \(self.myGameData?.getScore() ?? 0)"
            self.updateScoreLabel()
        })
    }
    
    func sendNotification() {
        let content = UNMutableNotificationContent()
        //content.title = "Nice work \(myGameData?.getUsername() ?? "")!"
        //content.subtitle = "You got a score of \(myGameData?.getScore() ?? 0)"
        content.title = "Don't get hit by the cars \(myGameData?.getUsername() ?? "")!"
        content.subtitle = "Check high scores to see if you set one."
        content.sound = UNNotificationSound.default

        // choose a random identifier
        let request = UNNotificationRequest(identifier: "id", content: content, trigger: nil)
        
        // add our notification request
        UNUserNotificationCenter.current().add(request){ (error) in
            if error != nil {
                print("error local notification")
            }
        }
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    //for displaying notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        //If you don't want to show notification when app is open, do something here else and make a return here.
        //Even you you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.

        completionHandler([.banner, .badge, .sound])
    }

    // For handling tap and user actions
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case "action1":
            print("Action First Tapped")
        case "action2":
            print("Action Second Tapped")
        default:
            break
        }
        completionHandler()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //obtain a reference to the AppDelegate
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        // from the AppDelegate, obtain a reference to the Model data:
        self.myGameData = self.appDelegate?.myGameData
        
        UNUserNotificationCenter.current().delegate = self
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            //view.showsNodeCount = true
        }
        
        self.sendNotification()
        updateScoreLabel()
    }
    
}
