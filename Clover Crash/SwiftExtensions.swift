//
//  SwiftExtensions.swift
//  Clover Crash
//
//  Created by Davide De Franceschi on 05/12/2015.
//  Copyright © 2015 Boppl Ltd. All rights reserved.
//

import Swift



//MARK: - =??
infix operator =?? {
associativity right
precedence 90
assignment
}
func =?? <T> (inout value: T, assignedValue: T?) {
	if let assignedValue = assignedValue {
		value = assignedValue
	}
}

//MARK: - Indexable
extension Indexable {
	public subscript(safe safeIndex: Index) -> _Element? {
		return safeIndex.distanceTo(endIndex) > 0 ? self[safeIndex] : nil
	}
}
