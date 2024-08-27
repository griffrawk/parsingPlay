// The Swift Programming Language
// https://docs.swift.org/swift-book

import Parsing

let input = """
  1,Blob,true
  2,Blob Jr.,false
  3,Blob Sr.,true
  """

struct User {
  var id: Int
  var name: String
  var isAdmin: Bool
}

print("Parse using .split()\n")

let splitusers = input
  .split(separator: "\n")
  .compactMap { row -> User? in
    let fields = row.split(separator: ",")
    guard
      fields.count == 3,
      let id = Int(fields[0]),
      let isAdmin = Bool(String(fields[2]))
    else { return nil }

    return User(id: id, name: String(fields[1]), isAdmin: isAdmin)
  }

print(splitusers)

print("\nParse using Parse\n")

// this part of the example doesnt work due to changes in Swift 5.8,
// see https://github.com/pointfreeco/swift-parsing/discussions/290
//let user = Parse {
//    Int.parser()
//    ","
//}

// this will parse a single line and return a User
// needs the input: see the github issue above
let user = Parse(input: Substring.self) {
    Int.parser()            // $0
    ","
    Prefix { $0 != "," }    // $1
    ","
    Bool.parser()           // $2
}
.map { User(id: $0, name: String($1), isAdmin: $2) }

// this parser processes many lines, expecting a user parser, as defined above
// then a newline as separator
let users = Many {
    user
} separator: {
    "\n"
}

// now actually run the parser on input
let parsed = try users.parse(input)

print(parsed)
