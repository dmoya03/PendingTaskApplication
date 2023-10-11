//
//  ContentView.swift
//  Pending
//
//  Created by Daniel Moya on 18/8/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var newTask = ""
    @State private var allTasks : [TaskItem] = []
    private let tasksKey = "tasksKey"
    
    var body: some View {
        NavigationView {
            VStack {
                HStack{
                    TextField("Add task", text: $newTask).textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        guard !self.newTask.isEmpty else {return}
                        self.allTasks.append(TaskItem(todo: self.newTask))
                        self.newTask = ""
                        self.saveTasks()
                    }){
                        Image(systemName: "plus")
                    }.padding(.leading, 5)
                }.padding()
                List {
                    ForEach(allTasks.reversed()){ todoItem in
                        Text(todoItem.todo)
                    }.onDelete(perform: deleteTasks)
                }
            }.navigationBarTitle("Pending tasks")
        }.onAppear(perform: loadTasks)
    }
     
    private func deleteTasks(at offsets: IndexSet){
        self.allTasks.remove(atOffsets: offsets)
        saveTasks()
    }
    private func loadTasks(){
        if let tasksData = UserDefaults.standard.value(forKey: tasksKey) as? Data {
            if let tasksList = try? PropertyListDecoder().decode(Array<TaskItem>.self, from: tasksData){
                self.allTasks = tasksList
            }
        }
    }

    private func saveTasks(){
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.allTasks), forKey: tasksKey)
    }
}

struct TaskItem : Codable, Identifiable {
    var id = UUID()
    let todo : String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
