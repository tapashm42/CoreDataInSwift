//
//  HelperClass.swift
//  CoreDataDemo
//
//  Created by TapashM on 19/05/18.
//  Copyright © 2018 TapashM. All rights reserved.
//

import Foundation

final class HelperClass {
   static func arrayFromJsonFie(name:String) -> Array<Dictionary<String,Any>>? {
    
    if let path = Bundle.main.path(forResource: "Employee", ofType: "json") {
    do {
    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
    do{
    
    let json =  try JSONSerialization.jsonObject(with: data, options: .allowFragments)
    // JSONObjectWithData returns AnyObject so the first thing to do is to downcast to dictionary type
    print(json)
    let jsonDictionary =  json as! Dictionary<String,Any>
    //print all the key/value from the json
  
    //e.g to get person
    let employeeArr = jsonDictionary["employee"] as! Array<Dictionary<String,Any>>
        return employeeArr
    }catch let error{
    
    print(error.localizedDescription)
    }
    
    } catch let error {
    print(error.localizedDescription)
    }
    } else {
    print("Invalid filename/path.")
    }
    return nil
    }
}
