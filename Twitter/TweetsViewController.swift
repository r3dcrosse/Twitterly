//
//  TweetsViewController.swift
//  Twitter
//
//  Created by David Wayman on 2/9/16.
//  Copyright © 2016 David Wayman. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetCellButtonDelegate {

    var endpoint: String!
    var tweets: [Tweet]?
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        print("CURRENT ENDPOINT: \(endpoint)")
        
        TwitterClient.sharedInstance.getEndpointTimelineWithParams(endpoint, params: nil, completion:  { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
        
        // Do any additional setup after loading the view.
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            print("TWEETS COUNT:::::::::::::::::::::::: \(tweets!.count)")
            return tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        cell.buttonDelegate = self
        cell.tweet = tweets![indexPath.row]
        
        return cell
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        // Make network request to fetch latest data
        TwitterClient.sharedInstance.getEndpointTimelineWithParams(endpoint, params: nil, completion:  { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
        
        refreshControl.endRefreshing()
    }
    
    func retweetClicked(tweetCell: TweetCell) {
        
        let tweet = tweetCell.tweet! as Tweet
        
        // Check if tweet has already been retweeted
        // By way of cool ternary operator:
        tweet.isRetweeted! ? (
            // It's been retweeted already... let's unretweet it:
            TwitterClient.sharedInstance.unRetweet(Int(tweetCell.tweetID)!, params: nil, completion: {(error) -> () in
                tweetCell.retweetButton.setImage(UIImage(named: "retweet-action.png"), forState: UIControlState.Selected)
                
                if tweet.retweetCount! > 1 {
                    tweetCell.retweetCountLabel.text = String(tweet.retweetCount! - 1)
                } else {
                    tweetCell.retweetCountLabel.hidden = true
                    tweetCell.retweetCountLabel.text = String(tweet.retweetCount! - 1)
                }
                
                // locally update tweet dictionary so we don't need to make network request in order to update that cell
                tweet.retweetCount! -= 1
                tweet.isRetweeted! = false
            }) // END CLOSURE
        ) : (
            // YES! HASN'T BEEN RETWEETED, SO LET'S DO THAT:
            TwitterClient.sharedInstance.retweet(Int(tweetCell.tweetID)!, params: nil, completion: {(error) -> () in
                tweetCell.retweetButton.setImage(UIImage(named: "retweet-action-on-pressed.png"), forState: UIControlState.Selected)
                
                if tweet.retweetCount! > 0 {
                    tweetCell.retweetCountLabel.text = String(tweet.retweetCount! + 1)
                } else {
                    tweetCell.retweetCountLabel.hidden = false
                    tweetCell.retweetCountLabel.text = String(tweet.retweetCount! + 1)
                }
                
                // locally update tweet dictionary so we don't need to make network request in order to update that cell
                tweet.retweetCount! += 1
                tweet.isRetweeted! = true
            }) // END CLOSURE
        ) // END TERNARY OPERATOR
    }
    
    func favoriteClicked(tweetCell: TweetCell) {
        
        let tweet = tweetCell.tweet! as Tweet
        
        // Check if tweet has already been favorited
        // By way of cool ternary operator:
        tweet.isFavorited! ? (
            // It's been liked already... let's unlike it:
            TwitterClient.sharedInstance.unLikeTweet(Int(tweetCell.tweetID)!, params: nil, completion: {(error) -> () in
                tweetCell.likeButton.setImage(UIImage(named: "like-action.png"), forState: UIControlState.Selected)
                
                if tweet.likeCount > 1 {
                    tweetCell.likeCountLabel.text = String(tweet.likeCount! - 1)
                } else {
                    tweetCell.likeCountLabel.hidden = true
                    tweetCell.likeCountLabel.text = String(tweet.likeCount! - 1)
                }
                
                // locally update tweet dictionary so we don't need to make network request in order to update that cell
                tweet.likeCount! -= 1
                tweet.isFavorited! = false
            }) // END CLOSURE
        ) : (
            // YAY! It hasn't been liked before... Let's like it:
            TwitterClient.sharedInstance.likeTweet(Int(tweetCell.tweetID)!, params: nil, completion: {(error) -> () in
                tweetCell.likeButton.setImage(UIImage(named: "like-action-on.png"), forState: UIControlState.Selected)
                
                if tweet.likeCount > 0 {
                    tweetCell.likeCountLabel.text = String(tweet.likeCount! + 1)
                } else {
                    tweetCell.likeCountLabel.hidden = false
                    tweetCell.likeCountLabel.text = String(tweet.likeCount! + 1)
                }
                
                // locally update tweet dictionary so we don't need to make network request in order to update that cell
                tweet.likeCount! += 1
                tweet.isFavorited! = true
            }) // END CLOSURE
        ) // END TERNARY OPERATOR
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
