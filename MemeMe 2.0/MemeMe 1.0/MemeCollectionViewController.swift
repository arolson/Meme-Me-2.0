//
//  CollectionViewController.swift
//  MemeMe 2.0
//
//  Created by Andrew Olson on 7/23/16.
//  Copyright © 2016 Andrew Olson. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController
{
    var memes = [Meme]()
    
    @IBOutlet var memeCollectionView: UICollectionView!
    private var currentIndexPath: NSIndexPath!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    //update memes array and reload tabel upon rentry
    override func viewWillAppear(animated: Bool)
    {
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
        self.memeCollectionView.reloadData()
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return memes.count
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell

        if let meme = memes[indexPath.row].memeImage
        {
            cell.cellImageView.image = meme
        }
        return cell
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        self.currentIndexPath = indexPath
        self.performSegueWithIdentifier("memeDetailView", sender: self)
        print("meme Seque Action")
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "memeDetailView"
        {
            if let memeCell = memeCollectionView.cellForItemAtIndexPath(currentIndexPath) as? MemeCollectionViewCell
            {
                if let activityController = segue.destinationViewController as? MemeDetailView
                {
                    activityController.memeImage = memeCell.cellImageView.image
                }
            }
        }

    }
    
}
