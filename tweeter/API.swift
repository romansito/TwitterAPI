//
//  API.swift
//  tweeter
//
//  Created by Roman Salazar on 10/18/16.
//  Copyright © 2016 Roman Salazar. All rights reserved.
//

import Foundation
import Accounts
import Social

typealias accountCompletion = (ACAccount?) -> ()
typealias userCompletion = (User?) -> ()
typealias tweetsCompletion = ([Tweet]?) -> ()
typealias imageCompletion = (UIImage?) -> ()

class API {
    
    //Singleton of time API
    static let share = API()
    var account : ACAccount?
    
    private func logIn(completion: @escaping accountCompletion) {
        
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccounts(with: accountType, options: nil) { (sucess, error) in
            
            if error != nil {
                print("Error : Request access to Twitter account")
                completion(nil)
                return
            }
            
            if sucess {
                if let account = accountStore.accounts(with: accountType).first as? ACAccount {
                    
                    completion(account)
                    return
                }
            } else {
                print("UNSUCESSFUL: No Twitter account found on device.")
                completion(nil)
                return
            }
            print("ERROR: This app requires access to a twitter account.")
            completion(nil)
            return
        }
        
    }
    
    private func getOAuthUser(completion: @escaping userCompletion) {
    
        let url = URL(string: "https://api.twitter.com/1.1/account/verify_credentials.json" )
        
        if let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, url: url, parameters: nil) {
            
            request.account = self.account
            
            request.perform(handler: {(data, response, error) in
                if error != nil {
                    print("Error accessing Twitter to verify credentials.")
                    completion(nil)
                }
                
                guard response != nil else {completion(nil); return }
                guard data != nil else { completion(nil); return }
                
                switch response!.statusCode {
                case 200...299:
                    
                    do {
                        if let userJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                            let user = User(json: userJSON)
                            completion(user)
                            return
                        }
                    } catch {
                        print("Error: Can not Serialize Data")
                    }
                    
                case 400...499:
                    print("\(response?.statusCode): Client Side Error")
                case 500...599:
                    print("\(response?.statusCode): Server Side Error")
                default: print("Unrecognize Status Code")
                }
                completion(nil)
            })
        }
        
    }
    
    private func updateTimeline(url : String, completion: @escaping tweetsCompletion) {
                
        if let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, url: URL(string: url), parameters: nil) {
            
            request.account = self.account
            
            request.perform(handler: { (data, response, error) in
                if error != nil {
                    print("Error: Fetching Home Timeline")
                    completion(nil)
                    return
                }
                
                guard response != nil else {completion(nil); return }
                guard data != nil else {completion(nil); return }
                
                switch response!.statusCode {
                case 200...299:
                    JSONParser.tweetsFrom(data: data!, completion:  { (succcess, tweets) in
                            completion(tweets)
                    })
                case 400...499:
                    print("\(response?.statusCode): Client Side Error")
                case 500...599:
                    print("\(response?.statusCode): Server Side Error")
                default :
                    print("Response came back with unrecognize status code")
                }

                completion(nil)
                
            })
            
        }
        
        
    }
    
    func getTweets(completion: @escaping tweetsCompletion) {
        if self.account != nil {
            self.updateTimeline(url: "https://api.twitter.com/1.1/statuses/home_timeline.json", completion: completion)
        } else {
            self.logIn(completion: { (account) in
                if let account = account {
                    API.share.account = account
                    self.updateTimeline(url: "https://api.twitter.com/1.1/statuses/home_timeline.json", completion: completion)
                } else { print("Account is nil") }
            })
        }
    }
    
    func getUserTweets(username: String, completion: @escaping tweetsCompletion) {
        self.updateTimeline(url: "https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=\(username)", completion: completion)
        
    }
    
    
    
    func getImage(urlString: String, completion: @escaping imageCompletion) {
        
        OperationQueue().addOperation {
        
            guard let url = URL(string: urlString) else {return}
            print("Image URL: \(url)")
            do {
                let data = try Data(contentsOf: url)
                print("Image DATA: \(data)")

                guard let image = UIImage(data: data) else {return}
                
                //return on the main thread.
                OperationQueue.main.addOperation {
                    completion(image)
                }
            } catch let error {
                print("There was an error getting the Data from the URL for UIImage")
                print(error)
                OperationQueue.main.addOperation {
                    completion(nil)
                }
            }
        }
    }
    
    func getUserAccount(completion: @escaping userCompletion) {
        if self.account != nil {
            self.getOAuthUser(completion: completion)
        }
        completion(nil)
        // add something here in case there is no user account
    }
    
}


































