//
//  NSAlert+Extension.swift
//  Seaships Battle
//
//  Created by Анастасія Пензій on 21.05.2023.
//

import Cocoa

extension NSAlert {
    public static func showAlert(
        title: String,
        message: String,
        okButtonName: String = "OK",
        completion: (Bool) -> Void
    ) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.addButton(withTitle: okButtonName)
        alert.alertStyle = .warning
        completion(alert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn)
    }
}
