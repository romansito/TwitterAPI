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
    
    var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        API.share.getUserAccount { (user) in
            self.user = user
            
            OperationQueue.main.addOperation {
                self.userNameLabel.text = self.user?.name
                
                self.numberOfFollowersLabel.text = "# of Followers: \(self.user?.followersCount)"
                self.followingNumberLabel.text = "# of Friends: " + String(describing: self.user?.friendsCount)
                
            }
            
        }
        
        configureBlurImage()
    }

    
    func profileImage(key: String, completion: @escaping (UIImage?) -> ())
    {
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
    
    func configureBlurImage() {
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
//        view.addSubview(blurEffectView)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth] // for supporting device rotation
        view.addSubview(blurEffectView)
        
    }
    


}
