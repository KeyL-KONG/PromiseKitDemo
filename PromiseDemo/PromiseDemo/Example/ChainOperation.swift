//
//  ChainOperation.swift
//  PromiseDemo
//
//  Created by keyl on 2023/6/4.
//

import Foundation
import PromiseKit

extension ViewController {
    
    func chainOperationExample() {
        firstly {
            downloadFromServer()
        }.then { data in
            self.processData(with: data)
        }.done { result in
            print("result: \(result)")
        }.catch { error in
            print("error: \(error)")
        }
    }
    
}

private extension ViewController {
    
    func downloadFromServer() -> Promise<Data> {
        return Promise { resolver in
            URLSession.shared.dataTask(with: URL(string: "https://www.example.com")!) { data, response, error in
                if let error = error {
                    resolver.reject(error)
                } else {
                    resolver.fulfill(data!)
                }
            }.resume()
        }
    }
    
    func processData(with data: Data) -> Promise<String> {
        return Promise { resolver in
            let result = String(data: data, encoding: .utf8)
            resolver.fulfill(result!)
        }
    }
    
}
