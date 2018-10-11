//
//  MainController.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 31.08.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

class MainController: UIViewController, UITableViewDelegate {
	@IBOutlet weak var mapView: GMSMapView!
	@IBOutlet weak var trashView: UIView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var tableViewBottom: NSLayoutConstraint!
	@IBOutlet weak var tableViewHeight: NSLayoutConstraint!
	
	private let overlayView: UIView = UIView()
	private var searchCarView: SearchCarView?
	private let tableViewBottomLimit: CGFloat = 0
	private var isOnCheckButton: Bool = true
	private var orderTimeView: OrderTimeView?
	private var acceptView: AcceptView?
	private var centerView: CenterView!
	private var locationManager = CLLocationManager()
	var addressModels: [Address] = [] {
		didSet {
			MapDataProvider.shared.addressModels = addressModels
			selectedDataSource?.update(with: addressModels)
		}
	}
	fileprivate var isMyLocationInitialized = false
	fileprivate var prevY: CGFloat = 0
	fileprivate var addressView: AddressView?
	fileprivate lazy var mapInteractorManager = MapInteractorsManager(mapView)
	fileprivate var selectedDataSource: MainDataSource?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		addAddressView()
		addAcceptView()
		addOrderTimeView()
		initializeMapView()
		registerNibs()
		initializeFirstAddressCells()
		addActions()
		LocationInteractor.shared.addObserver(delegate: self)
		addCenterView()
		set(dataSource: .main)

		initializeTableView()
		customizeTrashView()
		MapDataProvider.shared.addObserver(self)
		NewOrderDataProvider.shared.addObserver(self)
		receiveAddressesIfNeeded()
		tableView.reloadData()
	}
	
	private func addCenterView() {
		centerView = CenterView.loadFromNib()
		centerView?.translatesAutoresizingMaskIntoConstraints = false
		centerView.set(time: Time.zero.minutes(1))
		mapView.addSubview(centerView!)
		let constraints: [NSLayoutConstraint] = {
			return NSLayoutConstraint.contraints(withNewVisualFormat: "H:[x(40)],V:[x(60)]", dict: ["x": centerView!]) + [NSLayoutConstraint.centerX(for: centerView!, to: mapView)] + [NSLayoutConstraint.centerY(for: centerView!, offset: -30, to: mapView)]
		}()
		
		mapView.addConstraints(constraints)
	}
	
	@IBAction func rightButtonClicked(sender: UIButton) {
		let alertController = UIAlertController(title: "Отмена заказа", message: "Причина", preferredStyle: .alert)
		let causes = MapDataProvider.shared.lastCheckOrderResponse?.cause_order ?? []
		causes.forEach { (cause) in
			let action = UIAlertAction.init(title: cause.name ?? "", style: .default, handler: { (action) in
				if let id = cause.id {
					NewOrderDataProvider.shared.cancelOrder(with: id, with: { (cancelResponse) in
						let message = cancelResponse?.err_txt ?? ""
						self.clear()
						self.showAlertWithOneAction(title: "", message: message, handle: {
							
						})
					})
				}
			})
			
			alertController.addAction(action)
		}
		let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
		alertController.addAction(cancelAction)
		present(alertController, animated: true, completion: nil)
	}
	
	private func clear() {
		NewOrderDataProvider.shared.clear()
		MapDataProvider.shared.stopCheckingOrder()
		StatusSaver.shared.delete()
		set(dataSource: .main)
		addressModels.removeAll()
		addressModels.append(Address.init(pointName: points[0]))
		addressModels.append(Address.init(pointName: points[1]))
		tableView.reloadData()
	}
	
	private func receiveAddressesIfNeeded() {
		if let model = StatusSaver.shared.retrieve(), !(model.status ?? "").isEmpty && !(model.local_id ?? "").isEmpty {
			self.addressModels = model.addressModels
		}
	}
	
	private func addAddressView() {
		addressView = Bundle.main.loadNibNamed("AddressView", owner: self, options: nil)?.first as? AddressView
		addressView?.translatesAutoresizingMaskIntoConstraints = false
		if let unboxAddressView = addressView {
			self.view.addSubview(unboxAddressView)
			
			let constraints: [NSLayoutConstraint] = {
				return NSLayoutConstraint.contraints(withNewVisualFormat: "H:|-16-[addressView]-16-|,V:|-32-[addressView(44)]", dict: ["addressView": unboxAddressView])
			}()
			
			self.view.addConstraints(constraints)
		}
	}
	
	private func addOrderTimeView() {
		orderTimeView = Bundle.main.loadNibNamed("OrderTimeView", owner: self, options: nil)?.first as? OrderTimeView
		if let unboxOrderTimeView = orderTimeView {
			unboxOrderTimeView.frame = CGRect(x: 20, y: -400, width: self.view.frame.width - 40, height: 217)
		}
	}
	
	private func customizeTrashView() {
		trashView.clipsToBounds = true
	}
	
	private func addAcceptView() {
		acceptView = Bundle.main.loadNibNamed("AcceptView", owner: self, options: nil)?.first as? AcceptView
		if let unboxAcceptView = acceptView {
			self.view.addSubview(unboxAcceptView)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
		navigationController?.setNavigationBarHidden(true, animated: true)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		updatePrevY()
		set(dataSource: .main)
	}
	
	private func updatePrevY() {
		prevY = tableView.frame.origin.y
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		tableViewHeight?.constant = self.tableView.contentSize.height
		trashView.layer.cornerRadius = trashView.frame.size.height / 2
		acceptView?.frame = CGRect(x: 10, y: -150, width: self.view.frame.width - 20, height: 100)
		if isTableViewHiddenMannualy {
			self.hideTableView(duration: 0)
		}
	}
	
	@objc private func checkButtonClicked(sender: UIButton) {
		isOnCheckButton = !isOnCheckButton
		isOnCheckButton ? NewOrderDataProvider.shared.onNearestTime() : NewOrderDataProvider.shared.offNearestTime()
		if isOnCheckButton {
			orderTimeView?.checkButton.setImage(UIImage(named: "checking"), for: .normal)
		} else {
			orderTimeView?.checkButton.setImage(UIImage(named: "noImage"), for: .normal)
		}
	}
	
	@objc private func refuseButtonClicked() {
		let alertController = UIAlertController(title: "Причина", message: nil , preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
		
		let lateDriver = UIAlertAction(title: "Водитель опоздал", style: .default) {
			(result : UIAlertAction) -> Void in
			self.acceptButtonClicked()
		}
		
		let driverCancel = UIAlertAction(title: "Водитель хочет отменить заказ", style: .default) {
			(result : UIAlertAction) -> Void in
			self.acceptButtonClicked()
		}
		
		let changePlan = UIAlertAction(title: "Изменились планы", style: .default) {
			(result : UIAlertAction) -> Void in
			self.acceptButtonClicked()
		}
		
		let okAction = UIAlertAction(title: "Отмена", style: .cancel) {
			(result : UIAlertAction) -> Void in
		}
		
		alertController.addAction(lateDriver)
		alertController.addAction(driverCancel)
		alertController.addAction(changePlan)
		alertController.addAction(okAction)
		self.present(alertController, animated: true, completion: nil)
	}
	
	private func addActions() {
		acceptView?.acceptButton.addTarget(self, action: #selector(acceptButtonClicked), for: .touchUpInside)
		acceptView?.refuseButton.addTarget(self, action: #selector(refuseButtonClicked), for: .touchUpInside)
		orderTimeView?.acceptButton.addTarget(self, action: #selector(timeSelected), for: .touchUpInside)
		orderTimeView?.cancelButton.addTarget(self, action: #selector(hideOrderView), for: .touchUpInside)
	}
	
	@objc private func timeSelected() {
		hideOrderView()
		
		guard let date = orderTimeView?.date else {
			return
		}
		
		NewOrderDataProvider.shared.set(date: date)
		tableView.reloadData()
	}
	
	@objc private func showAcceptView() {
		if let unboxAcceptView = acceptView {
			UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
				unboxAcceptView.frame = CGRect(x: 10, y: 100, width: self.view.frame.width - 20, height: 100)
			}) { (_ ) in
				unboxAcceptView.layer.shadowOffset = CGSize(width: 0, height: 3)
				unboxAcceptView.layer.shadowOpacity = 0.2
				unboxAcceptView.layer.shadowRadius = 3.0
				unboxAcceptView.layer.shadowColor = TaxiColor.black.cgColor
			}
		}
	}
	
	@objc private func hideOrderView() {
		orderTimeView?.setOrderView(hidden: true)
		self.overlayView.isHidden = true
	}
	
	@objc private func acceptButtonClicked() {
		UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
			self.acceptView?.frame = CGRect(x: 10, y: -100, width: self.view.frame.width - 20, height: 100)
		}, completion: nil)
	}
	
	private func setMainDataSource() {
		centerView.isHidden = false
		mapView.stopPulcing()
		let startDataSource = MainControllerDataSource(models: addressModels)
		startDataSource.viewController = self
		trashView.isHidden = true
		startDataSource.actionAddClicked = {
			self.insertNewCells()
		}
		startDataSource.pushClicked = ActionHandler.getChangeAddressClosure(in: self)
		
		startDataSource.payTypeClicked = {
			PayAlertController.shared.showPayAlert(in: self) { (money, card) in }
		}
		
		startDataSource.deleteCellClicked = { view in
			guard let indexPath = self.tableView.indexPathForView(view: view) else {
				return
			}
			self.deleteCell(at: indexPath.row)
		}
		startDataSource.orderTimeClicked = {
			self.orderTimeView?.setOrderView(hidden: false)
			if let unboxOrderTimeView = self.orderTimeView {
				unboxOrderTimeView.checkButton.addTarget(self, action: #selector(self.checkButtonClicked(sender:)), for: .touchUpInside)
				unboxOrderTimeView.frame = CGRect(x: 20, y: 250, width: self.view.frame.width - 40, height: 217)
				self.overlayView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
				self.overlayView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
				self.overlayView.isHidden = false
				self.view.addSubview(self.overlayView)
				self.view.addSubview(unboxOrderTimeView)
			}
		}
		startDataSource.wishesClicked = {
			let vc = WishesController()
			self.navigationController?.pushViewController(vc, animated: true)
		}
		startDataSource.currentLocationClicked = {
			if let coordinate = LocationInteractor.shared.myLocation {
				self.mapView.animate(toLocation: coordinate)
			}
		}
		startDataSource.subviewsLayouted = {
			self.viewDidLayoutSubviews()
		}
		
		startDataSource.scrollViewScrolled = { [unowned self] scrollView in
			guard !KeyboardInteractor.shared.isShowed else {
				return
			}
			
			let condition = (self.tableView.frame.origin.y - scrollView.contentOffset.y) > self.prevY
			
			if condition {
				self.tableView.frame.origin.y -= scrollView.contentOffset.y
			} else if self.tableView.frame.origin.y <= self.prevY + 1 {
				self.tableView.contentOffset = CGPoint.zero
			}
		}

		startDataSource.scrollViewDragged = { [unowned self] scrollView in
			guard !KeyboardInteractor.shared.isShowed else {
				return
			}
			
			let isOnFirstHalf: Bool = {
				return abs(self.prevY - scrollView.frame.origin.y) < scrollView.frame.height * 0.55
			}()
			
			isOnFirstHalf ? self.showTableView() : self.hideTableView()
			if !isOnFirstHalf {
				self.isTableViewHiddenMannualy = true
			} else {
				self.isTableViewHiddenMannualy = false
			}
		}
		
		selectedDataSource = startDataSource
	}
	
	private func setOnDriveDataSource(response: CheckOrderModel?) {
		centerView.isHidden = true
		let onDriveDataSource = OnDriveDataSource(models: addressModels)
		onDriveDataSource.viewController = self
		onDriveDataSource.response = response
		onDriveDataSource.pushClicked = ActionHandler.getSelectAddressClosure(in: self)
		onDriveDataSource.chatClicked = {
			let vc = ChatController()
			self.navigationController?.pushViewController(vc, animated: true)
		}
		
		onDriveDataSource.subviewsLayouted = {
			self.viewDidLayoutSubviews()
		}
		
		onDriveDataSource.scrollViewScrolled = { [unowned self] scrollView in
			guard !KeyboardInteractor.shared.isShowed else {
				return
			}
			let condition = (self.tableView.frame.origin.y - scrollView.contentOffset.y) > self.prevY
			
			if condition {
				self.tableView.frame.origin.y -= scrollView.contentOffset.y
			} else if self.tableView.frame.origin.y <= self.prevY + 1 {
				self.tableView.contentOffset = CGPoint.zero
			}
			
			let isOnFirstHalf: Bool = {
				return abs(self.prevY - scrollView.frame.origin.y) < scrollView.frame.height * 0.55
			}()
			
			isOnFirstHalf ? self.showTableView() : self.hideTableView()
		}
		
		onDriveDataSource.scrollViewDragged = { [unowned self] scrollView in
			guard !KeyboardInteractor.shared.isShowed else {
				return
			}
			let isOnFirstHalf: Bool = {
				return abs(self.prevY - scrollView.frame.origin.y) < scrollView.frame.height * 0.55
			}()
			
			UIView.animate(withDuration: 0.2, animations: {
				if isOnFirstHalf {
					scrollView.frame.origin.y = self.prevY
				} else {
					scrollView.frame.origin.y = self.view.frame.maxY - scrollView.frame.height * 0.3
				}
			})
		}
		
		selectedDataSource = onDriveDataSource
	}
	
	private func setCarWaitingDataSource(response: CheckOrderModel?) {
		centerView.isHidden = true
		mapView.stopPulcing()
		let carWaitingDataSource = CarWaitingDataSource(models: addressModels)
		carWaitingDataSource.viewController = self
		carWaitingDataSource.response = response
		carWaitingDataSource.pushClicked = ActionHandler.getSelectAddressClosure(in: self)
		carWaitingDataSource.chatClicked = {
			let vc = ChatController()
			self.navigationController?.pushViewController(vc, animated: true)
		}
		
		carWaitingDataSource.payTypeClicked = {
			PayAlertController.shared.showPayAlert(in: self) { (money, card) in }
		}
		
		carWaitingDataSource.subviewsLayouted = {
			self.viewDidLayoutSubviews()
		}
		
		carWaitingDataSource.scrollViewScrolled = { [unowned self] scrollView in
			guard !KeyboardInteractor.shared.isShowed else {
				return
			}
			let condition = (self.tableView.frame.origin.y - scrollView.contentOffset.y) > self.prevY
			
			if condition {
				self.tableView.frame.origin.y -= scrollView.contentOffset.y
			} else if self.tableView.frame.origin.y <= self.prevY + 1 {
				self.tableView.contentOffset = CGPoint.zero
			}
			
			let isOnFirstHalf: Bool = {
				return abs(self.prevY - scrollView.frame.origin.y) < scrollView.frame.height * 0.55
			}()
			
			isOnFirstHalf ? self.showTableView() : self.hideTableView()
		}
		
		carWaitingDataSource.scrollViewDragged = { [unowned self] scrollView in
			guard !KeyboardInteractor.shared.isShowed else {
				return
			}
			let isOnFirstHalf: Bool = {
				return abs(self.prevY - scrollView.frame.origin.y) < scrollView.frame.height * 0.55
			}()
			
			UIView.animate(withDuration: 0.2, animations: {
				if isOnFirstHalf {
					scrollView.frame.origin.y = self.prevY
				} else {
					scrollView.frame.origin.y = self.view.frame.maxY - scrollView.frame.height * 0.3
				}
			})
		}
		
		let lat = CLLocationDegrees(Int(addressModels.first?.response?.lat ?? "") ?? 0)
		let lng = CLLocationDegrees(Int(addressModels.first?.response?.lon ?? "") ?? 0)
		
		let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
		selectedDataSource = carWaitingDataSource
		setSourceMarker(at: coordinate)
	}
	
	private func setSearchDataSource(response: CheckOrderModel?) {
		centerView.isHidden = true
		let searchCarDataSource = SearchCarDataSource(models: addressModels)
		searchCarDataSource.viewController = self
		searchCarDataSource.pushClicked = ActionHandler.getSelectAddressClosure(in: self)
		selectedDataSource = searchCarDataSource
		let lat = response?.lat ?? 0
		let lng = response?.lon ?? 0
		
		trashView.isHidden = false
		searchCarDataSource.subviewsLayouted = {
			self.viewDidLayoutSubviews()
		}
		
		searchCarDataSource.orderTimeClicked = {
			self.orderTimeView?.setOrderView(hidden: false)
			if let unboxOrderTimeView = self.orderTimeView {
				unboxOrderTimeView.checkButton.addTarget(self, action: #selector(self.checkButtonClicked(sender:)), for: .touchUpInside)
				unboxOrderTimeView.frame = CGRect(x: 20, y: 250, width: self.view.frame.width - 40, height: 217)
				self.overlayView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
				self.overlayView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
				self.overlayView.isHidden = false
				self.view.addSubview(self.overlayView)
				self.view.addSubview(unboxOrderTimeView)
			}
		}
		
		searchCarDataSource.wishesClicked = {
			let vc = WishesController()
			self.navigationController?.pushViewController(vc, animated: true)
		}
		
		searchCarDataSource.scrollViewScrolled = { [unowned self] scrollView in
			guard !KeyboardInteractor.shared.isShowed else {
				return
			}
			let condition = (self.tableView.frame.origin.y - scrollView.contentOffset.y) > self.prevY
			
			if condition {
				self.tableView.frame.origin.y -= scrollView.contentOffset.y
			} else if self.tableView.frame.origin.y <= self.prevY + 1 {
				self.tableView.contentOffset = CGPoint.zero
			}
			
			let isOnFirstHalf: Bool = {
				return abs(self.prevY - scrollView.frame.origin.y) < scrollView.frame.height * 0.55
			}()
			
			isOnFirstHalf ? self.showTableView() : self.hideTableView()
		}
		
		searchCarDataSource.scrollViewDragged = { [unowned self] scrollView in
			guard !KeyboardInteractor.shared.isShowed else {
				return
			}
			let isOnFirstHalf: Bool = {
				return abs(self.prevY - scrollView.frame.origin.y) < scrollView.frame.height * 0.55
			}()
			
			UIView.animate(withDuration: 0.2, animations: {
				if isOnFirstHalf {
					scrollView.frame.origin.y = self.prevY
				} else {
					scrollView.frame.origin.y = self.view.frame.maxY - scrollView.frame.height * 0.3
				}
			})
		}
		
		if !mapView.isPulcing {
			let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
			mapView.startPulcing(at: coordinate)
		}
	}
	
	var driverMarker: GMSMarker?
	var sourceMarker: GMSMarker?
	
	private func setOnWayDataSource(with response: CheckOrderModel? = nil) {
		mapView.stopPulcing()
		trashView.isHidden = false
		centerView.isHidden = true
		let driverOnWayDataSource = DriverOnWayDataSource(models: addressModels, response: response)
		driverOnWayDataSource.viewController = self
		driverOnWayDataSource.chatClicked = {
			let vc = ChatController()
			self.navigationController?.pushViewController(vc, animated: true)
		}
		driverOnWayDataSource.pushClicked = ActionHandler.getSelectAddressClosure(in: self)
		selectedDataSource = driverOnWayDataSource
		let lat = response?.lat ?? 0
		let lng = response?.lon ?? 0
		
		let coordinate = CLLocationCoordinate2D.init(latitude: lat, longitude: lng)
		setDriverMarker(at: coordinate)
		mapView.animate(toLocation: coordinate)
		mapView.animate(toZoom: 16)
	}
	
	func setSourceMarker(at coordinate: CLLocationCoordinate2D) {
		sourceMarker?.map = nil
		sourceMarker = GMSMarker.init(position: coordinate)
		sourceMarker?.icon = #imageLiteral(resourceName: "pin")
		sourceMarker?.map = mapView
	}
	
	func setDriverMarker(at coordinate: CLLocationCoordinate2D) {
		driverMarker?.map = nil
		driverMarker = GMSMarker.init(position: coordinate)
		driverMarker?.icon = #imageLiteral(resourceName: "ic_standard_car_select")
		driverMarker?.map = mapView
	}
	
	func set(dataSource type: DataSourceType, with response: CheckOrderModel? = nil) {
		switch type {
		case .main:
			setMainDataSource()
		case .search:
			setSearchDataSource(response: response)
		case .onTheWay:
			setOnWayDataSource(with: response)
		case .waitingForPassenger:
			setCarWaitingDataSource(response: response)
		case .pasengerInCab:
			setOnDriveDataSource(response: response)
		}
		switch type {
		case .main:
			mapInteractorManager.clearMarkers(of: .address)
		default:
			mapInteractorManager.show(addressModels.map { AddressMarker.init(address: $0) })
		}
		updatePrevY()
		Toast.hide()
		refreshDelegates()
		tableView.reloadData()
	}
	
	var isTableViewHiddenMannualy = false
	
	fileprivate func hideTableView(duration: TimeInterval = 0.2) {
		UIView.animate(withDuration: duration, animations: {
			self.tableViewBottom.constant = -(self.tableView.frame.height * 0.8)
			self.view.layoutIfNeeded()
		})
		
		addressView?.show()
	}

	fileprivate func showTableView() {
		UIView.animate(withDuration: 0.2, animations: {
			self.tableViewBottom.constant = 0
			self.view.layoutIfNeeded()
		})
	}
	
	private func initializeFirstAddressCells() {
		let address = Address(pointName: points[0])
		addPoint(by: address)
		let address1 = Address(pointName: points[1])
		addPoint(by: address1)
	}
	
	private func initializeMapView() {
		mapView.isMyLocationEnabled = true
		mapView.delegate = self
	}
	
	private func refreshDelegates() {
		tableView.delegate = selectedDataSource
		tableView.dataSource = selectedDataSource
	}
	
	private func initializeTableView() {
		refreshDelegates()
		tableView.isScrollEnabled = true
		
		tableView.layer.masksToBounds = false
		tableView.layer.shadowOffset = CGSize(width: 0, height: 3)
		tableView.layer.shadowColor = TaxiColor.black.cgColor
		tableView.layer.shadowOpacity = 0.9
		tableView.layer.shadowRadius = 4
	}
	
	private func registerNibs() {
		tableView.register(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: "headCell")
		tableView.register(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "settingsCell")
		tableView.register(AddressCell.nib, forCellReuseIdentifier: "addressCell")
		tableView.register(UINib(nibName: "ChooseTaxiCell", bundle: nil), forCellReuseIdentifier: "chooseTaxiCell")
		tableView.register(UINib(nibName: "CallTaxiCell", bundle: nil), forCellReuseIdentifier: "callTaxiCell")
		tableView.register(UINib(nibName: "DriveDetailsCell", bundle: nil), forCellReuseIdentifier: "driveCell")
		tableView.register(UINib(nibName: "DriverDetailsCell", bundle: nil), forCellReuseIdentifier: "driverCell")
		tableView.register(UINib(nibName: "PropertiesCell", bundle: nil), forCellReuseIdentifier: "propertiesCell")
		tableView.register(UINib(nibName: "PricesCell", bundle: nil), forCellReuseIdentifier: "pricesCell")
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		Toast.hide()
	}
	
	private func insertNewCells() {
		guard addressModels.count < points.count else {
			return
		}
		addPoint(by: Address.init(pointName: points[addressModels.count]))
	}
	
	private func deleteCell(at index: Int) {
		removePoint(by: index)
	}
	
	fileprivate func addPoint(by model: Address) {
		guard addressModels.count < points.count else {
			return
		}
		let previousIndexPath = IndexPath.init(row: addressModels.count, section: 0)
		let indexPath = IndexPath.init(row: addressModels.count + 1, section: 0)
		addressModels.append(model)
		tableView.insertRows(at: [indexPath], with: .bottom)
		tableView.reloadRows(at: [previousIndexPath], with: .automatic)
		prevY = tableView.frame.origin.y
	}
	
	fileprivate func removePoint(by index: Int) {
		let previousIndexPath = IndexPath.init(row: addressModels.count - 1, section: 0)
		let indexPath = IndexPath.init(row: addressModels.count, section: 0)
		addressModels.removeLast()
		tableView.deleteRows(at: [indexPath], with: .automatic)
		tableView.reloadRows(at: [previousIndexPath], with: .automatic)
		prevY = tableView.frame.origin.y
	}
	var locationDragged = false
}

extension MainController: GMSMapViewDelegate {
	func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
		if locationDragged {
			locationDragged = false
			showTableView()
			addressView?.hide()
		}
	}
	
	func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
		if !locationDragged {
			hideTableView()
			addressView?.show()
		}
		locationDragged = true

		guard let _ = selectedDataSource as? MainControllerDataSource else {
			return
		}
		
		let center = mapView.center
		let coordinate = mapView.projection.coordinate(for: center)
		let tarriffId = NewOrderDataProvider.shared.request.tarif ?? ""
		self.centerView.clearTime()
		OrderManager.shared.getNearCar(tariff_id: tarriffId, location: coordinate, with: {
			nearCars in
			
			self.mapInteractorManager.show(nearCars.map{NearCarMarker.init(nearCarResponse: $0)})
			if let timed = nearCars.first?.time_n {
				self.centerView.set(time: Time.zero.minutes(TimeInterval(timed)))
			} else {
				self.centerView.clearTime()
			}
		})
		LocationInteractor.shared.response(location: coordinate) { (response) in
			if let responsed = response {
				let searchResponseModel = SearchAddressResponseModel.from(nearModel: responsed)
				self.addressView?.configure(by: searchResponseModel)
			}
			
			guard let _ = self.selectedDataSource as? MainControllerDataSource else {
				return
			}
			
			guard response?.FullName ?? "" != self.addressModels[0].address else {
				return
			}
			
			Toast.show(with: response?.FullName ?? "", completion: {
				if let addressModel = Address.from(response: response), let responsed = response {
					self.addressModels.first(to: addressModel)
					AddressInteractor.shared.remind(addresses: [SearchAddressResponseModel.from(nearModel: responsed)])
					NewOrderDataProvider.shared.setSource(by: AddressModel.from(response: SearchAddressResponseModel.from(nearModel: responsed)))
					self.tableView.reloadData()
					self.isTableViewHiddenMannualy = false
					self.showTableView()
				}
			}, timeline: Time(10))
		}
	}
}

extension UIView {
	var visibleRect: CGRect? {
		guard let superview = superview else { return nil }
		return frame.intersection(superview.bounds)
	}
}

extension MainController: LocationInteractorDelegate {
	func didUpdateLocations(locations: [CLLocation]) {
		if !isMyLocationInitialized {
			// first time animate
			if let coordinate = locations.first {
				mapView.animate(toLocation: coordinate.coordinate)
				mapView.animate(toZoom: 16)
			}
		}
		isMyLocationInitialized = true
	}
}

enum DataSourceType {
	case main
	case search
	case onTheWay
	case waitingForPassenger
	case pasengerInCab
}

extension MainController: MapProviderObservable {
	func orderRefreshed(with orderResponse: CheckOrderModel?) {
		SoundInteractor.playDefault()
		switch orderResponse?.status ?? "" {
		case "Published":
			set(dataSource: .search, with: orderResponse)
		case "CarOnTheWayToPassenger":
			set(dataSource: .onTheWay, with: orderResponse)
		case "CabWaitingForPassenger":
			set(dataSource: .waitingForPassenger, with: orderResponse)
		case "PassengerInCab":
			set(dataSource: .pasengerInCab, with: orderResponse)
		case "Completed":
			self.clear()
		default: break
		}
	}
}

extension MainController: NewOrderDataProviderObserver {
	func precalculated() {
		tableView.reload(row: 0)
	}
	
	func requestChanged() {
		NewOrderDataProvider.shared.precalculate()
	}
}

extension MainController {
	class ActionHandler {
		static func getChangeAddressClosure(in mainVc: MainController) -> ItemClosure<Int> {
			let changeAddressClosure: ItemClosure<Int> = {
				index in
				let vc = SearchAddressController()
				vc.currentResponse = mainVc.addressModels[index].response
				vc.applied = { editedModel in
					if let mod = editedModel, let address = Address.from(response: mod, pointName: points[index]) {
						mainVc.addressModels[index] = address
						AddressInteractor.shared.remind(addresses: [mod])
						if index == 0 {
							NewOrderDataProvider.shared.setSource(by: AddressModel.from(response: mod))
						} else {
							NewOrderDataProvider.shared.change(dest: index - 1, with: AddressModel.from(response: mod))
						}
						mainVc.tableView.reloadData()
					}
				}
				mainVc.navigationController?.pushViewController(vc, animated: true)
			}
			return changeAddressClosure
		}
		
		static func getSelectAddressClosure(in mainVc: MainController) -> ItemClosure<Int> {
			let selectAddressClosure: ItemClosure<Int> = {
				index in
				
				mainVc.mapInteractorManager.addressCarInteractor.select(address: mainVc.addressModels[index])
			}
			return selectAddressClosure
		}
	}
}
