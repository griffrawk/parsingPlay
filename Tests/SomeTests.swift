//
//  File.swift
//  
//
//  Created by Andy Griffiths on 10/09/2024.
//

import Foundation
import XCTest
import Parsing
@testable import parsingPlay

class SomeTests: XCTestCase {
    var somedata: Int = 0
    
    func testRunHello() {
        print(testWithRange())
    }
        
    func testParseUsingSplit() {
        parseUsingSplit()
    }
    
    func testParseUsingParse() {
        parseUsingParse()
    }
    
    func testAocParse() {
        aocParse()
    }
    
    override func setUp() {
        somedata = 999
//        print("doing not much except setting up a var")
    }
}



