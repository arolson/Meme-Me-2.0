//
//  MemeDetailView.swift
//  MemeMe 2.0
//
//  Created by Andrew Olson on 7/24/16.
//  Copyright © 2016 Andrew Olson. All rights reserved.
//

import UIKit

class MemeDetailView: UIViewController
{
    @IBOutlet weak var imageView: UIImageView!
    var memeImage: UIImage!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool)
    {
        if let image = memeImage
        {
            imageView.image = image
        }
    }
    
}
