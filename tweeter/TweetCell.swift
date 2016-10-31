//
//  TweetCell.swift
//  tweeter
//
//  Created by Roman Salazar on 10/31/16.
//  Copyright © 2016 Roman Salazar. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    
    var tweet: Tweet! {
        didSet {
            // Set the text right away. 
            self.tweetText.text = tweet.text
            // Kick off the image download if the user is present.
            if let user = self.tweet.user {
                self.userName.text = user.name
                
            }
        }
    }
    
//    var tweet: Tweet! {
//        didSet {
//            // Set the text right away.
//            self.tweetLabel.text = tweet.text
//            // Kick off the image download if the user is present.
//            if let user = self.tweet.user {
//                self.usernameLabel.text = user.name
//                if let image = SimpleCache.shared.image(key: user.profileImageURL) {
//                    userImageView.image = image
//                    return
//                }
//                API.shared.GETImage(urlString: user.profileImageURL, completion: { (image) -> () in
//                    if let image = image {
//                        SimpleCache.shared.setImage(image: image, key: user.profileImageURL)
//                        self.userImageView.image = image
//                    }
//                })
//            }
//        }
//    }
//    override func awakeFromNib()
//    {
//        super.awakeFromNib()
//        self.setupTweetCell()
//    }
//    
//    func setupTweetCell()
//    {
//        self.userImageView.clipsToBounds = true
//        self.userImageView.layer.cornerRadius = 15.0
//        self.preservesSuperviewLayoutMargins = false
//        self.separatorInset = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)
//        self.layoutMargins = UIEdgeInsets.zero
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

