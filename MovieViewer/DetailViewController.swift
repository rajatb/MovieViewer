//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Rajat Bhargava on 9/13/17.
//  Copyright © 2017 Rajat Bhargava. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelOverview: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: infoView.frame.origin.y +
        infoView.frame.height)
        
        let title = movie["title"] as? String
        let overview = movie["overview"]
    
        
        labelTitle.text = title
        labelOverview.text = overview as? String
        labelOverview.sizeToFit()
        
        let baseUrl = "https://image.tmdb.org/t/p/original"
        if let posterPath = movie["poster_path"] as? String {
            let posterURL = URL(string: baseUrl + posterPath)
            posterImg.setImageWith(posterURL!)
            
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
