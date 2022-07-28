//
//  SwiftUIToDoView.swift
//  SwiftUI_To_Do_App
//
//  Created by Faiz Ul Hassan on 28/07/2022.
//

import SwiftUI

struct SwiftUIToDoView: View {
    
    @State private var newTodo = ""
    @State private var allTodos:[TodoItem] = []
    private let todosKey = "todosKey"
    
    var body: some View {
        
        NavigationView{
            
            VStack{
                
                HStack{
                    TextField("Add todo...", text: $newTodo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button {
                        guard !self.newTodo.isEmpty else{return}
                        self.allTodos.append(TodoItem(todo: newTodo))
                        newTodo = ""
                        saveTodos()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .padding(.leading, 5)
                    
                }
                .padding()
                
                List{
                    ForEach(allTodos.indices,id: \.self){ index in
                        if #available(iOS 15.0, *) {
                            Text(allTodos[index].todo)
                                .foregroundColor(Color.black)
                                .swipeActions(allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        print("Deleting conversation")
                                        
                                        self.allTodos.remove(at: index)
                                        
                                    } label: {
                                        Label("Delete", systemImage: "trash.fill")
                                    }
                                    .tint(.green)
                                    
                                    Button {
                                        print("Muting conversation")
                                    } label: {
                                        Label("Mute", systemImage: "bell.slash.fill")
                                    }
                                    .tint(.indigo)
                                    
                                }
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    .onDelete(perform: deleteTodo(at:))
                    .onMove {indexSet, index in
                        allTodos.move(fromOffsets: indexSet, toOffset: index)
                    }
                    
                }
                
            }
            .navigationTitle("Todos")
            
        }
        .onAppear(perform: loadTodos)
        
    }
    
    private func deleteTodo(at offsets: IndexSet) {
        self.allTodos.remove(atOffsets: offsets)
        saveTodos()
    }
    
    private func saveTodos() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.allTodos), forKey: todosKey)
    }
    
    private func loadTodos() {
        if let todosData = UserDefaults.standard.value(forKey: todosKey) as? Data {
            if let todosList = try? PropertyListDecoder().decode(Array<TodoItem>.self, from: todosData) {
                self.allTodos = todosList
            }
        }
    }
    
}

struct SwiftUIToDoView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIToDoView()
    }
}


struct TodoItem: Identifiable ,Encodable , Decodable{
    let id = UUID()
    let todo: String
}
