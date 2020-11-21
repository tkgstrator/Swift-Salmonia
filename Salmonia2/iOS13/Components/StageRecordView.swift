//
//  StageRecordView.swift
//  Salmonia2
//
//  Created by devonly on 2020-09-29.
//

import SwiftUI
import URLImage

struct StageRecordView: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("Stage Records")
                .foregroundColor(.cOrange)
                .font(.custom("Splatfont", size: 20))
                .frame(maxWidth: .infinity)
                .frame(height: 32)
                .background(Color.cDarkGray)
                .padding(.bottom, 10)
            ForEach(StageType.allCases, id:\.self) { stage in
                NavigationLink(destination: StageRecordsView().environmentObject(StageRecordCore(stage.stage_id!))) {
                    HStack {
                        URLImage(url: URL(string: stage.image_url!)!) { image in image.resizable()}
                            .frame(width: 112, height: 63)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 8.0))
                        //Spacer()
                        Group {
                            Text(stage.stage_name!.localized).font(.custom("Splatfont", size: 18.5)).minimumScaleFactor(0.7).lineLimit(1)
                        }.frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }.padding(.horizontal, 10)
        }
    }
}

private struct StageRecordsView: View {
    @EnvironmentObject var record: StageRecordCore
    
    var body: some View {
        List {
            Section(header: HStack {
                Spacer()
                Text("Overview").font(.custom("Splatfont", size: 22)).foregroundColor(.yellow)
                Spacer()
            }) {
                HStack {
                    Text("Jobs")
                    Spacer()
                    Text("\(record.job_num.value)")
                }
                HStack {
                    Text("Clear Ratio")
                    Spacer()
                    Text(String(record.clear_ratio.value) + "%")
                }
                HStack {
                    Text("Max Grade")
                    Spacer()
                    Text("\(record.grade_point.value)")
                }
                //                HStack {
                //                    Text("Salmon Rate")
                //                    Spacer()
                //                    Text(String(record.srpower[0].value))
                //                }
                //                HStack {
                //                    Text("Max Salmon Rate")
                //                    Spacer()
                //                    Text(String(record.srpower[1].value))
                //                }
            }
            Section(header: HStack {
                Spacer()
                Text("Record").font(.custom("Splatfont", size: 22)).foregroundColor(.yellow)
                Spacer()
            }) {
                HStack {
                    Text("All")
                    Spacer()
                    Text("\(record.team_golden_eggs[0].value)")
                }
                HStack {
                    Text("No Night Event")
                    Spacer()
                    Text("\(record.team_golden_eggs[1].value)")
                }
                ForEach(Range(0 ... 2)) { tide in
                    Section(header: HStack {
                        Spacer()
                        Text("\((WaveType.init(water_level: tide)?.water_name)!.localized)").font(.custom("Splatfont", size: 20)).foregroundColor(.orange)
                        Spacer()
                    }) {
                        ForEach(Range(0 ... 6)) { event in
                            if record.golden_eggs[tide][event] != nil {
                                NavigationLink(destination: ResultView().environmentObject(record.salmon_id[tide][event]!)) {
                                    HStack {
                                        Text("\((EventType.init(event_id: event)?.event_name)!.localized)")
                                        Spacer()
                                        Text("\(record.golden_eggs[tide][event].value)")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .font(.custom("Splatfont2", size: 20))
        .navigationBarTitle((StageType.init(stage_id: record.stage_id!)?.stage_name!)!.localized)
    }
}

struct StageRecordView_Previews: PreviewProvider {
    static var previews: some View {
        StageRecordView()
    }
}
