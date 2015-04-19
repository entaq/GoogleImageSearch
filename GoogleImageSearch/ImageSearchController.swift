//
//  ImageSearchController.swift
//  GoogleImageSearch
//
//  Created by Arun Nagarajan on 4/19/15.
//  Copyright (c) 2015 Arun Nagarajan. All rights reserved.
//

import UIKit

let reuseIdentifier = "ImageCell"

class ImageSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
    
        cell.backgroundColor = UIColor.whiteColor()
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}