//
//  MenuView.swift
//  Test
//
//  Created by Janek on 22/04/2021.
//

import SwiftUI
import SceneKit

struct MenuView: View {
    
    @ObservedObject var view_model = MenuViewModel()
    
    
    var body: some View {
        VStack{
            Group{
                LabeledDivider(label: "Shape", font_size: 14, horizontal_padding: 5).padding(.top, 5)
                view_model.model.shape_buttons_view
                LabeledDivider(label: "Properties", font_size: 14, horizontal_padding: 5).padding(.vertical, 5)
                view_model.model.position_properties_view
                view_model.model.size_view
                view_model.model.pyramid_view
                view_model.model.other_view
            }
            
            Spacer()
            
            Button(action: {view_model.createObstacle()}){
                Text("Add object")
            }
            .disabled(view_model.disable_add_button)
            
            Button(action: {view_model.menu_delegate?.deleteSelectedObject()}){
                Text("Delete object")
            }.padding(.bottom, 100)
            .disabled(view_model.disable_delete_button)
        }.frame(width: 250)
        .onAppear {
            view_model.onAppear()
        }
    }
}

//struct MenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuView()
//    }
//}
