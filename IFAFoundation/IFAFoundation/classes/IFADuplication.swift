//
// Created by Marcelo Schroeder on 3/3/17.
// Copyright (c) 2017 InfoAccent Pty Ltd. All rights reserved.
//

import Foundation

@objc public protocol IFADuplication {
    var name: String? { get }
}

@objc public class IFADuplicationUtils: NSObject {
    
    //MARK: Public

    public static func name(forDuplicateOf duplicateSource: IFADuplication, inItems items: Array<IFADuplication>) -> String? {
        guard let duplicateSourceName = duplicateSource.name else {
            return nil
        }
        let firstHalf: String
        let regexMatchStrings = self.regexMatchStrings(forInputString: duplicateSourceName)
        if regexMatchStrings.count >= 1 {
            firstHalf = regexMatchStrings[1]
        } else {
            firstHalf = duplicateSourceName
        }
        let nextCopySequence = highestCopySequence(forDuplicateOf: duplicateSource, inItems: items)! + 1
        let secondHalf = nextCopySequence == 1 ? " Copy" : " Copy \(nextCopySequence)"
        return "\(firstHalf)\(secondHalf)"
    }
    
    //MARK: Private
    
    override private init() {
        
    }
    
    static func highestCopySequence(forDuplicateOf duplicateSource: IFADuplication, inItems items: Array<IFADuplication>) -> Int? {
        guard let duplicateSourceName = duplicateSource.name else {
            return nil
        }
        let duplicateSourceRegexMatchStrings = regexMatchStrings(forInputString: duplicateSourceName)
        let duplicateSourceBaseName: String
        if duplicateSourceRegexMatchStrings.count == 0 {
            duplicateSourceBaseName = duplicateSourceName
        } else {
            duplicateSourceBaseName = duplicateSourceRegexMatchStrings[1]
        }
        var highestCopySequence = 0
        for item in items {
            guard let itemName = item.name else {
                continue
            }
            let itemRegexMatchStrings = regexMatchStrings(forInputString: itemName)
            let itemBaseName: String
            if itemRegexMatchStrings.count == 0 {
                itemBaseName = itemName
            } else {
                itemBaseName = itemRegexMatchStrings[1]
            }
            guard duplicateSourceBaseName == itemBaseName else {
                continue
            }
            guard let significantDuplicationRegexGroup = significantDuplicationRegexGroup(forName: itemName) else {
                continue
            }
            let copySequence: Int
            if significantDuplicationRegexGroup == "Copy" {
                copySequence = 1
            } else {
                copySequence = Int(significantDuplicationRegexGroup)!
            }
            if copySequence > highestCopySequence {
                highestCopySequence = copySequence
            }
        }
        return highestCopySequence
    }
    
    static func significantDuplicationRegexGroup(forItem item: IFADuplication) -> String? {
        return significantDuplicationRegexGroup(forName: item.name)
    }

    static func significantDuplicationRegexGroup(forName name: String?) -> String? {
        
        guard let name = name else {
            return nil
        }

        var significantRegexGroup: String?
        for matchString in regexMatchStrings(forInputString: name) {
            significantRegexGroup = matchString
        }
        
        return significantRegexGroup
        
    }

    static func regexMatchStrings(forInputString inputString: String) -> [String] {

        print("regexMatchStrings forInputString: \(inputString)")

        let pattern = "^(.*)( (Copy( (\\d+))?))$"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matches(in: inputString, options: [], range: NSRange(location: 0, length: inputString.characters.count))

        var matchStrings: [String] = []
        for match in matches {
            for i in 0..<match.numberOfRanges {
                let range = match.rangeAt(i)
                guard range.length > 0 else {
                    continue
                }
                print("  range.location: \(range.location), length: \(range.length)")
                let r = inputString.index(inputString.startIndex, offsetBy: range.location)..<inputString.index(inputString.startIndex, offsetBy: range.location+range.length)
                let s = inputString.substring(with: r)
                print("    s: \(s)")
                matchStrings.append(s)
            }
        }

        return matchStrings

    }

}
