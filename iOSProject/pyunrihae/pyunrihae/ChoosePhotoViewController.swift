//
//  ChoosePhotoViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 11..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit
import Photos

class ChoosePhotoViewController: UIViewController {

    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func tabBackBtn(_ sender: UIButton) {
        let writingReviewViewController = self.navigationController?.viewControllers[1] as! WritingReviewViewController
        self.navigationController?.popToViewController(writingReviewViewController, animated: true)
    }
    @IBAction func tabCompleteBtn(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("chooseImage"), object: self, userInfo: ["image" : selectedImage.image!])
        let writingReviewViewController = self.navigationController?.viewControllers[1] as! WritingReviewViewController
        self.navigationController?.popToViewController(writingReviewViewController, animated: true)
    }
    var images = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsSelection = true
        images = Photo().getPhotos()
        selectedImage.image = images[0]
        collectionView.frame = CGRect(x: 0 ,y: selectedImage.frame.height + 10, width: (collectionView.superview?.frame.width)!, height: CGFloat(images.count) * (collectionView.superview?.frame.width)! / 4)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ChoosePhotoViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? PhotoCollectionViewCell {
            cell.image.image = images[indexPath.item]
            cell.image.frame = CGRect(x: 1, y:1, width: collectionView.frame.width / 4 - 2 , height: collectionView.frame.width / 4 - 2)
            cell.flagForSelect.frame = cell.image.frame
            return cell
        }
        return PhotoCollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 4 , height: collectionView.frame.width / 4)
    }
}
extension ChoosePhotoViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.isSelected = true
        let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell
        let image = cell?.image.image
        selectedImage.image = image
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.row != 0{
            collectionView.cellForItem(at: indexPath)?.isSelected = true
        }
    }
}
