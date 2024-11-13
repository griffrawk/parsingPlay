///
///  aoc2023-03-parse-try.swift
///  parsingPlay
///
///  Created by Andy Griffiths on 15/09/2024.
///

import Parsing

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
    
    let setParser = Parse(input: Substring.self) {
        Many {
            Parse {
                Optionally { Int.parser() }
                Optionally { "." }
                Optionally { "$" }
                Optionally { "*" }
                Optionally { "+" }
                Optionally { "#" }
                Optionally { "\n" }
            }
        }
        End()
    } .map { $0 }
    
    do {
        let parsed = try setParser.parse(aocInput)
        print(parsed)
    } catch {
        print("\(error)")
    }
}


