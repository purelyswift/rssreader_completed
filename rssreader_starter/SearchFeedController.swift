//
//  ViewController.swift
//  rssreader_starter
//
//  Created by Brian Voong on 2/13/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class SearchFeedController: UICollectionViewController {

    var entries: [Entry]? = [
        Entry(title: "Sample Title 1", contentSnippet: "Sample Content Snippet 1", url: nil),
        Entry(title: "Sample Title 2", contentSnippet: "Sample Content Snippet 2", url: nil),
        Entry(title: "Sample Title 3", contentSnippet: "Sample Content Snippet 3", url: nil)
    ]
    
    let entryCellId = "entryCellId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "RSS Reader"
        
        collectionView?.registerClass(EntryCell.self, forCellWithReuseIdentifier: entryCellId)
        collectionView?.registerClass(SearchHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.alwaysBounceVertical = true
        
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.headerReferenceSize = CGSizeMake(view.frame.width, 50)
        }
    }
    
    func performSearchForText(text: String) {
        print("Performing search for \(text), please wait...")
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = entries?.count {
            return count
        }
        return 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let entryCell = collectionView.dequeueReusableCellWithReuseIdentifier(entryCellId, forIndexPath: indexPath) as! EntryCell
        let entry = entries?[indexPath.item]
        entryCell.titleLabel.text = entry?.title
        entryCell.contentSnippetTextView.text = entry?.contentSnippet
        return entryCell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerId, forIndexPath: indexPath) as! SearchHeader
        header.searchFeedController = self
        return header
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.width, 80)
    }
    
}

struct Entry {
    var title: String?
    var contentSnippet: String?
    var url: String?
}
