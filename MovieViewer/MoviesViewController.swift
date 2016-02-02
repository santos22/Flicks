//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Santos Solorzano on 1/24/16.
//  Copyright © 2016 santosjs. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD
import XCDYouTubeKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    var videos: [NSDictionary]?
    var trailer: String?
    var printId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle()
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        tableView.dataSource = self
        tableView.delegate = self
        
        // load movie data
        loadMovieData()
    }
    
    // sets title of app
    func setTitle() {
        self.title = "Flicks"
    }
    
    func loadMovieData() {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        // NSJSONSerialization is a method to parse JSON
        // into NSDictionary and load it into response
        // dictionary
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            //print("response: \(responseDictionary)")
                            
                            // have to reload data after the network request has been made
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            self.tableView.reloadData()
                    }
                }
        })
        task.resume()
    }
    
//    func getTrailer(id: String) {
//        let session = NSURLSession(
//            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
//            delegate: nil,
//            delegateQueue: NSOperationQueue.mainQueue()
//        )
//        
//        let videoStart = "http://api.themoviedb.org/3/movie/"
//        let vidId = trailerId
//        let endStart = "/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
//        let video = videoStart + vidId! + endStart
//        
//        let videoUrl = NSURL(string: video)
//        
//        //let videoUrl = NSURL(string: "http://api.themoviedb.org/3/movie/265312/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
//        
//        let videoRequest = NSURLRequest(
//            URL: videoUrl!,
//            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
//            timeoutInterval: 10)
//        
//        
//        let videoTask: NSURLSessionDataTask = session.dataTaskWithRequest(videoRequest,
//            completionHandler: { (dataOrNil, response, error) in
//                
//                if let data = dataOrNil {
//                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
//                        data, options:[]) as? NSDictionary {
//                            print("response: \(responseDictionary)")
//                            
//                            // have to reload data after the network request has been made
//                            self.videos = responseDictionary["results"] as? [NSDictionary]
//                            
//                            
//                            //self.testTrailer = responseDictionary[0]!["key"] as? String
//                            //print("LOOK CHECK ME OUT " + self.testTrailer!)
//                            //let videoResponse = self.videos![0] // unwraps
//                            //self.testTrailer = videoResponse["key"] as! String
//                            //print("Jennifer" + self.trailerId!)
//                            
//                    }
//                }
//                
//        })
//        videoTask.resume()
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // if movies is not nil, go ahead and assign that to a
        // constant
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row] // unwraps
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        if let posterPath = movie["poster_path"] as? String {
            let imageUrl = NSURL(string: baseUrl + posterPath)
            cell.posterView.setImageWithURL(imageUrl!)
        }
        
        if let title = movie["title"] as? String {
            cell.titleLabel.text = title
        }
        
        if let movieId = String(movie["vote_average"] as! NSNumber) as? String {
            cell.overviewLabel.text = movieId
        }
        
        if let posterPath = movie["id"] as? String {
            let imageUrl = NSURL(string: baseUrl + posterPath)
            cell.posterView.setImageWithURL(imageUrl!)
        }
        return cell
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (data, response, error) in
                
                // ... Use the new data to update the data source ...
                
                // Reload the tableView now that there is new data
                self.tableView.reloadData()
                
                // Tell the refreshControl to stop spinning
                refreshControl.endRefreshing()	
        });
        task.resume()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showOverviewSegue" {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPathForCell(cell) {
                let nameController = segue.destinationViewController as! OverviewViewController
                let movie = movies![indexPath.row] // unwraps
                
                let trailer = movie["id"] as! NSNumber
                //print("Check out this trailer" + String(trailer))
                
                let baseUrl = "http://image.tmdb.org/t/p/w500"
                
                if let backdropPath = movie["backdrop_path"] as? String {
                    let backdropUrl = NSURL(string: baseUrl + backdropPath)
                    nameController.backdrop = backdropUrl
                    
                }
                else {
                    // No poster image. Can either set to nil (no image) or a default movie poster image
                    // that you include as an asset
                    nameController.backdrop = nil
                }
                
                // change to if let
                let overview = movie["overview"] as! String
                let movieId = movie["id"] as! NSNumber
                printId = String(movieId)
                
                nameController.overview = overview
                nameController.trailerId = printId
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
    }

}
