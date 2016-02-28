//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by David Wayman on 2/23/16.
//  Copyright © 2016 David Wayman. All rights reserved.
//

import UIKit


class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var numRetweetsLabel: UILabel!
    @IBOutlet weak var numLikesLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
        
    var tweet: Tweet!
    var tweetID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = tweet.user!.name
        screenNameLabel.text = "@\(tweet.user!.screenname!)"
        tweetTextView.text = tweet.text
        thumbImageView.setImageWithURL(tweet.user!.profileImageUrl!)
        timeAgoLabel.text = calculateTimeStamp(tweet.createdAt!.timeIntervalSinceNow)
        tweetID = tweet.id
        numRetweetsLabel.text = String(tweet.retweetCount!)
        numLikesLabel.text = String(tweet.likeCount!)
        
        tweet.isRetweeted! ? // Check if tweet has been retweeted, set button image depending on isRetweeted
            (self.retweetButton.setImage(UIImage(named: "retweet-action-on-pressed.png"), forState: UIControlState.Selected)) :
            (self.retweetButton.setImage(UIImage(named: "retweet-action.png"), forState: UIControlState.Selected))
        
        tweet.isFavorited! ? // Check if tweet has been favorited, set button image depending on isFavorited
            (self.likeButton.setImage(UIImage(named: "like-action-on.png"), forState: UIControlState.Selected)) :
            (self.likeButton.setImage(UIImage(named: "like-action.png"), forState: UIControlState.Selected))
        
        // create tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: "thumbImageTapped:")
        
        // add it to the image view;
        thumbImageView.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        thumbImageView.userInteractionEnabled = true
        
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calculateTimeStamp(timeTweetPostedAgo: NSTimeInterval) -> String {
        // Turn timeTweetPostedAgo into seconds, minutes, hours, days, or years
        var rawTime = Int(timeTweetPostedAgo)
        var timeAgo: Int = 0
        var timeChar = ""
        
        rawTime = rawTime * (-1)
        
        // Figure out time ago
        if (rawTime <= 60) { // SECONDS
            timeAgo = rawTime
            timeChar = "s"
        } else if ((rawTime/60) <= 60) { // MINUTES
            timeAgo = rawTime/60
            timeChar = "m"
        } else if (rawTime/60/60 <= 24) { // HOURS
            timeAgo = rawTime/60/60
            timeChar = "h"
        } else if (rawTime/60/60/24 <= 365) { // DAYS
            timeAgo = rawTime/60/60/24
            timeChar = "d"
        } else if (rawTime/(60/60/24/365) <= 1) { // ROUGH ESTIMATE OF YEARS
            timeAgo = rawTime/60/60/24/365
            timeChar = "y"
        }
        
        return "\(timeAgo)\(timeChar)"
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        // Check if tweet has already been retweeted
        // By way of cool ternary operator:
        tweet.isRetweeted! ? (
            // It's been retweeted already... let's unretweet it:
            TwitterClient.sharedInstance.unRetweet(Int(tweet.id)!, params: nil, completion: {(error) -> () in
                self.retweetButton.setImage(UIImage(named: "retweet-action.png"), forState: UIControlState.Selected)
                
                if self.tweet.retweetCount! > 1 {
                    self.numRetweetsLabel.text = String(self.tweet.retweetCount! - 1)
                } else {
                    self.numRetweetsLabel.text = String(self.tweet.retweetCount! - 1)
                }
                
                // locally update tweet dictionary so we don't need to make network request in order to update that cell
                self.tweet.retweetCount! -= 1
                self.tweet.isRetweeted! = false
            }) // END CLOSURE
            ) : (
                // YES! HASN'T BEEN RETWEETED, SO LET'S DO THAT:
                TwitterClient.sharedInstance.retweet(Int(tweet.id)!, params: nil, completion: {(error) -> () in
                    self.retweetButton.setImage(UIImage(named: "retweet-action-on-pressed.png"), forState: UIControlState.Selected)
                    
                    if self.tweet.retweetCount! > 0 {
                        self.numRetweetsLabel.text = String(self.tweet.retweetCount! + 1)
                    } else {
                        self.numRetweetsLabel.text = String(self.tweet.retweetCount! + 1)
                    }
                    
                    // locally update tweet dictionary so we don't need to make network request in order to update that cell
                    self.tweet.retweetCount! += 1
                    self.tweet.isRetweeted! = true
                }) // END CLOSURE
        ) // END TERNARY OPERATOR
    }
    
    
    @IBAction func onLike(sender: AnyObject) {
        // Check if tweet has already been favorited
        // By way of cool ternary operator:
        tweet.isFavorited! ? (
            // It's been liked already... let's unlike it:
            TwitterClient.sharedInstance.unLikeTweet(Int(tweet.id)!, params: nil, completion: {(error) -> () in
                self.likeButton.setImage(UIImage(named: "like-action.png"), forState: UIControlState.Selected)
                
                if self.tweet.likeCount > 1 {
                    self.numLikesLabel.text = String(self.tweet.likeCount! - 1)
                } else {
                    self.numLikesLabel.text = String(self.tweet.likeCount! - 1)
                }
                
                // locally update tweet dictionary so we don't need to make network request in order to update that cell
                self.tweet.likeCount! -= 1
                self.tweet.isFavorited! = false
            }) // END CLOSURE
            ) : (
                // YAY! It hasn't been liked before... Let's like it:
                TwitterClient.sharedInstance.likeTweet(Int(tweet.id)!, params: nil, completion: {(error) -> () in
                    self.likeButton.setImage(UIImage(named: "like-action-on.png"), forState: UIControlState.Selected)
                    
                    if self.tweet.likeCount > 0 {
                        self.numLikesLabel.text = String(self.tweet.likeCount! + 1)
                    } else {
                        self.numLikesLabel.text = String(self.tweet.likeCount! + 1)
                    }
                    
                    // locally update tweet dictionary so we don't need to make network request in order to update that cell
                    self.tweet.likeCount! += 1
                    self.tweet.isFavorited! = true
                }) // END CLOSURE
        ) // END TERNARY OPERATOR
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "detailToProfileSegue" {
            let tweet = self.tweet
            
            let profileTimelineViewController = segue.destinationViewController as! ProfileViewController
            profileTimelineViewController.tweet = tweet
        }
    }
    

}
