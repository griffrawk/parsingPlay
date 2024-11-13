import Parsing

struct User {
  var id: Int
  var name: String
  var isAdmin: Bool
}

func parseUsingSplit() {
    print("Parse using .split()\n")
    let input = """
      1,Blob,true
      2,Blob Jr.,false
      3,Blob Sr.,true
      """

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
}

func parseUsingParse() {
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

// extend Parser to provide a range for the returned value, sort of where it is
// in the input
extension Parser where Input: Collection {
    func withRange() -> AnyParser<Input, (output: Output, range: Range<Input.Index>)> {
        .init { input in
            let startIndex = input.startIndex
            do {
                // in this particular implementation of parse (one of a few),
                // input is an inout to the parse function, so prefixed
                // by & (a bit like a reference in Rust, but is it? Apparently yes)
                let output = try self.parse(&input)
                let endIndex = input.startIndex
                return (output, startIndex ..< endIndex)
            }
        }
    }
}

func testWithRange() -> Int {
    // An extension that returns a range, I suppose that indices the length
    // of the requested parse. However, a few issues with it to sort out..
    // Some notes from https://github.com/pointfreeco/swift-parsing/discussions/290
    // go some way to sorting out the parser specification
    
    let parser = Parse {
        Int.parser(of: Substring.self.UTF8View).withRange()
        " He".utf8
        Rest()
    }
    let input = "123456789 Hello "[...]
    // inner tuple is from Int.parser().withRange
    // outer tuple is inner tuple and Rest()
    do {
        let ((output, range), bollox) = try parser.parse(input)
        
        print(output)
        print(input.distance(from: range.lowerBound, to: range.upperBound))
        print(String(bollox) ?? "")
        return output
    }
    catch {
        print(error)
        return 0
    }
}
