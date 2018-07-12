//
//  ImageTableViewCell.swift
//  FlickerDemo
//
//  Created by Ravi Tailor on 02/07/18.
//  Copyright © 2018 Ravi Tailor. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var dataTask : URLSessionDataTask?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setupData(_ data : PhotoModel?)  {
        if let model = data {
            self.lblTitle.text = model.title
            self.imgView.image = nil
            let url = "http://farm" + String(model.farm) + ".static.flickr.com/" + model.server + "/" + model.id + "_" + model.secret + ".jpg"
            self.activityIndicator.startAnimating()
            self.dataTask = ImageCacheManager.getImageFromUrl(url: url) { (image) in
                self.activityIndicator.isHidden = true
                self.activityIndicator.startAnimating()
                guard let image = image else {
                    self.activityIndicator.startAnimating()
                    return
                }
                DispatchQueue.main.async {
                    self.imgView.image = image
                }
            }
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgView.image = nil
        self.lblTitle.text = ""
        self.dataTask?.cancel()
    }
}
