//
//  MainController.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 31.08.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit
import MapKit

class MainController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var centerView: UIView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var tableViewHeight: NSLayoutConstraint!
	private var locationManager = CLLocationManager()
	private var addressModels: [Address] = [] {
		didSet {
			selectedDataSource?.update(with: addressModels)
		}
	}
	
	private var selectedDataSource: MainDataSource?

	override func viewDidLoad() {
		super.viewDidLoad()
		
		centerView.isHidden = true
		initializeMapView()
		initializeLocationManager()
		registerNibs()
		initializeFirstAddressCells()
		initializeActionButtons()
		initializeTableView()
		tableView.reloadData()
	}
	
	override func viewWillLayoutSubviews() {
		super.updateViewConstraints()
		
		self.tableViewHeight?.constant = self.tableView.contentSize.height
	}
	
	private func initializeActionButtons() {
		let startDataSource = MainControllerDataSource(models: addressModels)
		let onDriveDataSource = OnDriveDataSource(models: addressModels)
		let searchCarDataSource = SearchCarDataSource(models: addressModels)
		let driverOnWayDataSource = DriverOnWayDataSource(models: addressModels)
		startDataSource.actionAddClicked = {
			self.insertNewCells()
		}
		startDataSource.payTypeClicked = {
			PayAlertController.shared.showPayAlert(in: self) { (money, card) in }
		}
		startDataSource.deleteCellClicked = { view in
			guard let indexPath = self.tableView.indexPathForView(view: view) else {
				return
			}
			self.deleteCell(at: indexPath.row)
		}
		startDataSource.wishesClicked = {
			let vc = WishesController()
			self.navigationController?.pushViewController(vc, animated: true)
		}
		startDataSource.currentLocationClicked = {
			self.locationManager.startUpdatingLocation()
		}
		startDataSource.subviewsLayouted = {
			self.viewWillLayoutSubviews()
		}
		
		selectedDataSource = searchCarDataSource
	}
	
	private func initializeFirstAddressCells() {
		let address = Address(pointName: points[0])
		addPoint(by: address)
		let address1 = Address(pointName: points[1])
		addPoint(by: address1)
	}
	
	private func initializeLocationManager() {
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
	}
	
	private func initializeMapView() {
		mapView.delegate = self
		mapView.showsUserLocation = true
	}
	
	private func initializeTableView() {
		tableView.delegate = selectedDataSource
		tableView.dataSource = selectedDataSource
		tableView.isScrollEnabled = false
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
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let location = locations[0]
		let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
		let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
		let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
		mapView.setRegion(region, animated: true)
	}
	
	func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
		mapView.centerCoordinate = userLocation.location!.coordinate
		let myAnnotation: MKPointAnnotation = MKPointAnnotation()
		myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
		myAnnotation.title = "Current location"
		mapView.addAnnotation(myAnnotation)
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
	}
	
	fileprivate func removePoint(by index: Int) {
		let previousIndexPath = IndexPath.init(row: addressModels.count - 1, section: 0)
		let indexPath = IndexPath.init(row: addressModels.count, section: 0)
		addressModels.removeLast()
		tableView.deleteRows(at: [indexPath], with: .automatic)
		tableView.reloadRows(at: [previousIndexPath], with: .automatic)
	}
	
	func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
		var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
		let mapLatitude = mapView.centerCoordinate.latitude
		let mapLongtitude = mapView.centerCoordinate.longitude
		let ceo: CLGeocoder = CLGeocoder()
		center.latitude = mapLatitude
		center.longitude = mapLongtitude
		let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
		ceo.reverseGeocodeLocation(loc, completionHandler:
			{(placemarks, error) in
				if (error != nil) {
					self.showAlert(title: "Ошибка", message: "\(error!.localizedDescription)")
				}
				let placemarks = placemarks! as [CLPlacemark]
				if !placemarks.isEmpty {
					let placemarks = placemarks[0]
					var addressString : String = ""
					var countryString : String = ""
					
					if placemarks.thoroughfare != nil {
						addressString = addressString + placemarks.thoroughfare! + ", "
					}
					
					if placemarks.subThoroughfare != nil {
						addressString = addressString + placemarks.subThoroughfare!
					}
					
					if placemarks.locality != nil {
						countryString = countryString + placemarks.locality! + ", "
					}
					
					if placemarks.country != nil {
						countryString = countryString + placemarks.country! + " "
					}
					
					self.addressModels[0].address = addressString
					self.addressModels[0].country = countryString
					self.tableView.reloadData()
				}
		})
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		guard !(annotation is MKUserLocation) else {return nil }
		
		let annotationIdentifier = "restAnnotation"
		var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
		
		if annotationView == nil {
			annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
			annotationView?.canShowCallout = true
		}
		annotationView?.annotation = annotation
		annotationView?.image = #imageLiteral(resourceName: "pin")
		return annotationView
	}
}
