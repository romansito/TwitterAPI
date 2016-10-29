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
                
            })
        }
        
    }
    
    private func updateTimeline(completion: @escaping tweetsCompletion) {
        
        let url = URL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
        
        if let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, url: url, parameters: nil) {
            
            request.account = self.account
            
            request.perform(handler: { (data, response, error) in
                if error != nil {
                    print("Error: Fetching Home Timeline")
                    completion(nil)
                }
                
                guard response != nil else {completion(nil); return }
                guard data != nil else {completion(nil); return }
                
                switch response!.statusCode {
                case 200...299:
                    JSONParser.tweetsFrom(data: data!, completion:  { (succcess, tweets)
                            completion(nil)
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
            self.updateTimeline(completion: completion)
        }
        
        self.logIn { (account) in
            if account != nil {
                API.share.account = account!
                self.updateTimeline(completion: completion)
            }
            completion(nil)
        }
    }
    
}
