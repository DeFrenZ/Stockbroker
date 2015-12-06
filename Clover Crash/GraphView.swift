//
//  GraphView.swift
//  Clover Crash
//
//  Created by Davide De Franceschi on 06/12/2015.
//  Copyright © 2015 Boppl Ltd. All rights reserved.
//

import UIKit



final class GraphView: UIView {
	var dataPoints: [CGFloat] = [] {
		didSet { setNeedsDisplay() }
	}
	override func drawRect(rect: CGRect) {
		super.drawRect(rect)
		
		let maxDataPoints = 50
		let valueInterval: ClosedInterval<CGFloat> = -1 ... 1
		let drawPoints = dataPoints.enumerate().map({ index, value -> CGPoint in
			let x = CGFloat(index) / CGFloat(maxDataPoints) * self.bounds.width
			let y = (value - valueInterval.start) / (valueInterval.end - valueInterval.start) * self.bounds.height
			return CGPoint(x: x, y: y)
		})
		
		let path = UIBezierPath()
		path.moveToPoint(drawPoints[0])
		drawPoints.dropFirst().forEach {
			path.addLineToPoint($0)
		}
		
		tintColor.setStroke()
		path.stroke()
	}
}
