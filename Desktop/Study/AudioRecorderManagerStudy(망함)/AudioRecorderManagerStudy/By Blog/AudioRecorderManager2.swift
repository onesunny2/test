//
//  AudioRecorderManager.swift
//  AudioRecorderManagerStudy
//
//  Created by Lee Wonsun on 5/22/24.
//

import AVFoundation

// AudioRecorderManager 클래스 정의, NSObject를 상속받고 ObservableObject와 AVAudioPlayerDelegate 프로토콜을 채택
class AudioRecorderManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
  
  // MARK: - 음성메모 녹음 관련 프로퍼티
  
  /// 녹음을 담당하는 AVAudioRecorder 객체
  var audioRecorder: AVAudioRecorder?
  /// 녹음 중인지 여부를 나타내는 상태 변수 (UI 갱신을 위해 @Published 속성 사용)
  @Published var isRecording = false
  
  // MARK: - 음성메모 재생 관련 프로퍼티
  
  /// 재생을 담당하는 AVAudioPlayer 객체
  var audioPlayer: AVAudioPlayer?
  /// 재생 중인지 여부를 나타내는 상태 변수
  @Published var isPlaying = false
  /// 일시정지 상태인지 여부를 나타내는 상태 변수
  @Published var isPaused = false
  
  // MARK: - 음성메모된 데이터
  
  /// 녹음된 파일의 URL을 저장하는 배열
  var recordedFiles = [URL]()
}

// MARK: - 음성메모 녹음 관련 메서드

// AudioRecorderManager 클래스의 확장으로 녹음 관련 메서드 정의
extension AudioRecorderManager {
  
  /// 녹음을 시작하는 메서드
  func startRecording() {
    // 녹음 파일의 저장 위치와 이름 설정
    let fileURL = getDocumentsDirectory().appendingPathComponent("recording-\(Date().timeIntervalSince1970).m4a")
    // 녹음 설정 정의
    let settings = [
      AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
      AVSampleRateKey: 12000,
      AVNumberOfChannelsKey: 1,
      AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    do {
      // AVAudioRecorder 객체 생성 및 녹음 시작
      audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
      audioRecorder?.record()
      // 녹음 상태를 true로 설정
      self.isRecording = true
    } catch {
      // 녹음 중 오류 발생 시 에러 메시지 출력
      print("녹음 중 오류 발생: \(error.localizedDescription)")
    }
  }
  
  /// 녹음을 중지하는 메서드
  func stopRecording() {
    // 녹음 중지
    audioRecorder?.stop()
    // 녹음된 파일의 URL을 recordedFiles 배열에 추가
    self.recordedFiles.append(self.audioRecorder!.url)
    // 녹음 상태를 false로 설정
    self.isRecording = false
  }
  
  /// 도큐먼트 디렉토리 경로를 반환하는 헬퍼 메서드
  private func getDocumentsDirectory() -> URL {
    // 애플리케이션의 도큐먼트 디렉토리 경로 가져오기
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
}

// MARK: - 음성메모 재생 관련 메서드

// AudioRecorderManager 클래스의 확장으로 재생 관련 메서드 정의
extension AudioRecorderManager {
  
  /// 녹음된 파일을 재생하는 메서드
  func startPlaying(recordingURL: URL) {
    do {
      // AVAudioPlayer 객체 생성 및 재생 시작
      audioPlayer = try AVAudioPlayer(contentsOf: recordingURL)
      audioPlayer?.delegate = self
      audioPlayer?.play()
      // 재생 상태를 true로 설정
      self.isPlaying = true
      // 일시정지 상태를 false로 설정
      self.isPaused = false
    } catch {
      // 재생 중 오류 발생 시 에러 메시지 출력
      print("재생 중 오류 발생: \(error.localizedDescription)")
    }
  }
  
  /// 재생을 중지하는 메서드
  func stopPlaying() {
    // 재생 중지
    audioPlayer?.stop()
    // 재생 상태를 false로 설정
    self.isPlaying = false
  }
  
  /// 재생을 일시정지하는 메서드
  func pausePlaying() {
    // 재생 일시정지
    audioPlayer?.pause()
    // 일시정지 상태를 true로 설정
    self.isPaused = true
  }
  
  /// 일시정지된 재생을 다시 시작하는 메서드
  func resumePlaying() {
    // 재생 재개
    audioPlayer?.play()
    // 일시정지 상태를 false로 설정
    self.isPaused = false
  }
  
  /// 재생이 완료되었을 때 호출되는 델리게이트 메서드
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    // 재생 상태와 일시정지 상태를 false로 설정
    self.isPlaying = false
    self.isPaused = false
  }
}

