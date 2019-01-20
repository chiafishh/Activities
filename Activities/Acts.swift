//
//  Acts.swift
//  Activities
//
//  Created by User23 on 2019/1/11.
//  Copyright © 2019 Chiafishh. All rights reserved.
//

import Foundation

struct ShowInfo0: Codable {
    var time: String?
    var location: String?
    var locationName: String?
    var price: String?
}

struct Act1: Codable {
    var UID: String
    var title: String
    var descriptionFilterHtml: String
    var imageUrl: URL
    var webSales: String?
    var sourceWebPromote: String?
    var showInfo: [ShowInfo0]?
}

struct Act0: Codable{
    var note: String
    var issue: [Act1]
    var title: String
}

