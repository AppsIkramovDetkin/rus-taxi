//
//  SearchAddressController.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 17.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class SearchAddressController: UIViewController, UITextFieldDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var addressTextField: UITextField!
	@IBOutlet weak var commentTextField: UITextField!
	@IBOutlet weak var porchTextField: UITextField!
	@IBOutlet weak var prevAddressLabel: UILabel!
	@IBOutlet weak var applyButton: UIButton!
	
	private var addressModels: [Address] = [] {
		didSet {
			selectedDataSource?.update(with: addressModels)
		}
	}
	
	private var selectedDataSource: MainDataSource?

	override func viewDidLoad() {
		super.viewDidLoad()
		
		addressTextField.delegate = self
		addressTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
		textFieldUnderline()
		registerNibs()
		customizeBar()
		initTableView()
		delegating()
		tableView.reloadData()
	}
	
	@objc func textFieldDidChange(_ textField: UITextField) {
		let mainSearchDataSource = MainSearchAddressDataSource(models: addressModels)
		selectedDataSource = mainSearchDataSource
		commentTextField.isHidden = true
		porchTextField.isHidden = true
		prevAddressLabel.isHidden = true
		//		tableView.isHidden = false
	}
	
	private func initTableView() {
		let previousAddressDataSource = PreviousAddressDataSource(models: addressModels)
		selectedDataSource = previousAddressDataSource
	}

	private func textFieldUnderline() {
		addressTextField.underline()
	}
	
	private func delegating() {
		tableView.delegate = selectedDataSource
		tableView.dataSource = selectedDataSource
		tableView.isScrollEnabled = false
	}
	
	private func customizeBar() {
		navigationController?.navigationBar.barTintColor = TaxiColor.orange
		navigationController?.navigationBar.tintColor = TaxiColor.black
		self.title = "Откуда"
	}
	
//	func textFieldDidBeginEditing(_ textField: UITextField) {
//	}
	
	private func registerNibs() {
		tableView.register(UINib(nibName: "InputAddressCell", bundle: nil), forCellReuseIdentifier: "inputCell")
		tableView.register(UINib(nibName: "CommentAddressCell", bundle: nil), forCellReuseIdentifier: "commentCell")
		tableView.register(UINib(nibName: "LabelCell", bundle: nil), forCellReuseIdentifier: "labelCell")
		tableView.register(UINib(nibName: "PreviousAddressCell", bundle: nil), forCellReuseIdentifier: "prevCell")
	}
}
