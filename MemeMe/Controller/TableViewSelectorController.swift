//
//  SelectorViewController.swift
//  MemeMe
//
//  Created by Katharina Müllek on 21.11.20.
//

import Foundation
import UIKit

class TableViewSelectorController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(appDelegate.memes.count)
        return appDelegate.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.tableViewCell) as! TableViewCell
        let meme = appDelegate.memes[(indexPath as IndexPath).row]
        
        cell.tableViewText.text = "\(meme.topText)...\(meme.bottomText)"
        cell.tableViewImage.image = meme.memedImage
        
        return cell
    }
    
    // insert function to open the selected image in the EditorViewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //perform a segue when an item is selected!
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editorViewController = storyboard.instantiateViewController(identifier: K.identifier.editorViewController) as! EditorViewController
        
        editorViewController.passedMeme = appDelegate.memes[(indexPath as NSIndexPath).row]
        present(editorViewController, animated: true, completion: nil)
    }
}
