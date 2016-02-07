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
    var endpoint: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set navigation bar appearance and color
        let mainNavigationBarAppearace = UINavigationBar.appearance()
        mainNavigationBarAppearace.tintColor = UIColor.blackColor()
        mainNavigationBarAppearace.barStyle = UIBarStyle.Black
        mainNavigationBarAppearace.barTintColor = UIColor.blackColor()
        mainNavigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        self.tableView.backgroundColor = UIColor(red: 0.30, green: 0.29, blue: 0.29, alpha: 1.0)
        self.tableView.separatorColor = UIColor.blackColor()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        tableView.dataSource = self
        tableView.delegate = self
        
        loadMovieData()
    }
    
    func loadMovieData() {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        
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
        
        // parse JSON into NSDictionary and load
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            cell.titleLabel.textColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
            cell.titleLabel.text = title
        }
        
        if let movieId = String(movie["vote_average"] as! NSNumber) as? String {
            let average = Double(movieId)
            let voteTruncated = Double(round(100*average!)/100)
            cell.overviewLabel.textColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
            cell.overviewLabel.text = String(voteTruncated) + " / 10"
        }
        
        if let posterPath = movie["id"] as? String {
            let imageUrl = NSURL(string: baseUrl + posterPath)
            cell.posterView.setImageWithURL(imageUrl!)
        }
        
        // cell animation
        cell.alpha = 0
        cell.selectionStyle = .None
        UIView.animateWithDuration(1, animations: { cell.alpha = 1 })
        return cell
    }
    
    // make a network request to refresh data and update table view
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
                
                self.tableView.reloadData()
                refreshControl.endRefreshing()	
        });
        task.resume()
    }
    
//    func getMovieReleaseDate() {
//        let trailer = movie["id"] as! NSNumber
//        let releaseDate = movie["release_date"]
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let orignalDate: NSDate = dateFormatter.dateFromString(releaseDate as! String!)!
//        dateFormatter.dateFormat = "MMMM dd, yyyy"
//        print(dateFormatter.stringFromDate(orignalDate))
//    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showOverviewSegue" {
            let cell = sender as! UITableViewCell
            
            let view = cell.contentView
            view.layer.opacity = 0.1
            UIView.animateWithDuration(1.4) {
                view.layer.opacity = 1
            }
            if let indexPath = tableView.indexPathForCell(cell) {
                let nameController = segue.destinationViewController as! OverviewViewController
                let movie = movies![indexPath.row] // unwraps
                
                let baseUrl = "http://image.tmdb.org/t/p/w500"
                
                if let backdropPath = movie["backdrop_path"] as? String {
                    let backdropUrl = NSURL(string: baseUrl + backdropPath)
                    nameController.backdrop = backdropUrl
                    
                }
                else {
                    // no poster image, so set to nil (no image)
                    nameController.backdrop = nil
                }
                
                // overview and id info passed over to next controller
                if let overview = movie["overview"] as? String {
                    nameController.overview = overview
                }
                
                if let movieId = movie["id"] as? NSNumber {
                    printId = String(movieId)
                    nameController.trailerId = printId
                }
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
    }

}
