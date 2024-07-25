//
//  ContentView.swift
//  GeometryReader_Study
//
//  Created by Lee Wonsun on 5/19/24.
//

import SwiftUI

struct ContentView: View {
    let columns = [GridItem(.flexible(), spacing: 7), GridItem(.flexible())]
    let gridNums: [Int] = [1, 2, 3, 4, 5]
    
    var body: some View {
        NavigationStack{
            GeometryReader{ geo in
                ZStack{
                    Color.black
                    ScrollView{
                        VStack(spacing: -1){
                            //기록 LazyVGrid
                            LazyVGrid(columns: columns, spacing: 16, content: {
                                ForEach(gridNums, id: \.self) { num in
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 20)
                                            .frame(width: geo.size.width * 0.41, height: geo.size.width * 0.55)
                                            .foregroundStyle(Color.pink)
                                        //날짜, 전송예약
                                        VStack{
                                            Spacer()
                                            ZStack{
                                                Rectangle()
                                                    .frame(width: 161, height: 34)
                                                    .foregroundStyle(Color.black)
                                                    .opacity(0.5)
                                                HStack(spacing: 0){
                                                    Spacer()
                                                    WillSendIndicator()
                                                        .padding(.trailing, 16)
                                                    Text("7일")
                                                        .font(.headline)
                                                        .foregroundStyle(Color.white)
                                                        .padding(.trailing, 13)
                                                }
                                            }
                                        }
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                }
                            })
                            .padding([.leading, .trailing], 32)
                            .padding([.bottom, .top], 16)
                            .background{
                                Rectangle()
                                    .foregroundStyle(.white)
                                    .frame(width: geo.size.width * 0.92)
                            }
                            
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("모아보기")
            .toolbarBackground(Color.white, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar{
                ToolbarItem{
                    Button(action: {
                        print("+")
                    }, label: {
                        Image(systemName: "plus")
                            .foregroundStyle(Color.primary)
                    })
                }
            }
        }
    }
}

//전송예약 아이콘
struct WillSendIndicator: View {
    var body: some View {
        ZStack{
            ZStack{
                RoundedRectangle(cornerRadius: 90)
                    .foregroundStyle(.white)
                    .frame(width: 90, height: 20)
                HStack(spacing: 0){
                    Text("전송 예정 ")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.primary)
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.primary)
                    
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
