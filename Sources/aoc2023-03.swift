///
///  aoc2023-03-parse-try.swift
///  parsingPlay
///
///  Created by Andy Griffiths on 15/09/2024.
///

import Parsing

enum Value {
    // a multi-digit number
    case Number(String, xRange: Range<Int>, y: Int)
    // anything not a number and not ("\n" or ".")
    case Symbol(String, xRange: Range<Int>, y: Int)
    // "\n" or "."
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
    
    var parsed: [Value] = []
    
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
    
    // Calculate an x position relative to beginning of input or
    // the next char following \n (eg the next 'line')
    let x = { (range: Range<String.Index>) -> Int in
        aocInput.distance(
            from: aocInput.startIndex, to: range.lowerBound)
        - linecount * nlat
    }
    
    let parser = Parse(input: Substring.self) {
        Many {
            OneOf {
                // Count 'lines'. Inc everytime we see "\n"
                "\n".withRange().map { _, range in
                    linecount += 1
                    return Value.Empty
                }
                // The symbols
                Prefix(1) { !".0123456789".contains(String($0)) }
                    .withRange().map { symbol, range in
                        let xRange = x(range)..<x(range) + 1
                        return Value.Symbol(String(symbol), xRange: xRange, y: linecount)
                    }
                // The potential part numbers
                Int.parser().withRange().map { number, range in
                    let partNumber = String(number)
                    let xRange = x(range)..<(partNumber.count + x(range))
                    return Value.Number(partNumber, xRange: xRange, y: linecount)
                }
                // The default, just "." left
                First().map { _ in Value.Empty }
            }
        }
    }
    
    do {
        parsed = try parser.parse(aocInput)
    } catch {
        print("\(error)")
    }
    
    part2(parsed)
}

func part2(_ parsed: [Value]) {
    
    // A possible for part 2 (two part numbers adjacent to "*"):
    // eg if by some other not-yet-written we've found "*" on line 4
    // we could use the following to find .Number on lines 3...5 (inclusive)
    // then we can range match to see if adjacent in x-axis
    let symbols = parsed.filter {
        switch $0 {
        case .Number(_, _, 3...5) :
            return true
        default:
            return false
        }
    }
    for symb in symbols {
        print(symb)
    }
    
}
