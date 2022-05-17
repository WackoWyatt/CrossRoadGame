//
//  HighScoreTableViewController.swift
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

class HighScoreTableViewController: UITableViewController {
    
    var appDelegate : AppDelegate?
    var myGameData : GameDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //obtain a reference to the AppDelegate
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        // from the AppDelegate, obtain a reference to the Model data:
        self.myGameData = self.appDelegate?.myGameData
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if let lData = self.myGameData{
            //print("count: \(lData.getHighScores().count)")
            return lData.getHighScores().count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "highScoreDate", for: indexPath) as! HighScoreTableViewCell

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        // Configure the cell...
        //updates the calls to be with the current high scores array
        if let lData = self.myGameData{
            cell.name?.text = "Name: \(lData.getHighScores()[indexPath.row].getUsername())"
            cell.score?.text = "Score: \(lData.getHighScores()[indexPath.row].getScore().description)"
            cell.date?.text = dateFormatter.string(from: lData.getHighScores()[indexPath.row].getDate())
            //print("Name: \(lData.getHighScores()[indexPath.row].getUsername())")
            //print("Score: \(lData.getHighScores()[indexPath.row].getScore().description)")
            //print("Date: \(lData.getHighScores()[indexPath.row].getDate().description)")
        }

        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let lMyTableView = self.view as? UITableView{
            lMyTableView.reloadData()
            
            self.tableView.rowHeight = 120
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
