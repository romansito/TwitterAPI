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
                if let image = SimpleCache.share.image(key: user.profileImageUrlString) {
                    userImageView.image = image
                    return
                }
                API.share.getImage(urlString: user.profileImageUrlString, completion: { (image) -> () in
                    if let image = image {
                        SimpleCache.share.setImage(image: image, key: user.profileImageUrlString)
                        self.userImageView.image = image
                    }
                })
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupTweetCell()
    }
    
    func setupTweetCell() {
        self.userImageView.clipsToBounds = true
        self.userImageView.layer.cornerRadius = self.userImageView.frame.width / 2
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)
        self.layoutMargins = UIEdgeInsets.zero
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

