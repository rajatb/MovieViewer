//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Rajat Bhargava on 9/12/17.
//  Copyright © 2017 Rajat Bhargava. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary]?
    var endpoint: String?
    let refreshControl = UIRefreshControl()
    var searchController: UISearchController!
    
    let urlBase: String = "https://api.themoviedb.org/3/"
    let api_key = "d0837fd21e83186defbf93a8be3e87dd"
    var url: URL?
    

    
    
    
    @IBOutlet weak var networkErrorMsg: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Custom Navigation Controller
        self.navigationItem.title = "Flickr"

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        
        tableView.tableHeaderView = searchController.searchBar
        
        definesPresentationContext = true
        
        url = URL(string:"\(urlBase)movie/\(endpoint!)?api_key=\(api_key)")
        
        
        refreshControl.addTarget(self, action: #selector(refreshedNetworkCall), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        networkCall()
        
    }
    
    func refreshedNetworkCall(){
        url = URL(string:"\(urlBase)movie/\(endpoint!)?api_key=\(api_key)")
        networkCall()
    }
    
    func networkCall() {
        
        var request = URLRequest(url: url!)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 5
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        MBProgressHUD.hide(for: self.view, animated: true)
        //HUD
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler:
            { (dataOrNil, response, error) in
                //HUD completed
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if let err = error  {
                   self.refreshControl.endRefreshing()
                   self.showNetworkErrorMsg()
                } else {
                    if let data = dataOrNil {
                        print("*****about to get data****")
                        self.networkErrorMsg.isHidden = true
                        
                        let responseDict = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        
                        self.movies = responseDict["results"] as? [NSDictionary]
                        self.refreshControl.endRefreshing()
                        self.tableView.reloadData()
                       
                    }
                }
                        });
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let basePath = "https://image.tmdb.org/t/p/w342"
        
        
        

        cell.lblTitle.text = title
        cell.lblBody.text = overview
        
        // fade in the poster
        
        if let posterPath = movie["poster_path"] as? String {
            
            let imageUrl = URL(string: basePath + posterPath)
            let imageRequest = URLRequest(url: imageUrl!)
            cell.postView.setImageWith(imageRequest, placeholderImage: nil, success: { (imageRequest, response, image) in
                
                if response != nil {
                    cell.postView.alpha = 0.0
                    cell.postView.image = image
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        cell.postView.alpha = 1.0
                    })
                } else {
                    cell.postView.image = image
                }
            }, failure: { (imageRequest, response, error) in
                print("Failure")
            })
            //cell.postView.setImageWith(imageUrl!)
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor("#f7f7f7")
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showNetworkErrorMsg(){
        networkErrorMsg.frame = CGRect(x: 0, y: 20, width: 375, height: 50)
        networkErrorMsg.isHidden = false
        
        UIView.animate(withDuration: 0.35, animations: {
            self.networkErrorMsg.frame = CGRect(x: 0, y: 60, width: 375, height: 50)
        })
        
        
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            searchMovieNetworkCall(movie: searchText)
        }else {
            print("I got called")
        }
        
    }
    
    private func searchMovieNetworkCall(movie: String){
        
        self.url = URL(string:"\(urlBase)search/movie?api_key=\(api_key)&language=en-US&page=1&include_adult=false&query=\(movie)")
        networkCall()
        
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        refreshedNetworkCall()
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = movies![(indexPath?.row)!]
        
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
    }
   
    

}
