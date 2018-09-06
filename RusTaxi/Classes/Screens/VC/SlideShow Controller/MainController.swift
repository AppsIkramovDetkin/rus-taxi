//
//  MainController.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 31.08.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotationView: MKAnnotationView {
	var label: UILabel?
	
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}

class MainController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var tableView: UITableView!
	private let points = ["A", "B", "C", "D"]
	private var locationManager = CLLocationManager()
	private var address: String = ""
	private var addressModels: [Address] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		initializeMapView()
		initializeLocationManager()
		initializeTableView()
		registerNibs()
		initializeFirstAddressCells()
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
		tableView.delegate = self
		tableView.dataSource = self
		tableView.isScrollEnabled = true
	}
	
	private func registerNibs() {
		tableView.register(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: "headCell")
		tableView.register(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "settingsCell")
		tableView.register(AddressCell.nib, forCellReuseIdentifier: "addressCell")
	}
	
	@objc func actionButtonAddClicked() {
		insertNewCells()
	}
	
	private func insertNewCells() {
		guard addressModels.count < points.count else {
			return
		}
		
		addPoint(by: Address.init(pointName: points[addressModels.count]))
	}
	
	@objc func currentLocationClicked() {
		locationManager.startUpdatingLocation()
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let location = locations[0]
		let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
		let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
		let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
		mapView.setRegion(region, animated: true)
		
		let annotation = MKPointAnnotation()
		annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
		annotation.title = "1 мин."
		mapView.addAnnotation(annotation)
		locationManager.stopUpdatingLocation()
		
		print(location.altitude)
		print(location.speed)
	}
	
	func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
		mapView.centerCoordinate = userLocation.location!.coordinate
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		let annotationIdentifier = "MyCustomAnnotation"
		guard !annotation.isKind(of: MKUserLocation.self) else {
			return nil
		}
		var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
		if annotationView == nil {
			annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
			if case let annotationView as CustomAnnotationView = annotationView {
				annotationView.isEnabled = true
				annotationView.canShowCallout = false
				annotationView.label = UILabel(frame: CGRect(x: -5.5, y: 11.0, width: 22.0, height: 16.5))
				annotationView.tintColor = TaxiColor.orange
				if let label = annotationView.label {
					label.font = UIFont(name: "HelveticaNeue", size: 16.0)
					label.textAlignment = .center
					label.textColor = TaxiColor.black
					label.adjustsFontSizeToFitWidth = true
					annotationView.addSubview(label)
				}
			}
		}
		
		if case let annotationView as CustomAnnotationView = annotationView {
			annotationView.annotation = annotation
			if let title = annotation.title,
				let label = annotationView.label {
				label.text = title
			}
		}
		return annotationView
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
				if (error != nil)
				{
					print("reverse geodcode fail: \(error!.localizedDescription)")
				}
				let pm = placemarks! as [CLPlacemark]
				if pm.count > 0 {
					let pm = placemarks![0]
					var addressString : String = ""
					var countryString: String = ""
					if pm.thoroughfare != nil {
						addressString = addressString + pm.thoroughfare! + ", "
					}
					
					if pm.subThoroughfare != nil {
						addressString = addressString + pm.subThoroughfare!
					}
					
					if pm.locality != nil {
						countryString = countryString + pm.locality! + ", "
					}

					if pm.country != nil {
						countryString = countryString + pm.country! + " "
					}
					
					self.addressModels[0].address = addressString
					self.addressModels[0].country = countryString
					self.tableView.reloadData()
					print(addressString)
				}
		})
	}
	
	fileprivate func addPoint(by model: Address) {
		guard addressModels.count < points.count else {
			return
		}
		let ip = IndexPath.init(row: addressModels.count + 1, section: 0)
		addressModels.append(model)
		tableView.insertRows(at: [ip], with: .automatic)
	}
}

extension MainController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "headCell", for: indexPath) as! HeaderCell
			cell.myPositionButton.addTarget(self, action: #selector(currentLocationClicked), for: .touchUpInside)
			return cell
		} else if indexPath.row > 0 && indexPath.row <= addressModels.count {
			let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! AddressCell
			cell.configure(by: addressModels[indexPath.row - 1])
			if indexPath.row == 1 {
				cell.topLineView.isHidden = true
				cell.actionButton.isHidden = true
			}
			
			if indexPath.row == 2 {
				cell.actionButton.setImage(#imageLiteral(resourceName: "ic_menu_add"), for: .normal)
				cell.actionButton.addTarget(self, action: #selector(actionButtonAddClicked), for: .touchUpInside)
			}
			
			if indexPath.row == 3 {
				cell.actionButton.setImage(#imageLiteral(resourceName: "ic_menu_delete"), for: .normal)
			}
			
			if indexPath.row == 4 {
				cell.actionButton.setImage(#imageLiteral(resourceName: "ic_menu_delete"), for: .normal)
				cell.botLineView.isHidden = true
			}
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsCell
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 0 {
			return 45
		} else if indexPath.row > 0 && indexPath.row <= addressModels.count {
			return 63
		} else {
			return 121
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return addressModels.count + 2
	}
}
