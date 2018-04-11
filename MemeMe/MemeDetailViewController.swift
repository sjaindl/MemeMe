//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Stefan Jaindl on 11.04.18.
//  Copyright © 2018 Stefan Jaindl. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var memeIndex: Int?
    @IBOutlet weak var detailImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let memeIndex = memeIndex {
            detailImage.image = appDelegate.memes[memeIndex].memeImage
        }
    }

}
