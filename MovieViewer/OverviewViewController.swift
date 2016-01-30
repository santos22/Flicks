//
//  OverviewViewController.swift
//  MovieViewer
//
//  Created by Santos Solorzano on 1/28/16.
//  Copyright © 2016 santosjs. All rights reserved.
//

import UIKit
import XCDYouTubeKit

class OverviewViewController: UIViewController {

    //@IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var backdropImage: UIImageView!
    
    @IBOutlet weak var movieOverview: UITextView!
    @IBOutlet weak var videoPlayer: UIView!
    
    var overview: String?
    var backdrop: NSURL?
    var trailerId: String?
    var videos: [NSDictionary]?
    var testTrailer: String?
    
    var videoTrailer: String?
    // "9bZkp7q19f0"
    
    //var videoPlayerViewController: XCDYouTubeVideoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: "9bZkp7q19f0")
    //var videoPlayerViewController: XCDYouTubeVideoPlayerViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let overview = self.overview {
            movieOverview.text = overview
        }
        
//        if let overview = self.overview {
//            overviewLabel.text = overview
//        }
        
        if let backdrop = self.backdrop {
            backdropImage.setImageWithURL(backdrop)
        }
        
//        if let trailerId = self.trailerId {
//            //videoTrailer = trailerId
//            print("HI THERE VIDEO TRAILER" + trailerId)
//            let videoPlayerViewController: XCDYouTubeVideoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: trailerId)
//            videoPlayerViewController.presentInView(self.videoPlayer)
//            videoPlayerViewController.moviePlayer.play()
//        }
        
        if let trailerId = self.trailerId {
            //videoTrailer = trailerId
            print("Testing" + trailerId)
        }

        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let videoStart = "http://api.themoviedb.org/3/movie/"
        let vidId = trailerId
        let endStart = "/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let video = videoStart + vidId! + endStart
        
        let videoUrl = NSURL(string: video)
        
        //let videoUrl = NSURL(string: "http://api.themoviedb.org/3/movie/265312/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        
        let videoRequest = NSURLRequest(
            URL: videoUrl!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        
        let videoTask: NSURLSessionDataTask = session.dataTaskWithRequest(videoRequest,
            completionHandler: { (dataOrNil, response, error) in
                
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            
                            // have to reload data after the network request has been made
                            self.videos = responseDictionary["results"] as! [NSDictionary]
                            
                            //self.testTrailer = responseDictionary["results"]!["key"] as! String!
                            //print("LOOK CHECK ME OUT " + self.testTrailer!)
                            //let videoResponse = self.videos![0] // unwraps
                            //self.testTrailer = videoResponse["key"] as! String
                            //print("Jennifer" + self.trailerId!)
                            
                    }
                }
        })
        videoTask.resume()
        
//        let videoArray = videos![0] // unwraps
//        let keyId = videoArray["key"] as! String
//        print(videos!.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
