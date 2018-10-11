//
//  Extensions+GMSMapView.swift
//  RusTaxi
//
//  Created by Danil Detkin on 24/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import GoogleMaps

// костыль, не трогай
fileprivate class GMSMARK {
	static var m: GMSMarker?
}

extension GMSMapView {
	func stopPulcing() {
		GMSMARK.m?.map = nil
		GMSMARK.m = nil
	}
	
	func fit(markers: [GMSMarker]) {
		var bounds = GMSCoordinateBounds()
		for marker in markers {
			bounds = bounds.includingCoordinate(marker.position)
		}
		animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsets.insets(with: 50)))
	}
	
	var isPulcing: Bool {
		return GMSMARK.m != nil
	}
	
	func startPulcing(at coordinate: CLLocationCoordinate2D) {
		GMSMARK.m = GMSMarker(position: self.camera.target)
		
		let sizeValue: CGFloat = 156
		let pulseRingImg = UIImageView(frame: CGRect(x: 0, y: 0, width: sizeValue, height: sizeValue))
		pulseRingImg.contentMode = .scaleAspectFit
		pulseRingImg.alpha = 0.1
		pulseRingImg.image = UIImage(named: "Pulse")
		pulseRingImg.isUserInteractionEnabled = false
		CATransaction.begin()
		CATransaction.setAnimationDuration(3)
		
		//transform scale animation
		var theAnimation: CABasicAnimation?
		theAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
		theAnimation?.repeatCount = Float.infinity
		theAnimation?.autoreverses = false
		theAnimation?.fromValue = Float(0.0)
		theAnimation?.toValue = Float(2.0)
		theAnimation?.isRemovedOnCompletion = false
		
		pulseRingImg.layer.add(theAnimation!, forKey: "pulse")
		pulseRingImg.isUserInteractionEnabled = false
		CATransaction.setCompletionBlock({() -> Void in
			
			//alpha Animation for the image
			let animation = CAKeyframeAnimation(keyPath: "opacity")
			animation.duration = 3
			animation.repeatCount = Float.infinity
			animation.values = [Float(2.0), Float(0.0)]
			GMSMARK.m?.iconView?.layer.add(animation, forKey: "opacity")
		})
		
		CATransaction.commit()
		GMSMARK.m?.iconView = pulseRingImg
		GMSMARK.m?.layer.addSublayer(pulseRingImg.layer)
		GMSMARK.m?.map = self
		GMSMARK.m?.groundAnchor = CGPoint(x: 0.5, y: 0.5)
	}
}
