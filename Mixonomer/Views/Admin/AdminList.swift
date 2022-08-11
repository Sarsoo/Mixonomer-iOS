//
//  AdminList.swift
//  Mixonomer
//
//  Created by Andy Pack on 11/08/2022.
//  Copyright © 2022 Sarsoo. All rights reserved.
//

import SwiftUI

struct AdminList: View {
    var body: some View {
        NavigationView {
            List{
                Section {
                    
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("Admin 🚨"))
        }
    }
}

struct AdminList_Previews: PreviewProvider {
    static var previews: some View {
        AdminList()
    }
}
