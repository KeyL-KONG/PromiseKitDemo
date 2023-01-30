//
//  ViewController.swift
//  PromiseDemo
//
//  Created by KeyL on 2023/1/29.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var imageView: UIImageView = UIImageView()
    var label: UILabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupViews()
        fetchImage()
        updateImage2()
    }
    
    func setupViews() {
        imageView.contentMode = .scaleAspectFit
        label.textAlignment = .center
        label.numberOfLines = 0
        
        self.view.addSubview(imageView)
        self.view.addSubview(label)
        
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(200)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(self.imageView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
}

