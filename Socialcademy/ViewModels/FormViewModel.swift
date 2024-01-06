//
//  FormViewModel.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 06/01/24.
//

import Foundation


@MainActor
@dynamicMemberLookup
// This function gets a generic value and makes a submition from forms. For signin in and for creating an account.
class FormViewModel<Value>: ObservableObject {
    typealias Action = (Value) async throws -> Void
    
    @Published var value: Value
    @Published var error: Error?
    
    subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> T {
        get { value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }
    
    private let action: Action
    
    init(initialValue: Value, action: @escaping Action) {
        self.value = initialValue
        self.action = action
    }
    
    nonisolated func submit() {
        Task {
            await handleSubmit()
        }
    }
    
    private func handleSubmit() async {
        do {
            try await action(value)
        } catch {
            print("[FormViewModel] Cannot submit: \(error)")
            self.error = error
        }
    }
}
