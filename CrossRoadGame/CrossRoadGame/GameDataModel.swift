//
//  GameDataModel.swift
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
import CoreData

class GameDataModel: Codable{
    
    //the default values
    var currDate = Date()
    var username = ""
    var highScores: [highScoreModel] = []
    var newScore = 0
    var activeGame = true
    
    //sets default high scores for a new game
    init(){
        let testScore1 = highScoreModel(name: "AAA", score: 0, date: currDate)
        let testScore2 = highScoreModel(name: "WYATT", score: 100, date: currDate)
        let testScore3 = highScoreModel(name: "ETHAN", score: 200, date: currDate)
        let testScore4 = highScoreModel(name: "SAM", score: 500, date: currDate)
        let testScore5 = highScoreModel(name: "AUBURN", score: 1000, date: currDate)
        highScores = [testScore1, testScore2, testScore3, testScore4, testScore5]
        sortHighScores()
    }
    
    //sets the username
    //should be used when you enter the game to update to whatever the user wants
    func setUsername(name: String){
        self.username = name
    }
    
    //returns the current username
    func getUsername() -> String{
        return username
    }
    
    //returns whether the game is still running
    func getStatus() -> Bool{
        return activeGame
    }
    
    //sets the status of the game
    func setStatus(newStatus: Bool){
        self.activeGame = newStatus
    }
    
    //sets the score by updating it to a new one
    func setScore(updatedScore: Int){
        self.newScore = updatedScore
    }
    
    //gets the current score 
    func getScore() -> Int{
        return newScore
    }
    
    //increases the score by a set amount
    func increaseScore(updatedScore: Int){
        self.newScore += updatedScore
    }
    
    //gets the high scores array
    func getHighScores() -> [highScoreModel]{
        return highScores
    }
    
    //sets the high score to what you want
    func setHighScores(scores: [highScoreModel]){
        self.highScores = scores
    }
    
    //sorts the high scores in descending order
    func sortHighScores(){
        self.highScores = self.highScores.sorted(by: { $0.myScore > $1.myScore })
    }
    
    //updates the score
    func updateScore(){
        //checks that the newScore is greater than an existing one
        if self.highScores.firstIndex(where: {newScore >= $0.myScore}) != nil {
            //if so then add a new score to the list, sort it, then drop the last one
            self.highScores.insert(highScoreModel(name: username, score: newScore, date: Date()), at: 0)
            sortHighScores()
            //always only 5 scoress
            self.highScores.remove(at: 5)
        }
        //sort again to be sure
        sortHighScores()
    }
    
    //resets the game to default values for a new playthrough
    func resetGame(){
        self.username = ""
        self.newScore = 0
        self.activeGame = true
    }
}

//each highscore is a class of its own to bundle the data
class highScoreModel: Codable{
    
    //variables for name date and score
    var myScore: Int
    var myDate: Date
    var username: String
    
    //always initialize it with a name score and date when you make a new one
    init(name: String,
         score: Int,
         date: Date){
        self.username = name
        self.myScore = score
        self.myDate = date
    }
    
    //gets the score of this high score
    func getScore() -> Int{
        return myScore
    }
    
    //gets the date of this high score
    func getDate() -> Date{
        return myDate
    }
    
    //gets the username of this high score
    func getUsername() -> String{
        return username
    }
}
