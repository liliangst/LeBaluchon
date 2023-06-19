//
//  TranslationData.swift
//  LeBaluchon
//
//  Created by Lilian Grasset on 16/06/2023.
//

import Foundation

struct TranslationData: Decodable {
    private var data: Data
    
    var text: String {
        data.translations[0].translatedText
    }
}

private struct Data: Decodable {
    var translations: [Translation]
}
private struct Translation: Decodable {
    var translatedText: String
}
