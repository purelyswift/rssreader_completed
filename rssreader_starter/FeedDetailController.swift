//
//  FeedDetailController.swift
//  rssreader_starter
//
//  Created by Brian Voong on 2/13/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FeedDetailController: UICollectionViewController {

    var entryUrl: String? {
        didSet {
            fetchFeed()
        }
    }
    
    var entries: [Entry]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.whiteColor()
        
        //        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
        //            layout.estimatedItemSize = CGSizeMake(view.frame.width, 100)
        //        }
        
        self.collectionView!.registerClass(EntryCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func fetchFeed() {
        let url = NSURL(string: "https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=\(entryUrl!)")
        print(url)
        NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) -> Void in
            
            if error != nil {
                print(error)
                return
            }
            
            do {
                
                let json = try(NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()))
                
                let responseData = json["responseData"] as? NSDictionary
                
                if let feedEntries = responseData?["feed"]?["entries"] as? [NSDictionary] {
                    self.entries = [Entry]()
                    for entryDictionary in feedEntries {
                        let title = entryDictionary["title"] as? String
                        let contentSnippet = entryDictionary["content"] as? String
                        let entry = Entry(title: title, contentSnippet: contentSnippet, url: nil)
                        self.entries?.append(entry)
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.collectionView?.reloadData()
                })
                
                
            } catch let error {
                print(error)
            }
            
            }.resume()
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = entries?.count {
            return count
        }
        return 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let entryCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! EntryCell
        if let entry = entries?[indexPath.item], title = entry.title, contentSnippet = entry.contentSnippet {
            
            let options = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
            
            do {
                entryCell.titleLabel.text = title
                entryCell.contentSnippetTextView.attributedText = try(NSAttributedString(data: contentSnippet.dataUsingEncoding(NSUnicodeStringEncoding)!, options: options, documentAttributes: nil))
                entryCell.contentSnippetTextView.scrollEnabled = true
                
            } catch let error {
                print("error creating attributed string", error)
            }
        }
        
        
        return entryCell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if let entry = entries?[indexPath.item], contentSnippet = entry.contentSnippet {
            do {
                let text = try(NSAttributedString(data: contentSnippet.dataUsingEncoding(NSUnicodeStringEncoding)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil))
                let size = text.boundingRectWithSize(CGSizeMake(view.frame.width - 26, 2000), options: NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin), context: nil).size
                return CGSizeMake(view.frame.width, size.height + 16)
            } catch let error {
                print(error)
            }
        }
        
        return CGSizeMake(view.frame.width, 100)
    }


}
