//
//  ViewController.swift
//  tweeter
//
//  Created by Roman Salazar on 10/17/16.
//  Copyright © 2016 Roman Salazar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var allTweets = [Tweet]() {
        didSet { // didSet is a property observer, will fire off once complete
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "HOME"
        tableViewSetup()
    }
    
    func tableViewSetup() {
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.register(UINib(nibName: "TweetCell", bundle: nil), forCellReuseIdentifier: TweetCell.identifier())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        update()
        
//        JSONParser.tweetsFrom(data: JSONParser.sampleJSONData) { (success, results) in
//            if success {
//                if let tweets = results {
//                    self.allTweets = tweets
//                }
//            }
//        }
    }
    
    func update() {
        API.share.getTweets { (tweets) in
            if tweets != nil {
                OperationQueue.main.addOperation {
                    self.allTweets = tweets!
                }
            }
        }
    }
}



extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TweetCell.identifier(), for: indexPath) as! TweetCell
        
        let tweet = self.allTweets[indexPath.row]
     
        cell.tweet = tweet
        print("after this my tweet should appear")
        print(tweet)
        
        return cell
    }
    

}
