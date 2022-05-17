//
//  GameScene.swift
//  CrossRoadGame
//
//  Created by Wyatt Roberson on 4/16/22.
//
// CrossRoadGame
// 5/5/22 7:20pm
// Wyatt Roberson wyarober
// Sam Sedziol ssedziol
// Ethan Tang ewtang

import SpriteKit
import AVFoundation
import UserNotifications

class GameScene: SKScene, SKPhysicsContactDelegate, UNUserNotificationCenterDelegate {
    
    var appDelegate : AppDelegate?
    var myGameData : GameDataModel?
    
    var audioPlayer: AVAudioPlayer?
    let userNotificationCenter = UNUserNotificationCenter.current()
    let screenSize: CGRect = UIScreen.main.bounds
    
    //Global variable player sprite
    var player = SKSpriteNode()
    var levelNum: Int = 1
    var numRoads: Int = 1
    var carSpeed: CGFloat = 1
    var levelBeatScore = 100
    var levelsBeat = 0
    
    //Road data
    var roadPiece = SKSpriteNode(imageNamed: "road")
    
    var car = SKSpriteNode()
    
    var carArray = [SKSpriteNode]()
    
    override func didMove(to view: SKView) {
        
        //Reference to GameData model
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.myGameData = self.appDelegate?.myGameData
        
        self.backgroundColor = UIColor.green
        
        createLevel(roads: numRoads, speed: carSpeed)
        spawnPlayer()
    }
    
    //Spawns player at beginning of level (bottom of screen)
    func spawnPlayer(){
        player = SKSpriteNode(imageNamed: "boy standing")
        player.position = CGPoint(x: 160, y: 32)
        player.size = CGSize(width: 45, height: 64)
       // player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 45, height: 64), center: CGPoint(x: 80, y:10))
        self.addChild(player)
    }
    
    func createLevel(roads: Int, speed: CGFloat){
        roadPiece.size = CGSize(width: 50, height: 60)
        roadPiece.zPosition = -1
        roadPiece.anchorPoint = CGPoint(x: 0,y: 1)
        var startingPoint = screenSize.size.height / CGFloat(roads+1)
        for road in 1...roads{
            createRoad(yPos: startingPoint*CGFloat(road))
            createCar(yPos: startingPoint*CGFloat(road))
        }
    }
    
    func createRoad(yPos: CGFloat){
        let roadPieces = Int(screenSize.size.width/roadPiece.size.width)
        var xPos: CGFloat = 0
        for piece in 1...roadPieces{
            roadPiece.position = CGPoint(x: xPos, y: yPos)
            xPos += roadPiece.size.width
            let roadCopy = roadPiece.copy() as! SKSpriteNode
            self.addChild(roadCopy)
        }
    }
    
    func createCar(yPos: CGFloat){
        let randomInt = Int.random(in: 0..<Int(screenSize.width))
        car = SKSpriteNode(imageNamed: "car")
        car.position = CGPoint(x: randomInt, y: (Int(yPos) - 30))
        car.size = CGSize(width: 100, height: 50)
       // car.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 50), center: CGPoint(x:(randomInt+50), y: Int(yPos) - 15))
        //car.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(car)
        carArray.append(car)
    }
    
    
    func checkLevelBeat(){
        if player.position.y+25 > UIScreen.main.bounds.size.height - player.size.height {
            //plays a level win sound effect and adds 100 points
            playSoundEffect(soundEffect: "levelWin")
            
            //increases score each level beat
            levelsBeat = levelsBeat+1
            levelBeatScore = 100*levelsBeat
            myGameData?.increaseScore(updatedScore: levelBeatScore)
            
            
            removeAllChildren()
            levelNum += 1
            if(levelNum % 3 == 0 && numRoads < 5){
                numRoads += 1
            }
            
            //increase speed of car as levels increase
            carSpeed = carSpeed * 1.1
            
            //reset the array before a new level
            carArray = []
            createLevel(roads: numRoads, speed: carSpeed)
            
            spawnPlayer()
        }
    }
    
    //plays game over sound, updates the score, and sets the status of the game to false to end it
    func gameOver(){
        playSoundEffect(soundEffect: "gameOver")
        myGameData?.updateScore()
        myGameData?.setStatus(newStatus: false)
        self.sendNotification()
    }
    
    override func update(_ currentTime: TimeInterval){
        if(myGameData?.getScore() == 0){
            player.position = CGPoint(x: 160, y: 32)
        }
        
        if(myGameData?.getStatus() ?? true){
            if(collision()){
                gameOver()
            }
            
            for cars in carArray{
                cars.position.x = cars.position.x + carSpeed
                //car screen wrapping
                if(cars.position.x > screenSize.width){
                    cars.position.x = -50
                }
            }
        }
    }
    
    //returns true if the boy has collided with a car otherwise false
    func collision() -> Bool{
        if(myGameData?.getStatus() ?? true){
        
            //run through each car
            for cars in carArray{
                
                //print(cars.position)
                //print(player.position)
                //find the absolute value of the disatnce between x and y coordinates of the player and car
                let xDiff = abs(player.position.x - cars.position.x)
                let yDiff = abs(player.position.y - cars.position.y)
                
                //the extra + is for better looking collision
                //check if the collision occurs (half the width and height of the car and player together)
                if(xDiff+10 < (cars.size.width+player.size.width)/2 && yDiff+5 < (car.size.height+player.size.height)/2){
                    return true
                }
            }
        }
        
        return false
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            //runs only if the game status is true
            if((myGameData?.getStatus()) ?? true){
                player.texture = SKTexture(imageNamed: "boy running")
                player.position.y += 25
                
                //increases the score each jump and plays a sound effect
                myGameData?.increaseScore(updatedScore: 10)
                playSoundEffect(soundEffect: "jump")
                
                checkLevelBeat()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            player.texture = SKTexture(imageNamed: "boy standing")
        }
    }
    
    func playSoundEffect(soundEffect: String) {
        if let bundle = Bundle.main.path(forResource: soundEffect, ofType: "wav") {
            let soundEffectUrl = NSURL(fileURLWithPath: bundle)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf:soundEffectUrl as URL)
                guard let audioPlayer = audioPlayer else { return }
                audioPlayer.play()
            } catch {
                print(error)
            }
        }
    }
    
    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Nice work \(myGameData?.getUsername() ?? "")!"
        content.subtitle = "You got a score of \(myGameData?.getScore() ?? 0)"
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
}
