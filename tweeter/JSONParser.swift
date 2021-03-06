//
//  JSONParser.swift
//  tweeter
//
//  Created by Roman Salazar on 10/18/16.
//  Copyright © 2016 Roman Salazar. All rights reserved.
//

import Foundation

typealias JSONParserCompletion = (Bool, [Tweet]?) -> ()

class JSONParser {
    static var sampleJSONData: Data { //computed property
        guard let tweetJSONPath = Bundle.main.url(forResource: "Tweet", withExtension: ".json") else {
            fatalError("There was an error accessing Tweet.json") }
        do {
            let tweetJSONData = try Data(contentsOf: tweetJSONPath)
            return tweetJSONData
            
        } catch {
            fatalError("Failed to convert Tweet.json to data!")
        }
    }
    
    class func tweetsFrom(data: Data, completion: JSONParserCompletion) {
        do {
            if let rootObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String : Any]] { //casting as array of dictionary(ies)
                
                var tweets = [Tweet]()
                
                for object in rootObject {
                    if let tweet = Tweet(json: object) {
                        tweets.append(tweet)
                    }
                }
                print("tweets array was appended!")
                completion(true, tweets)
            }
            
        } catch {
            print("Error serializing JSON!!")
            completion(false, nil)
        }
    }
}
