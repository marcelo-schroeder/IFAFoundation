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

    public static func name(forDuplicateOf duplicateSource: IFADuplication, existingItems: Array<IFADuplication>) -> String? {
        guard let duplicateSourceName = duplicateSource.name else {
            return nil
        }
        let nextCopySequence = highestCopySequence(inItems: existingItems) + 1
        return "\(duplicateSourceName) Copy \(nextCopySequence)"
    }
    
    //MARK: Private
    
    override private init() {
        
    }
    
    static func highestCopySequence(inItems items: Array<IFADuplication>) -> Int {
        var highestCopySequence = 0
        for item in items {
            guard let significantDuplicationRegexGroup = significantDuplicationRegexGroup(forName: item.name) else {
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
        
        print("significantDuplicationRegexGroup forName: \(name)")
        
        guard let name = name else {
            return nil
        }
        
        let pattern = "^.* (Copy( (\\d+))?)$"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matches(in: name, options: [], range: NSRange(location: 0, length: name.characters.count))
        
        var significantRegexGroup: String?
        for match in matches {
            for i in 0..<match.numberOfRanges {
                let range = match.rangeAt(i)
                guard range.length > 0 else {
                    continue
                }
                print("  range.location: \(range.location), length: \(range.length)")
                let r = name.index(name.startIndex, offsetBy: range.location)..<name.index(name.startIndex, offsetBy: range.location+range.length)
                let s = name.substring(with: r)
                print("    s: \(s)")
                significantRegexGroup = s
            }
        }
        
        return significantRegexGroup
        
    }

}
