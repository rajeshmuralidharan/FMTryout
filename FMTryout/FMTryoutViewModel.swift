//
//  FMTryoutViewModel.swift
//  FMTryout
//
//  Created by RAJESH MURALIDHARAN on 7/1/25.
//

import SwiftUI
import FoundationModels

@Observable
class FMTryoutViewModel {
    private var model = SystemLanguageModel.default
    var llmResponse: String = ""
    var session : LanguageModelSession?
    var isResponding = false
    
    func process(prompt: String)  -> Void {
        
        if (!model.isAvailable) {
            return
        }
    
        Task {
            let stream  = session?.streamResponse(to: prompt, options: GenerationOptions(temperature: 0.1))
            isResponding = true
            guard let stream else {
                return
            }
            
            do {
                for try await partialResponse in stream {
                    await MainActor.run {
                        self.llmResponse = partialResponse.content
                    }
                    
                    
                }
            } catch LanguageModelSession.GenerationError.guardrailViolation {
                self.llmResponse = "I'm afraid I can't accept this message."
                
            }
            
            isResponding = session?.isResponding ?? false
            
        }
        
    }
    
    func processSync(prompt: String)  -> Void {
        if (!model.isAvailable) {
            return
        }
        
        Task {
            do {
                let response = try await session?.respond(to: prompt)
                self.llmResponse = response?.content ?? ""
            } catch LanguageModelSession.GenerationError.guardrailViolation {
                self.llmResponse = "I'm afraid I can't accept this message."
            }
        }
    }
    
    func clearResponse() -> Void {
        llmResponse = ""
    }
    
    func clearInstruction() -> Void {
        session = nil
    }
    
    func initiateSessionWith(instructions: String) -> Void {
        session = LanguageModelSession(instructions: instructions)
        session?.prewarm()
    }
}
