//
//  Word.swift
//  Vocabulary Trainer
//
//  Created by Marzena Kruszy on 4/24/18.
//  Copyright © 2018 Marzena Kruszy. All rights reserved.
//

import UIKit
import os.log

class Word: NSObject, NSCoding {
    
    //MARK: Enumerations
    enum Article: String {
        case el, la, none
    }
    
    //MARK: Properties
    
    struct PropertyKey {
        
        static let word = "Word"
        static let translation = "Translation"
        static let article = "Article"
        static let rightAnswers = "RightAnswers"
        static let allAnswers = "AllAnswers"
    }
    
    var word = [String]()
    var article = Article.none
    var proficiency: [Int] = [0, 0]

    //MARK: Initialization
    init?(inEnglish: String, translation: [String], article: String) {
        
        if( inEnglish.isEmpty || translation.isEmpty || article.isEmpty ) {
            return nil
        }
        self.word += [inEnglish.lowercased()]
        for string in translation {
            
            self.word += [string.lowercased()]
        }
        self.article = Article.init(rawValue: article) ?? .none
        if( self.article == .none ) {
            return nil
        }
    }
    
    override init() {
        
        self.word += [Article.none.rawValue, Article.none.rawValue]
        self.article = Article.none
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(word[0], forKey: PropertyKey.word)
        aCoder.encode(word[1], forKey: PropertyKey.translation)
        aCoder.encode(article.rawValue, forKey: PropertyKey.article)
        aCoder.encode(proficiency[0], forKey: PropertyKey.rightAnswers)
        aCoder.encode(proficiency[1], forKey: PropertyKey.allAnswers)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let word = aDecoder.decodeObject(forKey: PropertyKey.word) as? String else {
            os_log("Unable to deocde the word for the Word object")
            return nil
        }
        
        guard let translation = aDecoder.decodeObject(forKey: PropertyKey.translation) as? String else {
            os_log("Unable to deocde the translation for the Word object")
            return nil
        }
        
        guard let article = aDecoder.decodeObject(forKey: PropertyKey.article) as? String else {
            os_log("Unable to deocde the article for the Word object")
            return nil
        }
        
        let rightAns = Int(aDecoder.decodeCInt(forKey: PropertyKey.rightAnswers))
        let allAns = Int(aDecoder.decodeCInt(forKey: PropertyKey.allAnswers))
        
        self.init(inEnglish: word, translation: [translation], article: article)
        self.proficiency = [rightAns, allAns]
    }
}
