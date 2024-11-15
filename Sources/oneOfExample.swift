//
//  oneOfExample.swift
//  parsingPlay
//
//  Created by Andy Griffiths on 14/11/2024.
//

import Parsing

func oneOfExample() {
    enum Currency {
        case eur(Int)
        case gbp(Int)
        case usd(Int)
        case unknown
    }

    let currency = OneOf {
        "€".map { Currency.eur(33) }
        "£".map { Currency.gbp(6) }
        "$".map { Currency.usd(2) }
    }
    //    .replaceError(with: Currency.unknown)

    //    print(currency.parse("$"))   // Currency.usd
    //    print(currency.parse("฿"))   // Currency.unknown (but crashes)

    var parsed = Currency.unknown
    do {
        parsed = try currency.parse("$")
    } catch {
        print("\(error)")
    }
    print(parsed)
}
