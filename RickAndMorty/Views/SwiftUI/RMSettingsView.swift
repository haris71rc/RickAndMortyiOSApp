//
//  RMSettingsView.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 16/07/24.
//

import SwiftUI

struct RMSettingsView: View {
    let viewModel: RMSettingsViewViewModel
    init(viewModel: RMSettingsViewViewModel){
        self.viewModel = viewModel
    }
    var body: some View {
        List(viewModel.cellViewModels) { viewModel in
            HStack{
                if let image = viewModel.image{
                    Image(uiImage:image)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25,height: 25)
                    //.foregroundColor(Color.red)
                        .padding(10)
                        .background(Color(uiColor: viewModel.iconContainerColor))
                        .cornerRadius(6)
                }
                Text(viewModel.title)
                    .padding(.leading,10)
                Spacer()
            }
            .padding(.bottom,3)
            .onTapGesture {
                viewModel.onTapHandler(viewModel.type)
            }
        }
    }
}

#Preview {
    RMSettingsView(viewModel: .init(cellViewModels: RMSettingsOption.allCases.compactMap({
        return RMSettingsCellViewModel(type: $0) { options in
            
        }
    })))
}
