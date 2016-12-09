//
//  extensions.swift
//  leds
//
//  Created by Roberto Previdi on 22/11/16.
//
//

import Foundation

extension Bool {
	init(_ i:Int){
		if i==0 {
			self=false
		} else {
			self=true
		}
	}
}

extension Int {
	init(_ b:Bool){
		if b {
			self=1
		} else {
			self=0
		}
	}
}
