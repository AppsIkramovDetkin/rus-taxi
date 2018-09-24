//
//  Extensions+GMSMapView.swift
//  RusTaxi
//
//  Created by Danil Detkin on 24/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import GoogleMaps

extension GMSMapView {
	func startPulcing(at coordinate: CLLocationCoordinate2D) {
		let m = GMSMarker(position: self.camera.target)
		
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
			m.iconView?.layer.add(animation, forKey: "opacity")
		})
		
		CATransaction.commit()
		m.iconView = pulseRingImg
		m.layer.addSublayer(pulseRingImg.layer)
		m.map = self
		m.groundAnchor = CGPoint(x: 0.5, y: 0.5)
	}
}
