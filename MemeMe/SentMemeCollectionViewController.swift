//
//  SentMemeCollectionViewController.swift
//  MemeMe
//
//  Created by Stefan Jaindl on 08.04.18.
//  Copyright © 2018 Stefan Jaindl. All rights reserved.
//

import UIKit

private let reuseIdentifier = MemeIds.MEME_COLLECTION_VIEW_CELL_ID

final class SentMemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SentMemeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SentMemeCollectionViewCell
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Configure the cell
        cell.memeImage.image = appDelegate.memes[indexPath.row].memeImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: MemeIds.MEME_DETAIL_SEGUE_ID, sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.hidesBottomBarWhenPushed = true
        
        if segue.identifier == MemeIds.MEME_DETAIL_SEGUE_ID {
            let controller = segue.destination as! MemeDetailViewController
            controller.memeIndex = sender as? Int
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupFlowLayout()
    }
    
    func setupFlowLayout() {
        let width = view.frame.size.width
        let height = view.frame.size.height
        let min = width > height ? height : width
        let max = width > height ? width : height
        
        let space:CGFloat = 3
        let isPortraitMode = UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown
        let dimension = isPortraitMode ? (min - (2 * space)) / 2 : (max - (2 * space)) / 3
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
}
