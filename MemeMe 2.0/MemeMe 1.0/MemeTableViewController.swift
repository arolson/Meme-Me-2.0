//
//  TableViewController.swift
//  MemeMe 2.0
//
//  Created by Andrew Olson on 7/20/16.
//  Copyright © 2016 Andrew Olson. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var memes = [Meme]()
    
    
    @IBOutlet weak var memeTableView: UITableView!
    private var currentIndexPath: NSIndexPath!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //retrieve The memes from the app delegate
    }
    //update memes array and reload tabel upon rentry
    override func viewWillAppear(animated: Bool)
    {
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
        self.memeTableView.reloadData()
        print(memes)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return memes.count
    }
    
    
    /**
     * Cell For Row At Index Path
     */
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell")!
        
        if let meme = memes[indexPath.row].memeImage
        {
            let cellText = memes[indexPath.row].topText + " " + memes[indexPath.row].bottomText
            cell.imageView?.image = meme
            cell.textLabel?.text = cellText
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.currentIndexPath = indexPath
        self.performSegueWithIdentifier("memeDetailView", sender: self)
        print("meme Seque Action")
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "memeDetailView"
        {
            if let activityController = segue.destinationViewController as? MemeDetailView
            {
                activityController.memeImage = memes[currentIndexPath.row].memeImage
            }
        }
        
    }
}
