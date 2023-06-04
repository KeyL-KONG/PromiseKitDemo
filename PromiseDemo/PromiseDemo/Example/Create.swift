//
//  Create.swift
//  PromiseDemo
//
//  Created by keyl on 2023/6/4.
//

import Foundation
import PromiseKit

extension ViewController {
    
    func createExample() {
        
        // 1. promise的构造函数
        let promise = Promise<String> { resolver in
            resolver.fulfill("操作成功")
        }
        
        // 2. promise的value方法
        let promise2 = Promise<String>.value("操作成功")
        
        
        // 3. promise的pending方法
        // 应用场景：需要在一个异步操作中创建 Promise，但不能在异步操作开始之前创建 Promise。例如，需要等待用户输入或等待其他异步操作完成后才能创建 Promise。
        let promise3 = Promise<String>.pending()
        
        downloadDataFromServer()
            .done { data in
                print("download data success")
            }.catch { error in
                print("download data failed: \(error)")
            }
    }
    
    func downloadDataFromServer() -> Promise<Data> {
        let (promise, resolver) = Promise<Data>.pending()
        
        URLSession.shared.dataTask(with: URL(string: "https://example.com/data")!) { data, response, error in
            if let error = error {
                resolver.reject(error)
            } else {
                resolver.fulfill(data!)
            }
        }.resume()
        
        return promise
    }
    
}
