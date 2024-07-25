//
//  VoiceMemoView.swift
//  AudioRecorderManagerStudy
//
//  Created by Lee Wonsun on 5/22/24.
//

import SwiftUI

struct VoiceMemoView: View {
    @StateObject var audioRecorderManager = AudioRecorderManager()
    
    var body: some View {
        VStack(spacing: 20){
            Spacer()
            // 타이틀 뷰
            RecordingTitleView()
            
            // 현재 음성메모 진행 중 상태 뷰
            RecordingStatusView(audioRecorderManager: audioRecorderManager)
            
            // 음성메모 버튼 뷰
            RecordingButtonView(audioRecorderManager: audioRecorderManager)
            
            // 음성메모 리스트 뷰
            RecordingListView(audioRecorderManager: audioRecorderManager)
            
        }
        .task {
            await audioRecorderManager.getRecordPermission()
        }
    }
}

// MARK: - 음성메모 타이틀 뷰
private struct RecordingTitleView: View {
    fileprivate var body: some View {
        HStack{
            Text("음성메모")
                .font(.largeTitle)
                .background(Color.accentColor)
        }
    }
}

// MARK: - 음성메모 현재 상태 뷰
private struct RecordingStatusView: View {
    @ObservedObject private var audioRecorderManager: AudioRecorderManager
    
    fileprivate init(audioRecorderManager: AudioRecorderManager) {
        self.audioRecorderManager = audioRecorderManager
    }
    
    fileprivate var body: some View {
        if audioRecorderManager.isRecording {
            Text("음성메모 중")
                .foregroundStyle(.red)
        } else {
            Text("음성메모 준비")
        }
    }
}

// MARK: - 음성메모 버튼 뷰
private struct RecordingButtonView: View {
    @ObservedObject private var audioRecorderManager: AudioRecorderManager
    fileprivate init(audioRecorderManager: AudioRecorderManager) {
        self.audioRecorderManager = audioRecorderManager
    }
    
    fileprivate var body: some View {
        HStack{
            Button(action: {
                audioRecorderManager.isRecording
                ? audioRecorderManager.stopRecording()
                : audioRecorderManager.startRecording()
                
            }, label: {
                Text(audioRecorderManager.isRecording ? "음성메모 종료" : "음성메모 시작")
                    .foregroundStyle(.white)
                    .padding()
                    .background(audioRecorderManager.isRecording ? Color.red : Color.blue)
                    .cornerRadius(10)
            })
        }
    }
}

// MARK: - 음성메모 리스트 뷰
private struct RecordingListView: View {
    @ObservedObject private var audioRecorderManager: AudioRecorderManager
    
    fileprivate init(audioRecorderManager: AudioRecorderManager) {
        self.audioRecorderManager = audioRecorderManager
    }
    
    fileprivate var body: some View {
        Text("음성메모 리스트")
            .font(.title)
            .padding()
        
        List{
            ForEach(audioRecorderManager.recordedFiles, id: \.self){ recordedFile in
                Button(action: {
                    if audioRecorderManager.isPlaying && audioRecorderManager.audioPlayer?.url == recordedFile {
                        audioRecorderManager.isPaused
                        ? audioRecorderManager.resumePlaying()
                        : audioRecorderManager.pausePlaying()
                    } else {
                        audioRecorderManager.startPlaying(recordingURL: recordedFile)
                    }
                }, label: {
                    Text(recordedFile.lastPathComponent)
                        .foregroundStyle(
                            audioRecorderManager.isPlaying && audioRecorderManager.audioPlayer?.url == recordedFile ? (audioRecorderManager.isPaused ? .green : .red) : .black
                        )
                })
                
            }
        }
    }
}

#Preview {
    VoiceMemoView()
}
