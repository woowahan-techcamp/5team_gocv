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
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        let options = PHImageRequestOptions()
        
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact

        let manager = PHImageManager.default()
        for i in 0..<allPhotos.count {
            let asset = allPhotos.object(at: i)
            imageSize.width = CGFloat(asset.pixelWidth)
            imageSize.height = CGFloat(asset.pixelHeight)
            manager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFit, options: options, resultHandler: {(result, info) in
                images.append(result!)
            })
        }
        
        return images
    }
}
