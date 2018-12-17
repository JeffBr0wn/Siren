//
//  VersionParser.swift
//  Siren
//
//  Created by Arthur Sabintsev on 11/25/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

struct VersionParser {
    /// Checks to see if the App Store version of the app is newer than the installed version.
    ///
    /// - Parameters:
    ///   - installedVersion: The installed version of the app.
    ///   - appStoreVersion: The App Store version of the app.
    /// - Returns: `true` if the App Store version is newer. Otherwise, `false`.
    static func isAppStoreVersionNewer(installedVersion: String?, appStoreVersion: String?) -> Bool {
        guard let installedVersion = installedVersion,
            let appStoreVersion = appStoreVersion,
            (installedVersion.compare(appStoreVersion, options: .numeric) == .orderedAscending) else {
                return false
        }

        return true
    }

    /// The type of update that is returned in relation to the verison of the app that is installed.
    ///
    /// - Parameters:
    ///   - installedVersion: The installed version of the app.
    ///   - appStoreVersion: The App Store version of the app.
    /// - Returns: The type of update in relation to the verison of the app that is installed.
    static func parse(installedVersion: String?, appStoreVersion: String?) -> RulesManager.UpdateType {
        guard let installedVersion = installedVersion,
            let appStoreVersion = appStoreVersion else {
                return .unknown
        }

        let oldVersion = split(version: installedVersion)
        let newVersion = split(version: appStoreVersion)

        guard let newVersionFirst = newVersion.first,
            let oldVersionFirst = oldVersion.first else {
            return .unknown
        }

        if newVersionFirst > oldVersionFirst { // A.b.c.d
            return .major
        } else if newVersion.count > 1 && (oldVersion.count <= 1 || newVersion[1] > oldVersion[1]) { // a.B.c.d
            return .minor
        } else if newVersion.count > 2 && (oldVersion.count <= 2 || newVersion[2] > oldVersion[2]) { // a.b.C.d
            return .patch
        } else if newVersion.count > 3 && (oldVersion.count <= 3 || newVersion[3] > oldVersion[3]) { // a.b.c.D
            return .revision
        } else {
            return .unknown
        }
    }

    /// Splits a version-formatted `String into an `[Int]`.
    ///
    /// Converts `"a.b.c.d"` into `[a, b, c, d]`.
    ///
    /// - Parameter version: The version formatted `String`.
    ///
    /// - Returns: An array of integers representing a version of the app.
    private static func split(version: String) -> [Int] {
        return version.lazy.split {$0 == "."}.map { String($0) }.map {Int($0) ?? 0}
    }
}
