//
//  SearchAddressController.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 17.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class SearchAddressController: UIViewController, UITextFieldDelegate, NibLoadable {
	
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
	var currentResponse: SearchAddressResponseModel? {
		didSet {
			if let _ = applyButton {
				updateButtonEnabled()
			}
		}
	}
	
	var applied: OptionalItemClosure<SearchAddressResponseModel>?
	
	private lazy var editClicked: ItemClosure<SearchAddressResponseModel> = { model in
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let selectAction = UIAlertAction(title: "Выбрать", style: .default, handler: { _ in
			self.cellSelectedClosure(model)
		})
		let deleteAction = UIAlertAction(title: "Удалить", style: .default, handler: { _ in
			let index = Storage.shared.savedAddressResponseModels().firstIndex(where: { (searchModel) -> Bool in
				return searchModel.FullName == model.FullName
			})
			
			if let indexToRemove = index {
				var array = Storage.shared.savedAddressResponseModels()
				array.remove(at: indexToRemove)
				Storage.shared.save(addressResponseModels: array)
			}
			self.setPrev()
		})
		
		let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
		alertController.addAction(selectAction)
		alertController.addAction(deleteAction)
		alertController.addAction(cancelAction)
		self.present(alertController, animated: true, completion: nil)
	}
	
	private lazy var cellSelectedClosure: ItemClosure<SearchAddressResponseModel> = { model in
		self.setPrev()
		self.currentResponse = model
		self.initializeDataIfNeeded()
	}
	
	private func updateButtonEnabled() {
		applyButton.isEnabled = currentResponse != nil
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		addressTextField.delegate = self
		addressTextField.clearButtonMode = .whileEditing
		addressTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
		textFieldUnderline()
		registerNibs()
		customizeBar()
		initTableView()
		updateDelegates()
		initializeDataIfNeeded()
		updateButtonEnabled()
		tableView.reloadData()
	}
	
	@IBAction func applyButtonClicked(sender: UIButton) {
		let comment = commentTextField.text ?? ""
		let porch = porchTextField.text ?? ""
		currentResponse?.comment = comment
		currentResponse?.porch = porch
		applied?(currentResponse)
		smartBack()
	}
	
	func initializeDataIfNeeded() {
		addressTextField.text = currentResponse?.FullName
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	
	func setPrev() {
		let prevDataSource = PreviousAddressDataSource(closure: cellSelectedClosure)
		prevDataSource.editButtonClicked = editClicked
		selectedDataSource = prevDataSource
		
		commentTextField.isHidden = false
		porchTextField.isHidden = false
		prevAddressLabel.isHidden = false
		update()
	}
	
	func setMain(dataSource: MainSearchAddressDataSource? = nil) {
		selectedDataSource = dataSource ?? MainSearchAddressDataSource(closure: cellSelectedClosure)
		commentTextField.isHidden = true
		porchTextField.isHidden = true
		prevAddressLabel.isHidden = true
		update()
	}
	
	func update() {
		updateDelegates()
		tableView.reloadData()
	}
	
	@objc func textFieldDidChange(_ textField: UITextField) {
		if !(textField.text?.isEmpty ?? true) {
			currentResponse = nil
			Throttler.shared.throttle(time: Time(0.55)) {
				let text = textField.text ?? ""
				
				AddressManager.shared.search(by: text, location: LocationInteractor.shared.myLocation!, with: { (models) in
					if models.isEmpty {
						self.setPrev()
					} else {
						let dataSource = MainSearchAddressDataSource(closure: self.cellSelectedClosure)
						dataSource.models = models
						self.setMain(dataSource: dataSource)
					}
				})
			}
		} else {
			setPrev()
		}
	}
	
	private func initTableView() {
		let prevDataSource = PreviousAddressDataSource(closure: cellSelectedClosure)
		prevDataSource.editButtonClicked = editClicked
		selectedDataSource = prevDataSource
		tableView.reloadData()
	}
	
	private func textFieldUnderline() {
		addressTextField.underline()
	}
	
	private func updateDelegates() {
		tableView.delegate = selectedDataSource
		tableView.dataSource = selectedDataSource
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
