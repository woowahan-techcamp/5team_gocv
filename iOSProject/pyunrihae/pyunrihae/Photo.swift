//
//  Photo.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 11..
//  Copyright © 2017년 busride. All rights reserved.
//

import Foundation
import Photos
import UIKit

class Photo{
    var imageSize: CGSize! = CGSize(width: 0.0, height: 0.0)
    func getPhotos () -> [UIImage] {
        
        var images = [UIImage]()
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        let options = PHImageRequestOptions()
        
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact

        let manager = PHImageManager.default()
        for i in 0..<allPhotos.count {
            let asset = allPhotos.object(at: i)
            manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize,
                contentMode: .aspectFit, options: options, resultHandler: {(result, info) in
                    if let image = result {
                        images.append(image)
                    }
            })
        }
        
        return images
    }
}
