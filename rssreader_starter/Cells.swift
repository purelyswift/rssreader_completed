//
//  EntryCell.swift
//  rssfeed
//
//  Created by Brian Voong on 2/13/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class EntryCell: BaseCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFontOfSize(14)
        return label
    }()
    
    let contentSnippetTextView: UITextView = {
        let textView = UITextView()
        textView.scrollEnabled = false
        textView.userInteractionEnabled = false
        return textView
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    override func setupViews() {
        addSubview(titleLabel)
        addSubview(contentSnippetTextView)
        addSubview(dividerView)
        
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: titleLabel)
        addConstraintsWithFormat("H:|-3-[v0]-3-|", views: contentSnippetTextView)
        addConstraintsWithFormat("H:|-8-[v0]|", views: dividerView)
        
        addConstraintsWithFormat("V:|-8-[v0(20)]-8-[v1][v2(0.5)]|", views: titleLabel, contentSnippetTextView, dividerView)
    }
    
    override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr: UICollectionViewLayoutAttributes = layoutAttributes.copy() as! UICollectionViewLayoutAttributes
        
        var newFrame = attr.frame
        self.frame = newFrame
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        let desiredHeight: CGFloat = systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        newFrame.size.height = desiredHeight + 20
        attr.frame = newFrame
        return attr
    }
}

class SearchHeader: BaseCell, UITextFieldDelegate {
    
    var searchFeedController: SearchFeedController?
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search for RSS Feeds"
        textField.font = UIFont.systemFontOfSize(14)
        return textField
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .System)
        button.setTitle("Search", forState: .Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
        return button
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        searchButton.addTarget(self, action: "search", forControlEvents: .TouchUpInside)
        searchTextField.delegate = self
        
        addSubview(searchTextField)
        addSubview(dividerView)
        addSubview(searchButton)
        
        addConstraintsWithFormat("H:|-8-[v0][v1(80)]|", views: searchTextField, searchButton)
        addConstraintsWithFormat("H:|[v0]|", views: dividerView)
        
        addConstraintsWithFormat("V:|[v0]|", views: searchButton)
        addConstraintsWithFormat("V:|[v0][v1(0.5)]|", views: searchTextField, dividerView)
    }
    
    func search() {
        searchFeedController?.performSearchForText(searchTextField.text!)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        searchFeedController?.performSearchForText(searchTextField.text!)
        return true
    }
    
}

class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerate() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
