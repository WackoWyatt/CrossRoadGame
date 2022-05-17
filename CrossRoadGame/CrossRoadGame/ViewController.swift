//
//  ViewController.swift
//  CrossRoadGame
//
//  Created by Sam  Sedziol on 4/14/22.
//
// CrossRoadGame
// 5/5/22 7:20pm
// Wyatt Roberson wyarober
// Sam Sedziol ssedziol
// Ethan Tang ewtang

import UIKit
import AVFoundation
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    var appDelegate : AppDelegate?
    var myGameData : GameDataModel?
    
    var audioPlayer: AVAudioPlayer?
    let userNotificationCenter = UNUserNotificationCenter.current()
        
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBAction func startGameButton(_ sender: Any) {
        //this simply is a test to allow you to "play" a game then check high score
        myGameData?.resetGame()
        myGameData?.setUsername(name: userNameTextField.text ?? "no name")
        //myGameData?.setScore(updatedScore: 11111)
        //myGameData?.updateScore()
        
        save()
    }
    
    //always sort the high scores to be safe whern accessing them
    @IBAction func highScoresButton(_ sender: Any) {
        myGameData?.sortHighScores()
        
        save()
    }
    
    //sends a notification given a time interval in seconds and message
    func sendNotification(time: Int, message: String) {
        let content = UNMutableNotificationContent()
        content.title = message
        content.badge = 1
        content.sound = UNNotificationSound.default

        //trigger for the notification
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(time), repeats: false)
        
        // choose a random identifier
        let uuid = UUID()
        let id = "CrossRoadGame" + uuid.uuidString
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
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

    func save(){
        do {
            let fm = FileManager.default
            let docsurl = try fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            //print("serializing Cross Road Game using property list encoder")
            let crossroadgame = myGameData
            let crossroadgamedata = try PropertyListEncoder().encode(crossroadgame)
            let crossroadgamefile = docsurl.appendingPathComponent("crossroadgame.txt")
            //print(docsurl)
            
            //print("writing serialized MiniRemindersDataModel to file")
            try crossroadgamedata.write(to: crossroadgamefile, options: .atomic)
            
            // but now let's try the same thing with an Array of highScores which is Codable
            // we can't just tell an Array to `write`, but we can write it as a plist
            let highscores = myGameData?.getHighScores()
            let highscoresfile = docsurl.appendingPathComponent("highscores.plist")
            let plister = PropertyListEncoder()
            plister.outputFormat = .xml // just so we can read it
            //print("attempting successfully to write an array of highScores by encoding to plist first")
            try plister.encode(highscores).write(to: highscoresfile, options: .atomic)
            //print("we didn't throw writing array of highScores")
            //let s = try String.init(contentsOf: highscoresfile)
            //print(s) // show it as XML
        } catch {
            print(error)
        }
    }
    
    //Journey Of Hope by Alexander Nakarada | https://www.serpentsoundstudios.com
    //Music promoted by https://www.free-stock-music.com
    //Attribution 4.0 International (CC BY 4.0)
    //https://creativecommons.org/licenses/by/4.0/
    
    //Green Tea by Purrple Cat | https://purrplecat.com
    //Music promoted by https://www.free-stock-music.com
    //Creative Commons Attribution-ShareAlike 3.0 Unported
    //https://creativecommons.org/licenses/by-sa/3.0/deed.en_US
    
    func startBackgroundMusic(input: String) {
        if let bundle = Bundle.main.path(forResource: input, ofType: "mp3") {
            print("yes")
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf:backgroundMusic as URL)
                guard let audioPlayer = audioPlayer else { return }
                audioPlayer.numberOfLoops = -1
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch {
                print(error)
            }
        }
    }
    
    func stopBackgroundMusic() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.stop()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //obtain a reference to the AppDelegate
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        do {
            let fm = FileManager.default
            let docsurl = try fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            print(docsurl)
            
            //print("retrieving saved plist cross road game")
            let crossroadgamefile = docsurl.appendingPathComponent("crossroadgame.txt")
            let crossroadgamedata = try Data(contentsOf: crossroadgamefile)
            let game = try PropertyListDecoder().decode(GameDataModel.self, from: crossroadgamedata)
            //print(game)
            self.appDelegate?.myGameData = game
            
            //print("retrieving saved plist array of Item")
            let highscoresfile = docsurl.appendingPathComponent("highscores.plist")
            let highscoresdata = try Data(contentsOf: highscoresfile)
            let highscores = try PropertyListDecoder().decode([highScoreModel].self, from:highscoresdata)
            self.appDelegate?.myGameData.setHighScores(scores: highscores)
            //print(highscores)
        } catch {
            print(error)
        }
        
        UNUserNotificationCenter.current().delegate = self
        
        // from the AppDelegate, obtain a reference to the Model data:
        self.myGameData = self.appDelegate?.myGameData
        
        startBackgroundMusic(input: "gameMusic")
        //sends a notification in an hour (3600 seconds) to come back and play
        self.sendNotification(time: 3600, message: "Run far and avoid the cars!")
        
        //sends a notification in a day (86400 seconds) to check the high scores
        self.sendNotification(time: 86400, message: "Don't forget to check high scores!")

    }


}

