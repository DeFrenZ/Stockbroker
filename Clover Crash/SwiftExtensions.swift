//
//  SwiftExtensions.swift
//  Clover Crash
//
//  Created by Davide De Franceschi on 05/12/2015.
//  Copyright © 2015 Boppl Ltd. All rights reserved.
//

import Swift



//MARK: - ??=
infix operator ??= {
	associativity right
	precedence 90
	assignment
}
func ??= <Wrapped> (inout optional: Wrapped?, @autoclosure defaultValue: () throws -> Wrapped?) rethrows {
	optional = try optional ?? defaultValue()
}

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

//MARK: |>
infix operator |> {
	associativity left
}
public func |> <Input, Output>(lhs: Input, rhs: Input throws -> Output) rethrows -> Output {
	return try rhs(lhs)
}

//MARK: - Indexable
extension Indexable {
	public subscript(safe safeIndex: Index) -> _Element? {
		return safeIndex.distanceTo(endIndex) > 0 ? self[safeIndex] : nil
	}
}

//MARK: - Globals
func clamp<T: Comparable>(value: T, minimum: T, maximum: T) -> T {
	return max(min(value, maximum), minimum)
}
