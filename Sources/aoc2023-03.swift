///
///  aoc2023-03-parse-try.swift
///  parsingPlay
///
///  Created by Andy Griffiths on 15/09/2024.
///

import Parsing

enum Value {
    case Number(number: String, xRange: Range<Int>, y: Int)
    case Symbol(xRange: Range<Int>, y: Int)
    case Empty
}

extension Parser where Input: Collection {
    /**
    Returns the half-open range of the parsed output with the output
     
    [](https://github.com/pointfreeco/swift-parsing/discussions/69)
    ```swift
    let parser = Int.parser().withRange()
    let input = "123 Hello"[...].utf8
    let (output, range) = parser.parse(&input)!
    XCTAssertEqual(123, output)
    XCTAssertEqual(3, input.distance(from: range.lowerBound, to: range.upperBound))
    ```
    */
    func withRange() -> AnyParser<
        Input, (output: Output, range: Range<Input.Index>)
    > {
        .init { input in
            let startIndex = input.startIndex
            do {
                let output = try self.parse(&input)
                // startIndex has moved on to be the start of the next
                // bit of data, but is also endIndex of the last
                let endIndex = input.startIndex
                return (output, startIndex..<endIndex)
            }
        }
    }
}

func aocParse() {
    print("\nParse AoC input\n")

    let aocInput = """
        467..114..
        ...*......
        ..35..633.
        ......#...
        617*......
        .....+.58.
        ..592.....
        ......755.
        ...$.*....
        .664.598..
        """

    var linecount = 0
    var nlat = 0
    
    if let i = aocInput.firstIndex(of: "\n") {
        nlat = aocInput.distance(from: aocInput.startIndex, to: i) + 1
    }
 
    let choice = OneOf {
        "\n".withRange().map { _, range in
            // inc everytime \n
            linecount += 1
            return Value.Empty
        }
        "*".withRange().map { _, range in
            // Calculate an x offset relative to beginning of input or
            // the next char following \n (eg the next 'line')
            let x = aocInput.distance(from: aocInput.startIndex, to: range.lowerBound) - linecount * nlat
            return Value.Symbol(xRange: x..<x+1, y: linecount)
        }
        Int.parser().withRange().map { number, range in
            let number = String(number)
            let x = aocInput.distance(from: aocInput.startIndex, to: range.lowerBound) - linecount * nlat
            let xRange = x..<(number.count + x)
            return Value.Number(number: number, xRange: xRange, y: linecount)
        }
        First().map { _ in Value.Empty }
    }

    let setParser = Parse(input: Substring.self) {
        Many {
            choice
        }
    }

    do {
        let parsed = try setParser.parse(aocInput)
        print(parsed)
    } catch {
        print("\(error)")
    }

}
