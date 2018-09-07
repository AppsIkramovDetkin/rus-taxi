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
	static let darkOrange: UIColor = UIColor(netHex: 0xF1B950)
	static let lightGray: UIColor = UIColor(netHex: 0xc5c8c3)
	static let lightBlack: UIColor = UIColor(netHex: 0xF5F5F5)
	static let black: UIColor = UIColor.black
	static let darkGray: UIColor = UIColor.darkGray
	static let clear: UIColor = UIColor.clear
	static let white: UIColor = UIColor.white
}

enum TaxiFont {
	static let helveticaMedium: UIFont = UIFont(name: "HelveticaNeue-Medium", size: 14)!
	static let helvetica: UIFont = UIFont(name: "HelveticaNeue", size: 16)!
}

let countries: [String] = [Localize("russia"),
													 Localize("azer"),
													 Localize("arg"),
													 Localize("arm"),
													 Localize("belarus"),
													 Localize("georgia"),
													 Localize("kaz"),
													 Localize("tadzh"),
													 Localize("ukraine"),
													 Localize("uz")]
let numberCodes: [String] = ["+7", "+944", "+54", "+374", "+375", "+995", "+7", "+992", "+380", "+860"]
let flags: [UIImage] = [#imageLiteral(resourceName: "ic_flag_russia"), #imageLiteral(resourceName: "ic_flag_azerbaijan"), #imageLiteral(resourceName: "ic_flag_argentina"), #imageLiteral(resourceName: "ic_flag_armenia"), #imageLiteral(resourceName: "ic_flag_belarus"), #imageLiteral(resourceName: "ic_flag_georgia"), #imageLiteral(resourceName: "ic_flag_kazakhstan"), #imageLiteral(resourceName: "ic_flag_tajikistan"), #imageLiteral(resourceName: "ic_flag_ukraine"), #imageLiteral(resourceName: "ic_flag_uzbekistan")]
