//
//  testview.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 06/01/2022.
//

import SwiftUI

struct testview: View {
    @ObservedObject var inboxvm = InboxVM.shared
    var body: some View {
        ForEach(0..<inboxvm.applications.count, id: \.self){x in
            ForEach(0..<inboxvm.applications[x].count, id: \.self){y in
             //   if inboxvm.applications[x][y].comakershipId == comakership.id{
                    Text("Members")
                        .font(.headline)
                        .padding()
                    Text(inboxvm.applications[x][y].team.name)
                    Text(" count: \(inboxvm.applications[x][y].team.members.count)")
                    
                    ForEach(inboxvm.applications[x][y].team.members){mem in
                        //Text("\(inboxvm.applications[x][y].team.members[mem].name) - \(inboxvm.applications[x][y].team.members[mem].email)")
                    }
                //}
            }
        }
    }
}

struct testview_Previews: PreviewProvider {
    static var previews: some View {
        testview()
    }
}
