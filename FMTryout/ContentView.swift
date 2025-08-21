//
//  ContentView.swift
//  FMTryout
//
//  Created by RAJESH MURALIDHARAN on 7/1/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var prompt: String = ""
    @State private var instruction: String = ""
    
    let vm = FMTryoutViewModel()
    
    var body: some View {
        HStack {
            VStack {
                TextField("Instructions", text: $instruction, axis: .vertical)
                    .lineLimit(9)
                    .multilineTextAlignment(.leading)
                    .padding()
                HStack() {
                    Button("Initiate") {
                        vm.initiateSessionWith(instructions: instruction)
                    }
                    .padding()
                    
                    Button("Clear Instruction") {
                        instruction = ""
                        vm.clearInstruction()
                    }
                    .padding()
                }
                
                TextField("Prompt", text: $prompt, axis: .vertical)
                    .lineLimit(9)
                    .multilineTextAlignment(.leading)
                    .padding()
                HStack {
                    Button("Process") {
                        vm.processSync(prompt: prompt)
                    }
                    .disabled(prompt.isEmpty || vm.isResponding)
                    .padding()
                    
                    Button("Process Async") {
                        vm.process(prompt: prompt)
                    }
                    .disabled(prompt.isEmpty || vm.isResponding)
                    .padding()
                }
                .padding()
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            
           
            VStack {
                ScrollView {
                    Text(vm.llmResponse)
                }
                Button("Clear") {
                    vm.clearResponse()
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            
            
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}

#Preview {
    ContentView()
}
