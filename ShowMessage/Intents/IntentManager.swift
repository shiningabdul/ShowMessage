//
//  IntentManager.swift
//  ShowMessage
//
//  Created by Abdul Aljebouri on 2018-10-07.
//  Copyright © 2018 shiningdevelopers. All rights reserved.
//

import Foundation
import Intents

class IntentManager {
    static let shared = IntentManager()
    
    func intent(withMessage message:String) -> ShowMessageIntent {
        let intent = ShowMessageIntent()
        intent.message = message
        return intent
    }

    func donateShortcuts(withIntent intent:INIntent) {
        var relevantShortcuts:[INRelevantShortcut] = []
        
        if let relevantShortcut = defaultRelevantShortcut(withIntent: intent) {
            relevantShortcuts.append(relevantShortcut)
        }
        
        INRelevantShortcutStore.default.setRelevantShortcuts(relevantShortcuts) { (error) in
            if let error = error {
                print("Failed to set relevant shortcuts: \(error))")
            } else {
                print("Relevant shortcuts set.")
            }
        }
    }
    
    private func defaultRelevantShortcut(withIntent intent: INIntent) -> INRelevantShortcut? {
        if let shortcut = INShortcut(intent: intent) {
            let relevantShortcut = INRelevantShortcut(shortcut: shortcut)
            // There are two roles: information and action
            // Information is meant just to show glancable information
            // Action is meant for the user to take an action from the Siri Watch Face
            relevantShortcut.shortcutRole = .information
            // If relevance providers are not set, Siri will determine the appropriate
            // time and location to show the user the shortcuts
            // relevantShortcut.relevanceProviders = []
            return relevantShortcut
        }
        
        return nil
    }
    
    /*
     * INDateRelevanceProvider can be used to let Siri know a period of time when your
     * shortcut is relevant to the user. It can take a start date and an optional end date.
     * If an end date is passed, the shortcut will disappear from the watch face after
     * that date passes.
     * Siri tends to move the shortcut out of view into recent after a period of time from
     * the start date.
     * Good usage would be for a weather app where it will rain between 1PM and 3PM but
     * the information is no longer useful after 3PM.
     */
    private func dateRelevanceProvider() -> INDateRelevanceProvider {
        let start = Date()
        let end = start.addingTimeInterval(60)
        return INDateRelevanceProvider(start: start, end: end)
    }
    
    /*
     * INLocationRelevanceProvider can be used to let Siri know a location where your
     * shortcut is relevant to the user. It takes a region.
     * Good usage would be for a meetup app to show instructions for checking in
     * once you get to your meetup location.
     */
    private func locationRelevanceProvider() -> INLocationRelevanceProvider {
        let title = "Apple Store Vancouver"
        let latitude = 49.283375
        let longitude = -123.117592
        let regionRadius = 50.0 // metres
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude,
                                                                     longitude: longitude), radius: regionRadius, identifier: title)
        return INLocationRelevanceProvider(region: region)
    }
    
    /*
     * INDailyRoutineRelevanceProvider can be used to let Siri show your shortcut
     * corresponding to a routine the user always has: when they are at work, their morning,
     * or when they get to their gym.
     * Good usage would be for a language learning application to show word of the day
     * at night for the user to review at night during their downtime.
     */
    private func routineRelevanceProvider() -> INDailyRoutineRelevanceProvider {
        return INDailyRoutineRelevanceProvider(situation: .evening)
    }
}
