//
//  Dictionary.swift
//  Vocabulary Trainer
//
//  Created by Marzena Kruszy on 4/27/18.
//  Copyright © 2018 Marzena Kruszy. All rights reserved.
//

import UIKit
import os.log

class Dictionary: NSObject {
    
    //MARK: Properties: public

    static var singleton: Dictionary = Dictionary()
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("vocabulary")
    
    //MARK: Properties: private
    private var dictionary = [Word]()
    
    //MARK: Initialization
    
    override init() {
        
        super.init()
        
        if let savedWords = LoadDictionary() {
            dictionary += savedWords
        }
        else {
            LoadSampleWords()
        }
    }
    
    //MARK: Data access
    
    func GetSize() -> Int {
        
        return dictionary.count
    }
    
    func GetWord(at row: Int) -> Word {
        
        if row < dictionary.count {
            return dictionary[row]
        }
        return Word()
    }
    
    func RemoveWord(at row: Int) {
        
        if( row < dictionary.count ) {
            dictionary.remove(at: row)
            SaveDictionary()
        }
    }
    
    func InsertWord(newWord word: Word) -> Int {
        
        //Find the alphabetically correct index for the new word
        var index: Int = dictionary.count
        for i in 0 ..< dictionary.count {
            
            let comparisonResult = word.word[0].caseInsensitiveCompare( dictionary[i].word[0] )
            if( comparisonResult == .orderedAscending ) {
                index = i
                break
            }
            else if comparisonResult == .orderedSame {
                return -1
            }
        }
        dictionary.insert(word, at: index)
        SaveDictionary()
        
        return index
    }
    
    func MoveWord(fromIndex from: Int) -> Int {
        
        var newIndex = 0
        if( from < dictionary.count ) {
            let word = dictionary.remove(at: from)
            newIndex = InsertWord(newWord: word)
            SaveDictionary()
        }
        
        return newIndex
    }
    
    func ReplaceWord(at row: Int, with word: Word) {
        if( row < dictionary.count ) {
            let range: Range = row..<(row+1)
            dictionary.replaceSubrange(range, with: [word])
            SaveDictionary()
        }
    }
    
    //MARK: Private methods
    
    private func LoadDictionary() -> [Word]? {
        
        return NSKeyedUnarchiver.unarchiveObject(withFile: Dictionary.ArchiveURL.path) as? [Word]
    }
    
    private func SaveDictionary() {
        
        let successfullSave = NSKeyedArchiver.archiveRootObject(dictionary, toFile: Dictionary.ArchiveURL.path)
        if successfullSave {
            os_log("Dictionary saved to archive", log: OSLog.default, type: .debug)
        }
        else {
            os_log("Saving dictionary was unsuccessfull", log: OSLog.default, type: .error)
        }
    }
    
    private func LoadSampleWords() {
        
        guard let word1 = Word(inEnglish: "Dog", translation: ["Perro"], article: Word.Article.el.rawValue) else {
            fatalError("Unable to instantiate word1")
        }
        guard let word2 = Word(inEnglish: "Spoon", translation: ["Cuchiara"], article: Word.Article.la.rawValue) else {
            fatalError("Unable to instantiate word2")
        }
        guard let word3 = Word(inEnglish: "Floor", translation: ["Piso"], article: Word.Article.el.rawValue) else {
            fatalError("Unable to instantiate word3")
        }
        
        dictionary += [word1, word2, word3]
        dictionary.sort(by: { $0.word[0] < $1.word[0] } )
    }
}
