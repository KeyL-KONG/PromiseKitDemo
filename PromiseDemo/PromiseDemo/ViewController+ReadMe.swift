//
//  ViewController+Readme.swift
//  PromiseDemo
//
//  Created by KeyL on 2023/1/30.
//  https://github.com/mxcl/PromiseKit

import Foundation
import PromiseKit
import CoreLocation

extension ViewController {
    
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
