//
//  SettingsController.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 28.10.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

enum ChooseSoundOption {
	case vibro
	case withSound
}

class SettingsController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	
	private var choosenOption = ChooseSoundOption.vibro
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		delegating()
		registerNibs()
		tableView.separatorColor = TaxiColor.darkGray
		self.title = "settings".localized
//			Localize("settings")
		tableView.isScrollEnabled = false
		navigationController?.navigationBar.barTintColor = TaxiColor.orange
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		NavigationBarDecorator.decorate(self)
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	private func delegating() {
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	private func registerNibs() {
		tableView.register(UINib(nibName: "SettingsItemCell", bundle: nil), forCellReuseIdentifier: "settingsCell")
	}
}

extension SettingsController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = UITableViewCell()
			cell.backgroundColor = TaxiColor.white
			return cell
		} else if indexPath.row == 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsItemCell
			cell.label.text = "alertOrder".localized
//				Localize("alertOrder")
			cell.checkBoxButton.isHidden = true
			return cell
		} else if indexPath.row == 2 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsItemCell
			if choosenOption == .vibro {
				cell.checkBoxButton.isHidden = false
			} else {
				cell.checkBoxButton.isHidden = true
			}
			cell.label.text = "vibro".localized
//				Localize("vibro")
			cell.label.textColor = TaxiColor.black
			cell.separatorInset = .init(top: 0, left: 50, bottom: 0, right: 20)
			return cell
		} else if indexPath.row == 3 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsItemCell
			if choosenOption == .withSound {
				cell.checkBoxButton.isHidden = false
			} else {
				cell.checkBoxButton.isHidden = true
			}
			cell.label.text = "soundOrder".localized
//				Localize("soundOrder")
			cell.label.textColor = TaxiColor.black
			cell.separatorInset = .init(top: 0, left: 50, bottom: 0, right: 20)
			return cell
		} else if indexPath.row == 4 {
			let cell = UITableViewCell()
			cell.backgroundColor = TaxiColor.white
			return cell
		} else if indexPath.row == 5 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsItemCell
			cell.checkBoxButton.isHidden = true
			cell.label.text = "language".localized
			return cell
		} else if indexPath.row == 6 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsItemCell
			cell.label.text = "languageInterface".localized
//				Localize("languageInterface")
			cell.separatorInset = .init(top: 0, left: 50, bottom: 0, right: 20)
			cell.checkBoxButton.isHidden = true
			cell.label.textColor = TaxiColor.black
			return cell
		} else if indexPath.row == 7 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsItemCell
			cell.label.text = "languageForAddress".localized
//				Localize("languageForAddress")
			cell.separatorInset = .init(top: 0, left: 50, bottom: 0, right: 20)
			cell.checkBoxButton.isHidden = true
			cell.label.textColor = TaxiColor.black
			return cell
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 0 {
			return 35
		} else if indexPath.row == 4 {
			return 15
		} else {
			return 44
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == 2 {
			choosenOption = .vibro
			tableView.reloadData()
		}
		
		if indexPath.row == 3 {
			choosenOption = .withSound
			tableView.reloadData()
		}
		
		if indexPath.row == 6 || indexPath.row == 7 {
			let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
			func addActionLanguage(language: Language) {
				alertController.addAction(
					UIAlertAction(
						title: language.rawValue.localized,
						style: UIAlertActionStyle.default,
						handler: { _ in
							
							Language.language = language
					})
				)
			}
			let cancelAction = UIAlertAction(title: Localize("cancel"), style: .cancel) { (action:UIAlertAction) in
			}
//			alertController.addAction(standartLanguageAction)
			addActionLanguage(language: Language.english)
			addActionLanguage(language: Language.russian)
			addActionLanguage(language: Language.chinese)
			addActionLanguage(language: Language.azer)
//			alertController.addAction(englishLanguageAction)
//			alertController.addAction(russianLanguageAction)
//			alertController.addAction(chineseLanguageAction)
//			alertController.addAction(azerbaijaniLanguageAction)
			alertController.addAction(cancelAction)
			self.present(alertController, animated: true, completion: nil)
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 8
	}
}
