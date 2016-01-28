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
    
    @IBOutlet weak var videoPlayer: UIView!
    var overview: String?
    
    var videoPlayerViewController: XCDYouTubeVideoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: "9bZkp7q19f0")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoPlayerViewController.presentInView(self.videoPlayer)
        videoPlayerViewController.moviePlayer.play()
        
        if let overview = self.overview {
            overviewLabel.text = overview
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
