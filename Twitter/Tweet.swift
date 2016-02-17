//
//  Tweet.swift
//  Twitter
//
//  Created by David Wayman on 2/9/16.
//  Copyright © 2016 David Wayman. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var id: String
    var retweetCount: Int?
    var likeCount: Int?
    var isFavorited: Bool?
    var isRetweeted: Bool?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        id = String(dictionary["id"]!)
        retweetCount = dictionary["retweet_count"] as? Int
        likeCount = dictionary["favorite_count"] as? Int
        isFavorited = dictionary["favorited"] as? Bool
        isRetweeted = dictionary["retweeted"] as? Bool
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
