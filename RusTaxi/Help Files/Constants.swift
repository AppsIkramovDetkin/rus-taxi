//
//  Constants.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 23.08.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

enum TaxiColor {
	static let gray: UIColor = UIColor(netHex: 0x8794a1)
	static let turquoise: UIColor = UIColor(netHex: 0x06988a)
	static let orange: UIColor = UIColor(netHex: 0xff9640)
}

let countries: [String] = ["Россия", "Азербайджан", "Аргентина", "Армения", "Беларуссия", "Грузия", "Кахахстан", "Таджикистан", "Украина", "Узбекистан"]
let numberCodes: [String] = ["+7", "+944", "+54", "+374", "+375", "+995", "+7", "+992", "+380", "+860"]
let flags: [UIImage] = [#imageLiteral(resourceName: "ic_flag_russia"), #imageLiteral(resourceName: "ic_flag_azerbaijan"), #imageLiteral(resourceName: "ic_flag_argentina"), #imageLiteral(resourceName: "ic_flag_armenia"), #imageLiteral(resourceName: "ic_flag_belarus"), #imageLiteral(resourceName: "ic_flag_georgia"), #imageLiteral(resourceName: "ic_flag_kazakhstan"), #imageLiteral(resourceName: "ic_flag_tajikistan"), #imageLiteral(resourceName: "ic_flag_ukraine"), #imageLiteral(resourceName: "ic_flag_uzbekistan")]
