import SwiftUI

struct SortCriteriaPicker: View {
    @Binding var selection: SortCriteria?
    
    var body: some View {
        VStack(spacing: 40) {
            ForEach(SortCriteria.allCases) { sortCriteria in
    
                Button { selection = selection != sortCriteria ? sortCriteria : nil } label: {
                    HStack {
                        
                        Text(sortCriteria.rawValue.capitalized)
                            .kerning(1)
                        
                        Spacer()
                        
                        RadioButtonLabel(isSelected: selection == sortCriteria)
                        
                    }
                }
                .foregroundStyle(.primary)
            }
        }
    }
}

struct RadioButtonLabel: View {
    
    var isSelected: Bool
    
    var body: some View {
        if isSelected {
            ZStack {
                Circle().fill(.blue.opacity(0.5)).frame(width: 17)
                Circle().fill(.white).frame(width: 13)
                Circle().fill(.blue).frame(width: 10)
            }
        } else {
            Circle()
                .fill(.gray.opacity(0.3))
                .frame(width: 15)
        }
    }
}
