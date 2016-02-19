//
//  ViewController.swift
//  ChessPlayer
//
//  Created by Ben Swift on 2/18/16.
//  Copyright © 2016 Ben Swift. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {
    
    var ref: Firebase!
    
    struct List {
        var name = String()
        var rank = String()
        var gamesPlayed = Int()
        var wins = Int()
        var loses = Int()
        var peoplePlayed = [String]()
        
        init(name: String, rank: String, gamesPlayed: Int) {
            self.name = name
            self.rank = rank
            self.gamesPlayed = gamesPlayed
            self.wins = 0
            self.loses = 0
        }
        
    }
    
    var listArray = [List]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.whiteColor()
        navigationItem.title = "Cheverus Chess"
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barTintColor = UIColor(red: 125/255.0, green: 70/255.0, blue: 148/255.0, alpha: 1.0)
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        if let font = UIFont(name: "HelveticaNeue-Thin", size: 25) {
            navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: font]
        }
        navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "addButton:"), animated: true)
        
        
        ref = Firebase(url: "Firebase_URL here")
        
//        listArray.append(List(name: "Vipul Periwal", rank: "10", gamesPlayed: 50))
//        listArray.append(List(name: "Scott Becker", rank: "8", gamesPlayed: 20))
//        listArray.append(List(name: "Dean Carrier", rank: "7", gamesPlayed: 15))
//        listArray.append(List(name: "Pup Watthanawong", rank: "4", gamesPlayed: 6))
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        getDataFromFirebase()
        
    }
    
    func getDataFromFirebase() {
        ref.observeEventType(.Value) { (snapshot: FDataSnapshot!) in
            
            var dataRetrieved = [List]()
            
            for data in snapshot.children {
                
                var rankKey = String()
                
                if let dataKey = data.key {
                    rankKey = dataKey!
                }
                
                dataRetrieved.append(List(name: data.value, rank: rankKey, gamesPlayed: 0))
                
            }
            
            self.listArray = dataRetrieved
            
            self.listArray = self.listArray.reverse()
            
            self.tableView.reloadData()
            
        }

    }
    
    func addButton(sender: AnyObject?) {
        getDataFromFirebase()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "cell")
        cell.accessoryType = .DisclosureIndicator
        
        cell.textLabel?.font = cell.textLabel?.font.fontWithSize(20)
        
        cell.textLabel?.text = listArray[indexPath.row].name
        cell.detailTextLabel?.text = "Rank: \(listArray[indexPath.row].rank)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!)! as UITableViewCell

        
        let titleData = currentCell.textLabel?.text
        
        let detailController = ProfileViewController()
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        //titleLabelString = currentCell.textLabel?.text
        detailController.titleLabelString = titleData
        
        navigationController?.pushViewController(detailController, animated: true)
        
    }
    
    
}


class ProfileViewController: UIViewController {
    
    var titleLabelString: String!
    
    let mLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Cheverus Chess!"
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 25)
        label.textAlignment = .Center
        label.frame.size = CGSizeMake(100, 200)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mLabel.text = titleLabelString
        
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(mLabel)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[v0]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": mLabel]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": mLabel]))
        
        let buttonOne = genButton("PROFILE")
        let buttonTwo = genButton("MORE")
        
        view.addSubview(buttonOne)
        view.addSubview(buttonTwo)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[btn1(btn2)]-16-[btn2]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["btn1": buttonOne, "btn2": buttonTwo]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[btn1]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["btn1": buttonOne]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[btn2]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["btn2": buttonTwo]))
        
        
    }
    
    
    func genButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, forState: .Normal)
        button.layer.cornerRadius = 5
        button.frame.size = CGSizeMake(100, 50)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 125/255.0, green: 70/255.0, blue: 148/255.0, alpha: 1.0).CGColor
        button.backgroundColor = UIColor.clearColor()
        button.setTitleColor(UIColor(red: 125/255.0, green: 70/255.0, blue: 148/255.0, alpha: 1.0), forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    
}





