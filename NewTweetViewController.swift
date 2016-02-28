//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by David Wayman on 2/28/16.
//  Copyright © 2016 David Wayman. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {

    @IBOutlet weak var tweetText: UITextView!
    var user: User!
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSendTweet(sender: AnyObject) {
        
        // Send the tweet
        var formattedString: String = ""
        if let tweetText = tweetText.text {
            formattedString = tweetText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            
            TwitterClient.sharedInstance.sendTweet(formattedString, params: nil, completion:  { (error) -> () in
                self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
                    self.tweetText.text = " "
                })
            })
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
