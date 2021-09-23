//
//  SizePropertiesView.swift
//  Test
//
//  Created by Janek on 22/04/2021.
//

import SwiftUI

struct SizePropertiesView: View {
    
    @ObservedObject var view_model : SizeViewModel
    
    var body: some View {
        VStack{
            LabeledDivider(label: "Size", font_size: 12, horizontal_padding: 5)
            HStack{
                VStack{
                    HStack{
                        Text("Width:")
                            .padding(.leading, 10)
                        TextField("Width",
                                  value: $view_model.size.width,
                                  formatter: view_model.formatter.number_formatter,
                                  onCommit: {view_model.delegate?.updateWidth(new_width: view_model.size.width)})
                            .disabled(view_model.size.disabled_startend)
                            .padding(.trailing, 10)
                    }
                    HStack{
                        Text("Height:")
                            .padding(.leading, 10)
                        TextField("Height",
                                  value: $view_model.size.height,
                                  formatter: view_model.formatter.number_formatter,
                                  onCommit: {view_model.delegate?.updateHeight(new_height: view_model.size.height)})
                            .disabled(view_model.size.disabled_startend)
                            .padding(.trailing, 10)
                    }
                    HStack{
                        Text("Length:")
                            .padding(.leading, 10)
                        TextField("Length",
                                  value: $view_model.size.length,
                                  formatter: view_model.formatter.number_formatter,
                                  onCommit: {view_model.delegate?.updateLength(new_length: view_model.size.length)})
                            .disabled(view_model.size.disabled_floor || view_model.size.disabled_startend)
                            .padding(.trailing, 10)
                    }
                }
            }.padding(2)
        }
    }
}

//struct SizePropertiesView_Previews: PreviewProvider {
//    static var previews: some View {
//        SizePropertiesView()
//    }
//}
