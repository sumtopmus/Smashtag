//
//  MediaTableViewCell.swift
//  Smashtag
//
//  Created by Oleksandr Iaroshenko on 29.04.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import UIKit

class MediaTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewInCell: UIImageView!

    var mediaItem: MediaItem? {
        didSet {
            let qos = Int(QOS_CLASS_USER_INITIATED.value)
            let queue = dispatch_get_global_queue(qos, 0)
            dispatch_async(queue) {
                if let imageUrl = self.mediaItem?.url, imageData = NSData(contentsOfURL: imageUrl) {
                    dispatch_async(dispatch_get_main_queue()) {
                        imageViewInCell?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}

//if let imageUrl = self.mediaItem?.url, imageData = NSData(contentsOfURL: imageUrl) {
//    self.imageViewInCell?.image = UIImage(data: imageData)
//}