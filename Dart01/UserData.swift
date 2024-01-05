//
//  UserData.swift
//  Dart01
//
//  Created by Eric Patterson on 1/5/24.
//

import SwiftUI

@MainActor class UserData: ObservableObject {
    @Published var games: [Game] = []
    
    static var orientation = UIDeviceOrientation.portrait

    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("scrums.data")
    }


    func load() async throws {
        let task = Task<[Game], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let dailyScrums = try JSONDecoder().decode([Game].self, from: data)
            return dailyScrums
        }
        let games = try await task.value
        self.games = games
    }


    func save(games: [Game]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(games)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
}
