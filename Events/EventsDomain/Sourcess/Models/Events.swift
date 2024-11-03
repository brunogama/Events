//
//  Events.swift
//  EventsPackage
//
//  Created by Bruno on 02/11/24.
//

package enum Events {
    case startProcessing
    case loading
    case willUpdateState(DeviceState)
    case stateUpdated(DeviceState)
    case currentState(DeviceState)
    case error(Error)
}
