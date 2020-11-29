//
//  CollectionViewSelectorController.swift
//  MemeMe
//
//  Created by Katharina Müllek on 21.11.20.
//

import Foundation
import UIKit

class CollectionViewSelectorController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            adaptCellDimension(.portrait)
        } else {
            adaptCellDimension(.landscapeRight)
        }
    }
    
    func adaptCellDimension(_ orientation:UIDeviceOrientation) {
        let space: CGFloat = 3.0
        let dimension: CGFloat

        if(orientation.isLandscape) {
            dimension = (view.frame.size.height - (2 * space)) / 3.0
        } else {
            dimension = (view.frame.size.width - (2 * space)) / 3.0
        }
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.identifier.collectionCell, for: indexPath) as! CollectionViewCell
        cell.collectionViewImage?.image = appDelegate.memes[indexPath.row].memedImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // perform segue to editor
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editorViewController = storyboard.instantiateViewController(identifier: K.identifier.editorViewController) as! EditorViewController
        
        editorViewController.passedMeme = appDelegate.memes[(indexPath as NSIndexPath).row]
        present(editorViewController, animated: true, completion: nil)
    }
    
}
