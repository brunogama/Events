//
//  Action.swift
//  EventsModule
//
//  Created by Bruno on 02/11/24.
//

public enum Action: Sendable {
    case passIntro
    case passOnboarding
    case passDone
    case removeDevices(Devices)
    case starLiveness
    case smsToken(String)
    case emailToken(String)
}
