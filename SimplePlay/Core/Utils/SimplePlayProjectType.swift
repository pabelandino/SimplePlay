//
//  SimplePlayProjectType.swift
//  SimplePlay
//

import UniformTypeIdentifiers

extension UTType {
    static let simplePlayProject = UTType(exportedAs: "com.pabel.simpleplay.project", conformingTo: .data)
}

enum SimplePlayProjectType {
    static let fileExtension = "simpleplay"
}
