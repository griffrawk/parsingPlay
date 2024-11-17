import Parsing

func withRangeExample() -> Int {
    // An extension that returns a range, I suppose that indices the length
    // of the requested parse. However, a few issues with it to sort out..
    // Some notes from https://github.com/pointfreeco/swift-parsing/discussions/290
    // go some way to sorting out the parser specification

    let parser = Parse {
        "Moo ".utf8
        Int.parser(of: Substring.self.UTF8View).withRange()
        " He".utf8
        Rest()
    }
    
    // [...] makes it a String.SubSequence
    let input = "Moo 123456789 Hello "[...]
    
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

