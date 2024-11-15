//
//  parseUsingParse.swift
//  parsingPlay
//
//  Created by Andy Griffiths on 14/11/2024.
//
import Parsing

func parseUsingParse() {
    struct User {
        var id: Int
        var name: String
        var isAdmin: Bool
    }

    print("\nParse using Parse\n")

    let input = """
        1,Blob,true
        2,Blob Jr.,false
        3,Blob Sr.,true
        """

    //    this will parse a single line and return a User
    //    let usera = Parse(input: Substring.self) {
    //        Int.parser()            // $0
    //        ","
    //        Prefix { $0 != "," }    // $1
    //        ","
    //        Bool.parser()           // $2
    //    }
    //        .map { User(id: $0, name: String($1), isAdmin: $2) }

    //    or
    let userb = Parse(input: Substring.self, User.init(id:name:isAdmin:)) {
        Int.parser()
        ","
        Prefix { $0 != "," }.map(String.init)
        ","
        Bool.parser()
    }

    //    this parser processes many lines, expecting a user parser, as defined above
    //    then a newline as separator
    let users = Many {
        userb
    } separator: {
        "\n"
    }

    //    now actually run the parser on input
    do {
        let parsed = try users.parse(input)
        print(parsed)
    } catch {
        print(error)
    }

}
