//
//  ViewFactoryProtocol.swift
//  SwiftUIVoyage
//
//  Created by Miguel Vieira on 9/11/25.
//

import SwiftUI

@MainActor
public protocol ViewFactoryProtocol {
    associatedtype SomeView: View
    associatedtype SomeScreen: Hashable
    
    @ViewBuilder func view(for screen: SomeScreen, navigator: any NavigatorProtocol<SomeScreen>) -> SomeView
}
