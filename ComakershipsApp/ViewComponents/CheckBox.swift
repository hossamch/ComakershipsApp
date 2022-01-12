//
//  CheckBox.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 29/12/2021.
//

import SwiftUI

struct CheckBox: View {
    @Binding var checked: Bool

    var body: some View {
        Image(systemName: checked ? "checkmark.square.fill" : "square")
            .foregroundColor(checked ? Color(UIColor.systemBlue) : Color.secondary)
            .onTapGesture {
                self.checked.toggle()
            }
    }
}

struct CheckBox_Previews: PreviewProvider {
    struct CheckBoxViewHolder: View {
        @State var checked = false

        var body: some View {
            CheckBox(checked: $checked)
        }
    }

    static var previews: some View {
        CheckBoxViewHolder()
    }
}
