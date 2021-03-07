//
//  WaveResultCollectionView.swift
//  Salmonia2
//
//  Created by Devonly on 2021/02/08.
//

import SwiftUI

struct WaveResultCollectionView: View {
    @ObservedObject var stats: UserStatsCore
    
    var body: some View {
        List {
            Section(header: Text("Probability").modifier(Splatfont2(size: 16)).foregroundColor(.cOrange)) {
                HStack {
                    Text("Event")
                        .frame(maxWidth: .infinity)
                    ForEach(Range(0 ... 2)) { water_level in
                        Text("\((WaveType.init(water_level: water_level)?.water_name)!.localized)")
                            .frame(minWidth: 60)
                    }
                }
                .foregroundColor(.orange)
                .modifier(Splatfont2(size: 14))
                ForEach(Range(0...6), id:\.self) { event_type in
                    HStack {
                        ZStack(alignment: .top) {
                            Text("\((Double(stats.count(event_type)) / Double(stats.count)).per)")
                                .offset(y: -10)
                                .modifier(Splatfont2(size: 10))
                                .foregroundColor(.cGray)
                            Text("\(EventType.init(event_id: event_type)!.event_name!.localized)")
                                .frame(maxWidth: .infinity)
//                                .frame(maxWidth: 110)
                        }
                        ForEach(Range(0...2), id:\.self) { water_level in
                            switch stats.event_occur[water_level][event_type] {
                            case nil:
                                Text("\(stats.event_occur[water_level][event_type].value)")
                                    .frame(minWidth: 60)
                            default:
                                ZStack(alignment: .top) {
                                    Text("\((Double(stats.event_occur[water_level][event_type].value)! / Double(stats.count(event_type))).per)")
                                        .offset(y: -10)
                                        .modifier(Splatfont2(size: 10))
                                        .foregroundColor(.cGray)
                                    Text("\(stats.event_occur[water_level][event_type].value)")
                                        .frame(minWidth: 60)
                                    if (stats.average[water_level][event_type] != nil) {
                                        Text(String(stats.average[water_level][event_type]!.round(digit: 2)))
                                            .offset(y: 20)
                                            .modifier(Splatfont2(size: 12))
                                            .foregroundColor(.yellow)
                                    }
                                }
                                .frame(height: 60)
                            }
                        }
                    }
                }
                .modifier(Splatfont2(size: 14))
            }
        }
        .navigationTitle("TITLE_WAVE_RESULTS")
    }
}

//struct WaveResultCollectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        WaveResultCollectionView()
//    }
//}
