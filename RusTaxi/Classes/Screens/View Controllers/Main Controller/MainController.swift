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
import Material
import SideMenu

class MainController: UIViewController, UITableViewDelegate, UISideMenuNavigationControllerDelegate {
	@IBOutlet weak var mapView: GMSMapView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var menuButton: CustomButton!
	@IBOutlet weak var changingButton: CustomButton!
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
	fileprivate lazy var router = MainControllerRouter(root: self)
	fileprivate var selectedDataSource: MainDataSource?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		addAddressView()
		addAcceptView()		
		addOrderTimeView()
		addSearchCarView()
		initializeMapView()
		registerNibs()
		initializeFirstAddressCells()
		addActions()
		hideAcceptView()
		LocationInteractor.shared.addObserver(delegate: self)
		addCenterView()
		set(dataSource: .main)
		menuButton.addTarget(self, action: #selector(menuButtonClicked), for: .touchUpInside)
		initializeTableView()
		MapDataProvider.shared.addObserver(self)
		NewOrderDataProvider.shared.addObserver(self)
		receiveAddressesIfNeeded()
		initSideMenu()
		tableView.reloadData()
	}
	
	@objc fileprivate func menuButtonClicked() {
		present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
	}
	
	func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
		self.overlayView.isHidden = true
	}
	
	func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
		self.overlayView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
		self.overlayView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
		self.overlayView.isHidden = false
		self.view.addSubview(self.overlayView)
	}
	
	private func initSideMenu() {
		let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: SideMenuController())
		menuLeftNavigationController.isNavigationBarHidden = true
		SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
		SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
		SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
		SideMenuManager.default.menuPresentMode = .menuSlideIn
		SideMenuManager.default.menuFadeStatusBar = false
	}
	
	private func addSearchCarView() {
		searchCarView = SearchCarView.loadFromNib()
		searchCarView?.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(searchCarView!)
		
		let constraints = NSLayoutConstraint.contraints(withNewVisualFormat: "H:[leftButton]-16-[statusView]-8-[rightButton],V:|-32-[statusView]", dict: ["leftButton": menuButton, "statusView": searchCarView!, "rightButton": changingButton])
		view.addConstraints(constraints)
	}
	
	@objc private func changingButtonClicked() {
		
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
	
	func startLoading() {
		if let dataSource = selectedDataSource as? LoaderDataSource {
			dataSource.startLoading()
		}
	}
	
	func endLoading() {
		if let dataSource = selectedDataSource as? LoaderDataSource {
			dataSource.stopLoading()
		}
	}
	
	@IBAction func rightButtonClicked(sender: UIButton) {
		let alertController = UIAlertController(title: Localize("cancelOrder"), message: Localize("reason"), preferredStyle: .alert)
		let causes = MapDataProvider.shared.lastCheckOrderResponse?.cause_order ?? []
		causes.forEach { (cause) in
			let action = UIAlertAction.init(title: cause.name ?? "", style: .default, handler: { (action) in
				if let id = cause.id {
					NewOrderDataProvider.shared.cancelOrder(with: id, with: { (cancelResponse) in
						let message = cancelResponse?.err_txt ?? ""
						self.clear(with: nil)
						self.showAlertWithOneAction(title: "", message: message, handle: {
							
						})
					})
				}
			})
			
			alertController.addAction(action)
		}
		let cancelAction = UIAlertAction(title: Localize("cancel"), style: .cancel, handler: nil)
		alertController.addAction(cancelAction)
		present(alertController, animated: true, completion: nil)
	}
	
	private func clear(with checkOrderResponse: CheckOrderModel?) {
		if let response = checkOrderResponse {
			router.showResultScreen(with: response)
		}
		NewOrderDataProvider.shared.clear()
		MapDataProvider.shared.stopCheckingOrder()
		StatusSaver.shared.delete()
		set(dataSource: .main)
		mapInteractorManager.clearMarkers(of: .address)
		addressModels.removeAll()
		addressModels.append(Address.init(pointName: points[0]))
		addressModels.append(Address.init(pointName: points[1]))
		tableView.reloadData()
		hideAcceptView()
	}
	
	private func receiveAddressesIfNeeded() {
		if let model = StatusSaver.shared.retrieve(), !(model.status ?? "").isEmpty && !(model.local_id ?? "").isEmpty {
			self.addressModels = model.addressModels
		}
	}
	
	private func addAddressView() {
		addressView = Bundle.main.loadNibNamed("AddressView", owner: self, options: nil)?.first as? AddressView
		addressView?.translatesAutoresizingMaskIntoConstraints = false
		addressView?.addressLabel.text = "..."
		addressView?.countryLabel.text = ""
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
	
	private func addAcceptView() {
		acceptView = AcceptView.loadFromNib()
		acceptView?.translatesAutoresizingMaskIntoConstraints = false
		
		acceptView?.acceptButtonClicked = {
			self.hideAcceptView()
			if let model = self.acceptView?.model, let check = MapDataProvider.shared.lastCheckOrderResponse {
				OrderManager.shared.acceptDriverAuction(model: check, checkModel: model, with: { (checkOrder) in
					MapDataProvider.shared.localUpdate(with: checkOrder)
				})
			}
		}
		
		acceptView?.declineButtonClicked = {
			self.hideAcceptView()
			if let model = self.acceptView?.model, let check = MapDataProvider.shared.lastCheckOrderResponse {
				OrderManager.shared.declineDriverAuction(model: check, checkModel: model, with: { (checkOrder) in
					MapDataProvider.shared.localUpdate(with: checkOrder)
				})
			}
		}
		if let unboxAcceptView = acceptView {
			self.view.addSubview(unboxAcceptView)
			
			let constraints: [NSLayoutConstraint] = {
				return NSLayoutConstraint.contraints(withNewVisualFormat: "H:|-16-[addressView]-16-|,V:|-32-[addressView(110)]", dict: ["addressView": unboxAcceptView])
			}()
			
			self.view.addConstraints(constraints)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
		precalculated()
		navigationController?.setNavigationBarHidden(true, animated: true)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		updatePrevY()
	}
	
	private func updatePrevY() {
		prevY = tableView.frame.origin.y
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		tableViewHeight?.constant = self.tableView.contentSize.height
		menuButton.layer.cornerRadius = menuButton.bounds.size.height / 2
		changingButton.layer.cornerRadius = changingButton.bounds.size.height / 2
		if isTableViewHiddenMannualy {
			self.hideTableView(duration: 0)
		}
	}
	
	@objc private func checkButtonClicked(sender: UIButton) {
		isOnCheckButton = !isOnCheckButton
		if isOnCheckButton {
			orderTimeView?.checkButton.setImage(UIImage(named: "checking"), for: .normal)
			NewOrderDataProvider.shared.onNearestTime()
		} else {
			orderTimeView?.checkButton.setImage(UIImage(named: "noImage"), for: .normal)
			NewOrderDataProvider.shared.offNearestTime()
		}
	}
	
	private func addActions() {
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
			UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
				unboxAcceptView.transform = CGAffineTransform.identity
			}) { (_ ) in
				unboxAcceptView.layer.shadowOffset = CGSize(width: 0, height: 3)
				unboxAcceptView.layer.shadowOpacity = 0.2
				unboxAcceptView.layer.shadowRadius = 3.0
				unboxAcceptView.layer.shadowColor = TaxiColor.black.cgColor
			}
		}
	}
	
	@objc private func showSearchCarView() {
		if let unboxSearchCarView = searchCarView {
			UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
				unboxSearchCarView.frame = CGRect(x: 10, y: 100, width: self.view.frame.width - 20, height: 100)
			}) { (_ ) in
				unboxSearchCarView.layer.shadowOffset = CGSize(width: 0, height: 3)
				unboxSearchCarView.layer.shadowOpacity = 0.2
				unboxSearchCarView.layer.shadowRadius = 3.0
				unboxSearchCarView.layer.shadowColor = TaxiColor.black.cgColor
			}
		}
	}
	
	@objc private func hideOrderView() {
		orderTimeView?.setOrderView(hidden: true)
		self.overlayView.isHidden = true
	}
	
	@objc private func hideAcceptView() {
		UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
			self.acceptView?.transform = CGAffineTransform.init(translationX: 0, y: -200)
		}, completion: nil)
	}
	
	private func setMainDataSource() {
		NewOrderDataProvider.shared.onNearestTime()
		addressView?.isHidden = false
		driverMarker?.map = nil
		centerView.isHidden = false
		searchCarView?.isHidden = true

		menuButton.isHidden = false
		menuButton.toMenu()
		changingButton.toShare()
		changingButton.addTarget(self, action: #selector(changingButtonClicked), for: .touchUpInside)

		mapView.stopPulcing()
		let startDataSource = MainControllerDataSource(models: addressModels)
		startDataSource.viewController = self
		startDataSource.actionAddClicked = {
			self.insertNewCells()
		}
		startDataSource.pushClicked = ActionHandler.getChangeAddressClosure(in: self)
		
		startDataSource.payTypeClicked = {
			let vc = AboutTaxiController()
			self.navigationController?.pushViewController(vc, animated: true)
//			PayAlertController.shared.showPayAlert(in: self) { (money, card) in }
		}
		
		startDataSource.deleteCellClicked = { view in
			guard let indexPath = self.tableView.indexPathForView(view: view) else {
				return
			}
			self.deleteCell(at: indexPath.row - 1)
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
			let vc = SettingsController()
			self.navigationController?.pushViewController(vc, animated: true)
//			let vc = WishesController()
//			self.navigationController?.pushViewController(vc, animated: true)
		}
		startDataSource.currentLocationClicked = {
			let vc = ProfileController()
			self.navigationController?.pushViewController(vc, animated: true)
//			if let coordinate = LocationInteractor.shared.myLocation {
//				self.mapView.animate(toLocation: coordinate)
//			}
		}
		startDataSource.subviewsLayouted = {
			self.viewDidLayoutSubviews()
		}
		
		startDataSource.scrollViewScrolled = ActionHandler.scrollViewScrolled(in: self)
		startDataSource.scrollViewDragged = ActionHandler.scrollViewDragged(in: self)
		
		selectedDataSource = startDataSource
	}
	
	private func setOnDriveDataSource(response: CheckOrderModel?) {
		centerView.isHidden = true
		addressView?.isHidden = true
		menuButton.isHidden = true
		searchCarView?.isHidden = false
		changingButton.toTrash(selector: #selector(rightButtonClicked(sender:)), in: self)
		let onDriveDataSource = OnDriveDataSource(models: addressModels)
		onDriveDataSource.viewController = self
		onDriveDataSource.response = response
		onDriveDataSource.pushClicked = ActionHandler.getSelectAddressClosure(in: self)
		onDriveDataSource.chatClicked = {
			let vc = ChatController()
			self.navigationController?.pushViewController(vc, animated: true)
		}
		self.mapInteractorManager.clearMarkers(of: .nearCar)
		
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
		searchCarView?.isHidden = false

		menuButton.isHidden = true
		addressView?.isHidden = true
		changingButton.toTrash(selector: #selector(rightButtonClicked(sender:)), in: self)
		self.mapInteractorManager.clearMarkers(of: .nearCar)
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
		menuButton.isHidden = true
		addressView?.isHidden = true
		searchCarView?.isHidden = false
		changingButton.toTrash(selector: #selector(rightButtonClicked(sender:)), in: self)
		let searchCarDataSource = SearchCarDataSource(models: addressModels)
		searchCarDataSource.viewController = self
		searchCarDataSource.pushClicked = ActionHandler.getSelectAddressClosure(in: self)
		selectedDataSource = searchCarDataSource
		searchCarDataSource.scrollViewScrolled = ActionHandler.scrollViewScrolled(in: self)
		searchCarDataSource.scrollViewDragged = ActionHandler.scrollViewDragged(in: self)
		
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
		
		let resLat = Double(addressModels.first?.response?.lat ?? "") ?? 0
		let resLng = Double(addressModels.first?.response?.lon ?? "") ?? 0
		
		if !mapView.isPulcing && resLng != 0 && resLat != 0 {
			let coordinate = CLLocationCoordinate2D(latitude: resLat, longitude: resLng)
			mapView.startPulcing(at: coordinate)
		}
	}
	
	var driverMarker: GMSMarker?
	var sourceMarker: GMSMarker?
	
	private func setOnWayDataSource(with response: CheckOrderModel? = nil) {
		mapView.stopPulcing()
		changingButton.toTrash(selector: #selector(rightButtonClicked(sender:)), in: self)
		addressView?.isHidden = true
		self.mapInteractorManager.clearMarkers(of: .nearCar)
		menuButton.isHidden = true
		searchCarView?.isHidden = false
		centerView.isHidden = true
		let driverOnWayDataSource = DriverOnWayDataSource(models: addressModels, response: response)
		driverOnWayDataSource.viewController = self
		driverOnWayDataSource.chatClicked = {
			let vc = ChatController()
			self.navigationController?.pushViewController(vc, animated: true)
		}
		driverOnWayDataSource.pushClicked = ActionHandler.getSelectAddressClosure(in: self)
		selectedDataSource = driverOnWayDataSource
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
		driverMarker?.icon = #imageLiteral(resourceName: "ic_standard_car_select").af_imageScaled(to: CGSize(width: 20, height: 33))
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
		updatePrevY()
		Toast.hide()
		refreshDelegates()
		tableView.reloadData()
		tableView.showsVerticalScrollIndicator = false
		viewDidLayoutSubviews()
		tableViewBottom.constant = 6
	}
	
	var isTableViewHiddenMannualy = false
	
	fileprivate func hideTableView(duration: TimeInterval = 0.2) {
		UIView.animate(withDuration: duration, animations: {
			self.tableViewBottom.constant = -(self.tableView.frame.height * 0.8)
			self.view.layoutIfNeeded()
		})
		
		if selectedDataSource is MainControllerDataSource {
			addressView?.show()
		}
	}

	fileprivate func showTableView() {
		UIView.animate(withDuration: 0.2, animations: {
			self.tableViewBottom.constant = 0
			self.view.layoutIfNeeded()
		})
		addressView?.hide()
	}
	
	private func setSourceAddress(response: NearStreetResponseModel?) {
		if let addressModel = Address.from(response: response), let responsed = response {
			self.addressModels.first(to: addressModel)
			AddressInteractor.shared.remind(addresses: [SearchAddressResponseModel.from(nearModel: responsed)])
			NewOrderDataProvider.shared.setSource(by: AddressModel.from(response: SearchAddressResponseModel.from(nearModel: responsed)))
			self.tableView.reloadData()
			self.isTableViewHiddenMannualy = false
			self.showTableView()
		}
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
	
	private func updatePoints() {
		for object in addressModels {
			object.pointName = points[addressModels.firstIndex{($0.pointName) == (object.pointName)}!]
		}
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
		updatePoints()
		tableView.insertRows(at: [indexPath], with: .bottom)
		tableView.reloadRows(at: [previousIndexPath], with: .automatic)
		prevY = tableView.frame.origin.y
	}
	
	fileprivate func removePoint(by index: Int) {
		addressModels.remove(at: index)
		updatePoints()
		tableView.reloadData()
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
		if !locationDragged && selectedDataSource is MainControllerDataSource {
			hideTableView()
			addressView?.show()
		}
		locationDragged = true

		guard let _ = selectedDataSource as? MainControllerDataSource else {
			return
		}
		
		let center = mapView.center
		addressView?.startLoading()
		let coordinate = mapView.projection.coordinate(for: center)
		let tarriffId = NewOrderDataProvider.shared.request.tarif ?? ""
		self.centerView.clearTime()
		OrderManager.shared.getNearCar(tariff_id: tarriffId, location: coordinate, with: {
			nearCars in
			self.mapInteractorManager.clearMarkers(of: .nearCar)
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
				self.addressView?.stopLoading()
			}
			
			guard let _ = self.selectedDataSource as? MainControllerDataSource else {
				return
			}
			
			guard response?.FullName ?? "" != self.addressModels[0].address else {
				return
			}
			
			Toast.show(with: response?.FullName ?? "", completion: {
				self.setSourceAddress(response: response)
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
extension MainController {
	func reupdateOrder() {
		if (NewOrderDataProvider.shared.request.destination?.count ?? 0) > 0 {
			NewOrderDataProvider.shared.precalculate()
		}
	}
}
extension MainController: LocationInteractorDelegate {
	func didUpdateLocations(locations: [CLLocation]) {
		if !isMyLocationInitialized {
			// first time animate
			if let coordinate = locations.first {
				mapView.animate(toLocation: coordinate.coordinate)
				mapView.animate(toZoom: 16)
				
				AddressManager.shared.findNearStreet(location: coordinate.coordinate, closure: { (model) in
					self.setSourceAddress(response: model)
				})
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
		searchCarView?.set(text: orderResponse?.statuscomment)
		switch orderResponse?.status ?? "" {
		case "Published":
			set(dataSource: .search, with: orderResponse)
		case "CarOnTheWayToPassenger":
			self.hideAcceptView()
			set(dataSource: .onTheWay, with: orderResponse)
		case "CabWaitingForPassenger":
			self.hideAcceptView()
			set(dataSource: .waitingForPassenger, with: orderResponse)
		case "PassengerInCab":
			self.hideAcceptView()
			set(dataSource: .pasengerInCab, with: orderResponse)
		case "Completed":
			self.hideAcceptView()
			self.clear(with: orderResponse)
		default: break
		}
		
	}
	
	func orderChanged(with orderResponse: CheckOrderModel?) {
		
		switch orderResponse?.status ?? "" {
		case "Published":
			self.mapInteractorManager.clearMarkers(of: .address)
			mapInteractorManager.show(addressModels.map { AddressMarker.init(address: $0) })
		case "CarOnTheWayToPassenger":
			let lat = orderResponse?.lat ?? 0
			let lng = orderResponse?.lon ?? 0
			
			let coordinate = CLLocationCoordinate2D.init(latitude: lat, longitude: lng)
			setDriverMarker(at: coordinate)
			mapView.animate(toLocation: coordinate)
			mapView.animate(toZoom: 16)
			self.mapInteractorManager.clearMarkers(of: .address)
			mapInteractorManager.show(addressModels.map { AddressMarker.init(address: $0) })
		case "CabWaitingForPassenger":
			self.mapInteractorManager.clearMarkers(of: .address)
			mapInteractorManager.show(addressModels.map { AddressMarker.init(address: $0) })
		case "PassengerInCab":
			self.mapInteractorManager.clearMarkers(of: .address)
			mapInteractorManager.show(addressModels.map { AddressMarker.init(address: $0) })
		case "Completed":
			self.mapInteractorManager.clearMarkers(of: .address)
			mapInteractorManager.show(addressModels.map { AddressMarker.init(address: $0) })
		default:
			mapInteractorManager.clearMarkers(of: .address)
		}
		SoundInteractor.playDefault()
	}
	
	func driverOffered(with orderResponse: CheckOrderModel?) {
		let offers = orderResponse?.offer_drivers ?? []
		guard let firstOffer = offers.first else {
			return
		}
		
		showAcceptView()
		acceptView?.configure(by: firstOffer)
	}
}

extension MainController: NewOrderDataProviderObserver {
	func precalculated() {
		tableView.reload(row: 0)
	}
	
	func requestStarted() {
		startLoading()
	}
	
	func requestEnded() {
		endLoading()
	}
	
	func requestChanged() {
		reupdateOrder()
	}
}

extension MainController {
	class ActionHandler {
		static func scrollViewScrolled(in vc: MainController) -> ItemClosure<UIScrollView> {
			
			let handler: ItemClosure<UIScrollView> = { scrollView in
				guard !KeyboardInteractor.shared.isShowed else {
					return
				}
				
				let condition = (vc.tableView.frame.origin.y - scrollView.contentOffset.y) > vc.prevY
				
				if condition {
					vc.tableView.frame.origin.y -= scrollView.contentOffset.y
				} else if vc.tableView.frame.origin.y <= vc.prevY + 1 {
					vc.tableView.contentOffset = CGPoint.zero
				}
			}
			
			return handler
		}
		
		static func scrollViewDragged(in vc: MainController) -> ItemClosure<UIScrollView> {
			let handler: ItemClosure<UIScrollView> = { scrollView in
				guard !KeyboardInteractor.shared.isShowed else {
					return
				}
				
				let isOnFirstHalf: Bool = {
					return abs(vc.prevY - scrollView.frame.origin.y) < scrollView.frame.height * 0.55
				}()
				
				isOnFirstHalf ? vc.showTableView() : vc.hideTableView()
				if !isOnFirstHalf {
					vc.isTableViewHiddenMannualy = true
				} else {
					vc.isTableViewHiddenMannualy = false
				}
			}
			return handler
		}
		
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
		
		static func addTargets(in mainVc: MainController) {
			mainVc.menuButton.addTarget(mainVc, action: #selector(mainVc.menuButtonClicked), for: .touchUpInside)
		}
	}
}

