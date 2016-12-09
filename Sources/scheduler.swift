//
//  scheduler.swift
//  leds
//
//  Created by Roberto Previdi on 23/11/16.
//
//

import Foundation
import RxSwift

struct ActionRunnerRelative<StateType>{
	var thread:PosixThread?
	let cancel=SingleAssignmentDisposable()
	let action: (StateType) -> Disposable
	let state: StateType
	init(action: @escaping (StateType) -> Disposable,state: StateType)
	{
		self.action=action
		self.state=state
	}
	private func _runInThread() {
		if cancel.isDisposed {return}
		cancel.setDisposable(action(state))
	}
	mutating func run(){
		self.thread=try! PosixThread(_runInThread)
	}
	mutating func run(timer:Timer){
		run()
	}
	
}
class ActionRunnerPeriodic<StateType>{
	var thread:PosixThread?
	let cancel=SingleAssignmentDisposable()
	let action: (StateType) -> StateType
	var state: StateType
	init(action: @escaping (StateType) -> StateType,state: StateType)
	{
		self.action=action
		self.state=state
	}
	private func _runInThread() {
		if cancel.isDisposed {return}
		state=action(state)
	}
	func run(){
		self.thread=try! PosixThread(_runInThread)
	}
	func run(timer:Timer){
		run()
	}
	
}

class ThreadScheduler: SchedulerType {

	
	public var now: Date { return Date() }

	init(){}
	
	public final func schedule<StateType>(_ state: StateType, action: @escaping (StateType) -> Disposable) -> Disposable {
		var ar=ActionRunnerRelative<StateType>(action:action,state:state)
		ar.run()
		return ar.cancel
	}
	
	func scheduleRelative<StateType>(_ state: StateType, dueTime: Foundation.TimeInterval, action: @escaping (StateType) -> Disposable) -> Disposable {
		var ar=ActionRunnerRelative<StateType>(action:action,state:state)
		let timer=Timer.scheduledTimer(withTimeInterval:dueTime,repeats:false) {
			timer in
			ar.run(timer:timer)
		}
		RunLoop.current.add(timer,forMode:.defaultRunLoopMode)
		return ar.cancel
	}
	
	func schedulePeriodic<StateType>(_ state: StateType, startAfter: TimeInterval, period: TimeInterval, action: @escaping (StateType) -> StateType) -> Disposable {
		let ar=ActionRunnerPeriodic<StateType>(action:action,state:state)
		let fireDate=Date(timeIntervalSinceNow:startAfter)
		let timer=Timer(fire:fireDate,interval:period,repeats:true) {
			timer in
			ar.run(timer:timer)
		}
		RunLoop.current.add(timer,forMode:.defaultRunLoopMode)
		return ar.cancel
	}
}
