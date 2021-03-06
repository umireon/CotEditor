/*
 
 ServicesProvider.swift
 
 CotEditor
 https://coteditor.com
 
 Created by 1024jp on 2016-06-23.
 
 ------------------------------------------------------------------------------
 
 © 2015-2016 1024jp
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 https://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
 */

import Cocoa

final class ServicesProvider: NSObject {
    
    // MARK: Public Methods
    
    /// open new document with string via Services
    func openSelection(_ pboard: NSPasteboard, userData: String, error: AutoreleasingUnsafeMutablePointer<NSString?>) {
        
        guard let selection = pboard.string(forType: NSPasteboardTypeString) else { return }
        
        let document: NSDocument
        do {
            document = try NSDocumentController.shared().openUntitledDocumentAndDisplay(false)
            
        } catch let error {
            NSApp.presentError(error)
            return
        }
        
        if let document = document as? Document {
            document.textStorage.replaceCharacters(in: NSRange(location: 0, length: 0), with: selection)
            document.makeWindowControllers()
            document.showWindows()
        }
    }
    
    
    /// open files via Services
    func openFile(_ pboard: NSPasteboard, userData: String, error: AutoreleasingUnsafeMutablePointer<NSString?>) {
        
        guard let paths = pboard.propertyList(forType: NSFilenamesPboardType) as? [String] else { return }
        
        for path in paths {
            let fileURL = URL(fileURLWithPath: path)
            
            NSDocumentController.shared().openDocument(withContentsOf: fileURL, display: true) { (document: NSDocument?, documentWasAlreadyOpen: Bool, error: Error?) in
                if let error = error {
                    NSApp.presentError(error)
                }
            }
        }
    }
    
}
