import Parsing

// extend Parser to provide a range for the returned value, sort of where it is
// in the input
extension Parser where Input: Collection {
    func withRange() -> AnyParser<
        Input, (output: Output, range: Range<Input.Index>)
    > {
        .init { input in
            let startIndex = input.startIndex
            do {
                // in this particular implementation of parse (one of a few),
                // input is an inout to the parse function, so prefixed
                // by & (a bit like a reference in Rust, but is it? Apparently yes)
                let output = try self.parse(&input)
                let endIndex = input.startIndex
                return (output, startIndex..<endIndex)
            }
        }
    }
}

func withRangeExample() -> Int {
    // An extension that returns a range, I suppose that indices the length
    // of the requested parse. However, a few issues with it to sort out..
    // Some notes from https://github.com/pointfreeco/swift-parsing/discussions/290
    // go some way to sorting out the parser specification

    let parser = Parse {
        Int.parser(of: Substring.self.UTF8View).withRange()
        " He".utf8
        Rest()
    }
    
    // [...] makes it a String.SubSequence
    let input = "123456789 Hello "[...]
    
    // inner tuple is from Int.parser().withRange
    // outer tuple is inner tuple and Rest()
    do {
        let ((output, range), bollox) = try parser.parse(input)

        print(output)
        print(input.distance(from: range.lowerBound, to: range.upperBound))
        print(String(bollox) ?? "")
        return output
    } catch {
        print(error)
        return 0
    }
}

