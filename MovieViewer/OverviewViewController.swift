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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movieTrailer: NSDictionary! // implicitly unwrapped
    
    var overview: String?
    var backdrop: NSURL?
    var trailerId: String?
    //var videos: [NSDictionary]?
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
            print("Testing" + trailerId)
            
            let videoPlayerViewController: XCDYouTubeVideoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: "9bZkp7q19f0")
            videoPlayerViewController.presentInView(self.videoPlayer)
            videoPlayerViewController.moviePlayer.play()
            
            let session = NSURLSession(
                configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                delegate: nil,
                delegateQueue: NSOperationQueue.mainQueue()
            )
            
            let videoStart = "http://api.themoviedb.org/3/movie/"
            let vidId = trailerId
            let endStart = "/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
            let videoFinalUrl = videoStart + vidId + endStart
            print("Now playing: " + videoFinalUrl)
            
            let videoUrl = NSURL(string: videoFinalUrl)
            
            //let videoUrl = NSURL(string: "http://api.themoviedb.org/3/movie/265312/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
            
            let videoRequest = NSURLRequest(
                URL: videoUrl!,
                cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
                timeoutInterval: 10)
            
            var videos: [NSDictionary]?
            
            let videoTask: NSURLSessionDataTask = session.dataTaskWithRequest(videoRequest,
                completionHandler: { (dataOrNil, response, error) in
                    
                    if let data = dataOrNil {
                        if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                            data, options:[]) as? NSDictionary {
                                print("response: \(responseDictionary)")
                                
                                // have to reload data after the network request has been made
                                videos = responseDictionary["results"] as? [NSDictionary]
                                
                                //self.testTrailer = responseDictionary[0]!["key"] as? String
                                //print("LOOK CHECK ME OUT " + self.testTrailer!)
                                //let videoResponse = self.videos![0] // unwraps
                                //self.testTrailer = videoResponse["key"] as! String
                                //print("Jennifer" + self.trailerId!)
                                
                        }
                    }
                    
            })
            videoTask.resume()
            
//            let video = videos![0] // unwraps
//            let trailer = video["id"] as! NSNumber
//            print("Check out this trailer" + String(trailer))
        }
        //let videoUrl = NSURL(string: "http://api.themoviedb.org/3/movie/265312/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
