//
//  Extension.swift
//  CoreDataDemo
//
//  Created by TapashM on 19/05/18.
//  Copyright © 2018 TapashM. All rights reserved.
//

import Foundation

extension Date{
    var currentTimeMillis: Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}
