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
	
	private var addressModels: [SearchAddressResponseModel] = [] {
		didSet {
			selectedDataSource?.update(with: addressModels)
		}
	}
	
	private var selectedDataSource: MainDataSource?
	var currentResponse: SearchAddressResponseModel?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		addressTextField.delegate = self
		addressTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
		textFieldUnderline()
		registerNibs()
		customizeBar()
		initTableView()
		delegating()
		initializeDataIfNeeded()
		tableView.reloadData()
	}
	
	func initializeDataIfNeeded() {
		addressTextField.text = currentResponse?.FullName
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	@objc func textFieldDidChange(_ textField: UITextField) {
		let mainSearchDataSource = MainSearchAddressDataSource()
		let previousAddressDataSource = PreviousAddressDataSource()
		if addressTextField.text?.isEmpty ?? true {
			selectedDataSource = previousAddressDataSource
			delegating()
			tableView.reloadData()
		} else {
			selectedDataSource = mainSearchDataSource
			delegating()
			tableView.reloadData()
			commentTextField.isHidden = true
			porchTextField.isHidden = true
			prevAddressLabel.isHidden = true
		}
	}
	
	private func initTableView() {
		let previousAddressDataSource = PreviousAddressDataSource()
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
		self.title = Localize("backVC")
	}
	
	private func registerNibs() {
		tableView.register(UINib(nibName: "InputAddressCell", bundle: nil), forCellReuseIdentifier: "inputCell")
		tableView.register(UINib(nibName: "CommentAddressCell", bundle: nil), forCellReuseIdentifier: "commentCell")
		tableView.register(UINib(nibName: "LabelCell", bundle: nil), forCellReuseIdentifier: "labelCell")
		tableView.register(UINib(nibName: "PreviousAddressCell", bundle: nil), forCellReuseIdentifier: "prevCell")
	}
}
