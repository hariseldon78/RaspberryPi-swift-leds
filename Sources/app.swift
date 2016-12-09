//
//  app.swift
//  leds
//
//  Created by Roberto Previdi on 22/11/16.
//
//

import Foundation
import RxSwift
import SwiftyGPIO
import Glibc

//func button(pin:GPIO) -> Observable<Bool>
//{
//	return Observable.create { observer in
//		
//}

func invert(pin:GPIO){
	let b=Bool(pin.value)
	pin.value = Int(!b)
}
let 🗑=DisposeBag()

func app(){
	let gpios = SwiftyGPIO.GPIOs(for: .RaspberryPi2)
	guard let led0=gpios[.P2],
		let led1=gpios[.P3],
		let btn0=gpios[.P4]
		else {
			fatalError("It has not been possible to initialised the LED GPIO pin")
	}
	[led0,led1].forEach {
		$0.direction = .OUT
	}
	[btn0].forEach {
		$0.direction = .IN
	}
	print("gpios ok")
	
	Observable<Int>.interval(0.5, scheduler:ThreadScheduler())
		.subscribe (onNext:{_ in
			print("this is in a background thread")
			invert(pin:led0)
		}).addDisposableTo(🗑)
	
	Observable<Int>.interval(0.1, scheduler:MainScheduler.instance)
		.subscribe (onNext:{_ in
			print("this is in the main thread")
			invert(pin:led1)
		}).addDisposableTo(🗑)
	

}
