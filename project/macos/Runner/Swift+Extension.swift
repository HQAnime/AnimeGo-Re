//
//  Swift+Extension.swift
//  Runner
//
//  Created by Yiheng Quan on 2/10/2022.
//

import Foundation

func print(_ message: Any, file: StaticString = #fileID, line: Int = #line) {
    #if DEBUG
        Swift.print("\(file), line \(line) - \(message)")
    #endif
}

func debugPrint(_ message: Any, file: StaticString = #fileID, line: Int = #line) {
    #if DEBUG
        Swift.print("\(file), line \(line)", terminator: " - ")
        Swift.debugPrint(message)
    #endif
}
