//
//  InfoViewController.swift
//  MyHabits
//
//  Created by Sokolov on 02.07.2023.
//

import UIKit

final class InfoViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = view.bounds
        scrollView.backgroundColor = .white
        scrollView.frame = view.bounds
        scrollView.contentSize = contentSize
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.frame.size = contentSize
        return contentView
    }()
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    private lazy var titleText: UILabel = {
        let titleText = UILabel()
        titleText.translatesAutoresizingMaskIntoConstraints = false
        titleText.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleText.text = InfoText.titleText
        return titleText
    }()
    
    private lazy var text: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        text.textColor = .black
        text.numberOfLines = 0
        text.text = InfoText.information
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = InfoText.navigationTitle
        navigationController?.navigationBar.barTintColor = .white
        
        setupView()
    }
    
    private func setupView() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleText)
        contentView.addSubview(text)
        
        NSLayoutConstraint.activate([
            
            titleText.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            titleText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            
            text.topAnchor.constraint(equalTo: titleText.bottomAnchor,constant: 15),
            text.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            text.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            
        ])
    }
    
}
