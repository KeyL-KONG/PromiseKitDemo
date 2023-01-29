//
//  ViewController.swift
//  PromiseDemo
//
//  Created by KeyL on 2023/1/29.
//

import UIKit
import PromiseKit
import CoreLocation
import SnapKit

class ViewController: UIViewController {
    
    var imageView: UIImageView = UIImageView()
    var label: UILabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupViews()
        fetchImage()
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

    func fetchImage() {
        let url = URL(string: "https://lc-AosRamJS.cn-n1.lcfile.com/2a8MKW0O4uvk33n8lL8oRkf7XGbLqMPA/0bcbea56f6794765b571d18b3b3f2fd4")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let fetchImage = URLSession.shared.dataTask(.promise, with: url!).compactMap { UIImage(data: $0.data) }
        let fetchLocation = CLLocationManager.requestLocation().lastValue
        
        firstly {
            when(fulfilled: fetchImage, fetchLocation)
        }.done { image, location in
            self.imageView.image = image
            self.label.text = "\(location)"
        }.ensure {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }.catch { error in
            self.show(UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert), sender: self)
        }
    }

}

