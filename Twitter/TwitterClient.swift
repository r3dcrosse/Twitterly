//
//  TwitterClient.swift
//  Twitter
//
//  Created by David Wayman on 2/8/16.
//  Copyright © 2016 David Wayman. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "mqgSWOkOeKpnocWq0p3LldE0b"
let twitterConsumerSecret = "bbOkh3NBMauAnLPgEAnctZG6GAL7YqKGaILG0wRs0XlHRbHGso"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?

    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        TwitterClient.sharedInstance.GET(
            "1.1/statuses/home_timeline.json",
            parameters: params,
            success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                print("home timeline: \(response!)")
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                
                completion(tweets: tweets, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error getting home timeline")
                completion(tweets: nil, error: error)
        })

    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token and redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            
            }) { (error: NSError!) -> Void in
                print("Failed to get request token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Got the access token")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.GET(
                "1.1/account/verify_credentials.json",
                parameters: nil,
                success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                    // print("user: \(response!)")
                    let user = User(dictionary: response as! NSDictionary)
                    User.currentUser = user
                    print("user: \(user.name)")
                    self.loginCompletion?(user: user, error: nil)
                },
                failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("error getting current user")
                    self.loginCompletion?(user: nil, error: error)
            })
            
            }) { (error: NSError!) -> Void in
                print("Failed to recieve access token")
                self.loginCompletion?(user: nil, error: error)
        }

    }
    
    func retweet(tweetID: String) {
        print("Attempting to retweet tweetID: \(tweetID)")
        let retweetURL = NSURL(string: "https://api.twitter.com/1.1/statuses/retweet/\(tweetID).json")
        //openURL(retweetURL!)
    }
}
