//
//  TransformOperation.swift
//  PromiseDemo
//
//  Created by ByteDance on 2023/6/4.
//

import Foundation
import PromiseKit

extension ViewController {
    
    func transformOperation() {
        let promise = Promise.value([1, 2, 3, 4, 5])
        promise.map { numbers -> [Int] in
            return numbers.map { $0 * 2 }
        }.filterValues { number in
            return number % 2 == 0
        }.done { result in
            print(result)
        }.catch { error in
            print("error: \(error)")
        }
    }
    
}
