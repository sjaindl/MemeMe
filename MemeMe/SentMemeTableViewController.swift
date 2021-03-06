//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Stefan Jaindl on 08.04.18.
//  Copyright © 2018 Stefan Jaindl. All rights reserved.
//

import UIKit

final class SentMemeTableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let meme = appDelegate.memes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: MemeIds.MEME_TABLE_CELL_ID) as! SentMemeTableViewCell
        
        cell.memeImageView.image = meme.memeImage
        cell.topTextLabel.text = meme.topText
        cell.bottomTextLabel.text = meme.bottomText
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: MemeIds.MEME_DETAIL_SEGUE_ID, sender: indexPath.row)
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.hidesBottomBarWhenPushed = true
        
        if segue.identifier == MemeIds.MEME_DETAIL_SEGUE_ID {
            let controller = segue.destination as! MemeDetailViewController
            controller.memeIndex = sender as? Int
        }
    }
}
