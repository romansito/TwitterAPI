//
//  ProfileViewController.swift
//  tweeter
//
//  Created by Roman Salazar on 10/31/16.
//  Copyright © 2016 Roman Salazar. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImageview: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var numberOfFollowersLabel: UILabel!
    @IBOutlet weak var followingNumberLabel: UILabel!
    
    var user : User? {
        didSet {
            if let myUser = user {
                profileImage(key: myUser.profileImageUrlString, completion: { (image) in
                    self.profileImageview.image = image
                })
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
       

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "PROFILE"

        API.share.getUserAccount { (user) in
            self.user = user
            
            OperationQueue.main.addOperation {
                
                self.userNameLabel.text = self.user?.name
                
                if let followers = self.user?.followersCount {
                    self.numberOfFollowersLabel.text = "\(followers)"
                }
                
                if let followingNumbers = user?.friendsCount {
                    self.followingNumberLabel.text = "\(followingNumbers)"
                }
                
            }
        }

    }
    
    
    
    
    func profileImage(key: String, completion: @escaping (UIImage?) -> ()) {
        if let image = SimpleCache.share.image(key: key) {
            completion(image)
            return
        }
        
        API.share.getImage(urlString: key) { (image) -> () in
            if let image = image {
                completion(image)
            }
        }
    }



}
