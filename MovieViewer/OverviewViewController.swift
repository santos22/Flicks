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

    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var backdropImage: UIImageView!
    
    @IBOutlet weak var videoPlayer: UIView!
    var overview: String?
    var backdrop: NSURL?
    var trailerId: String?
    
    var videoTrailer: String?
    // "9bZkp7q19f0"
    
    //var videoPlayerViewController: XCDYouTubeVideoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: "9bZkp7q19f0")
    //var videoPlayerViewController: XCDYouTubeVideoPlayerViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let overview = self.overview {
            overviewLabel.text = overview
        }
        
        if let backdrop = self.backdrop {
            backdropImage.setImageWithURL(backdrop)
        }
        
        if let trailerId = self.trailerId {
            //videoTrailer = trailerId
            print("HI THERE VIDEO TRAILER")
            let videoPlayerViewController: XCDYouTubeVideoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: trailerId)
            videoPlayerViewController.presentInView(self.videoPlayer)
            videoPlayerViewController.moviePlayer.play()
        }
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
