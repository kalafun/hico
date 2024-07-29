//
//  ZipManager.swift
//  Hico
//
//  Created by Tomas Bobko on 24.07.24.
//

import ZIPFoundation
import Foundation
import XMLCoder

class PackageManager {

    private init() { }
    static let shared = PackageManager()

    let fileManager = FileManager()
    var documentsDirectoryURL: URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    lazy var sourceURL: URL = {
        guard let bundleURL = Bundle.main.url(forResource: "HICO_MobileDuck", withExtension: "zip") else {
            fatalError("File not found in bundle")
        }
        return bundleURL
    }()

    lazy var destinationURL: URL = {
        var url = documentsDirectoryURL
        url.appendPathComponent("package")
        return url
    }()

    lazy var destinationInsideURL: URL = {
        destinationURL.appendingPathComponent("HICO_MobileDuck")
    }()

    lazy var structureURL: URL = {
        destinationInsideURL.appendingPathComponent("structure.xml")
    }()

    func documentURL(at path: String?) -> URL? {
        guard let path = path else { return nil }
        return destinationInsideURL.appendingPathComponent(path)
    }

    func unzipPackage() {
        do {
            // Check if destination directory exists and is empty
            if fileManager.fileExists(atPath: destinationURL.path) {
                let contents = try fileManager.contentsOfDirectory(atPath: destinationURL.path)
                if !contents.isEmpty {
                    // In case I want to remove extracted files
                    // try fileManager.removeItem(at: destinationURL)
                    print("Destination directory is not empty, skipping extraction")
                    return
                }
            } else {
                // Create destination directory if it does not exist
                try fileManager.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
            }

            // Unzip the package
            try fileManager.unzipItem(at: sourceURL, to: destinationURL)
            print("Package unzipped successfully")
        } catch {
            print("Extraction of ZIP archive failed with error: \(error)")
        }
    }

    func parsePackageContent() -> Content? {
        do {
            let data = try Data(contentsOf: PackageManager.shared.structureURL)
            let structure = try XMLDecoder().decode(Structure.self, from: data)
            print(structure.content)
            return structure.content
        } catch {
            print("error getting data representation from structure.xml")
        }

        return nil
    }

    func printExtractedFiles() {
        do {
            let directoryContents = try fileManager.contentsOfDirectory(
                at: destinationInsideURL,
                includingPropertiesForKeys: nil, options: []
            )
            for fileURL in directoryContents {
                print(fileURL.lastPathComponent)
            }
        } catch {
            print("Error reading contents of directory: \(error)")
        }
    }
}
