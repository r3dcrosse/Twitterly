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

    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
}
