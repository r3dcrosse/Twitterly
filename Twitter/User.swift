//
//  User.swift
//  Twitter
//
//  Created by David Wayman on 2/9/16.
//  Copyright © 2016 David Wayman. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageUrl: NSURL?
    var profileBackgroundImageUrl: NSURL?
    var tagline: String?
    var userID: String?
    var dictionary: NSDictionary
    var numFollowers: Int?
    var numFollowing: Int?
    var numTweets: Int?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        tagline = dictionary["description"] as? String
        userID = dictionary["user_id"] as? String
        numFollowers = dictionary["followers_count"] as? Int
        numFollowing = dictionary["friends_count"] as? Int
        numTweets = dictionary["statuses_count"] as? Int
        
        let imageURLString = dictionary["profile_image_url"] as? String
        if imageURLString != nil {
            profileImageUrl = NSURL(string: imageURLString!)!
        }
        
        let backgroundImageURLString = dictionary["profile_background_image_url_https"] as? String
        if backgroundImageURLString != nil {
            profileBackgroundImageUrl = NSURL(string: backgroundImageURLString!)!
        }
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    do {
                        let dictionary =  try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                        _currentUser = User(dictionary: dictionary)
                    } catch(let error) {
                        print(error)
                        assert(false)
                    }
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                do {
                    let data = try NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: NSJSONWritingOptions.PrettyPrinted)
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                } catch(let error) {
                    print(error)
                    assert(false)
                }
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
