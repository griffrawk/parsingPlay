///
///  aoc2023-03-parse-try.swift
///  parsingPlay
///
///  Created by Andy Griffiths on 15/09/2024.
///

import Parsing

enum Value {
    case Number(Int)
    case Mult
    case Empty
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

    let choice = OneOf {
        "*".map { Value.Mult }
        Int.parser().map { Value.Number($0) }
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

