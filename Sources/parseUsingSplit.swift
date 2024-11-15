//
//  parseUsingSplit.swift
//  parsingPlay
//
//  Created by Andy Griffiths on 14/11/2024.
//

func parseUsingSplit() {
    struct User {
        var id: Int
        var name: String
        var isAdmin: Bool
    }

    print("Parse using .split()\n")
    let input = """
        1,Blob,true
        2,Blob Jr.,false
        3,Blob Sr.,true
        """

    let splitusers =
        input
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

