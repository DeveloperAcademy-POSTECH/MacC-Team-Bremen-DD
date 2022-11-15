//
 //  BorderedPicker.swift
 //  Rlog
 //
 //  Created by Noah's Ark on 2022/11/14.
 //

 import SwiftUI

 enum BorderedPickerType {
     case date
     case startTime
     case endTime

     var title: String {
         switch self {
         case .date: return "날짜"
         case .startTime: return "출근 시간"
         case .endTime: return "퇴근 시간"
         }
     }
 }

 struct BorderedPicker: View {
     @Binding var date: Date
     @State private var isTapped = false
     let type: BorderedPickerType
     var timeData: String {
         let components = Calendar.current.dateComponents(
             [.year, .month, .day, .hour, .minute],
             from: date
         )
         let year = components.year ?? 2000
         let month = components.month ?? 1
         let day = components.day ?? 1
         let hour = components.hour ?? 9
         let minute = components.minute ?? 0

         if type == .date {
             return "\(year)년 \(month)월 \(day)일"
         } else {
             return "\(hour):\(minute < 10 ? "0\(minute)" : "\(minute)")"
         }
     }

     var body: some View {
         borderedPicker
     }
 }

 private extension BorderedPicker {
     var borderedPicker: some View {
         HStack {
             if type == .date {
                 Text(timeData)
                 Spacer()
             } else {
                 Text(type.title)
                 Spacer()
                 Text(timeData)
             }
         }
         .padding(EdgeInsets(top: 13, leading: 16, bottom: 13, trailing: 16))
         .cornerRadius(13)
         .frame(maxWidth: .infinity, maxHeight: 56)
         .background(Color.backgroundCard)
         .onTapGesture { isTapped = true }
         .overlay {
             RoundedRectangle(cornerRadius: 13)
                 .stroke(
                     isTapped ? Color.primary : Color.backgroundStroke,
                     lineWidth: 2
                 )
         }
         .popover(isPresented: $isTapped) {
             wheelTimePicker
         }
 // 외않되 ㅠ
 //        .adaptiveSheet(isPresented: $isTapped) {
 //            wheelTimePicker
 //                .onAppear { print(isFocused) }
 //                .onDisappear { print(isFocused) }
 //        }
     }

     var wheelTimePicker: some View {
         VStack(spacing: 0) {
             HStack {
                 Spacer()
                 Button {
                     isTapped = false
                 } label: {
                     Text("완료")
                         .foregroundColor(.primary)
                 }

             }
             .padding(.top)

             DatePicker(
                 "",
                 selection: $date,
                 displayedComponents: type != .date ? .hourAndMinute : .date
             )
                 .datePickerStyle(.wheel)
                 .background(.white)
                 .onAppear {
                     UIDatePicker.appearance().minuteInterval = 30
                 }
                 .onDisappear {
                     UIDatePicker.appearance().minuteInterval = 1
                     isTapped = false
                 }

             Spacer()
         }
         .padding(.horizontal)
     }
 }

 /* 연구중... 리뷰 대상 아닙니다~! 🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥
 extension View {
     func adaptiveSheet<T: View>(
         isPresented: Binding<Bool>,
         detents : [UISheetPresentationController.Detent] = [.medium(), .large()],
         largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = .medium,
         prefersScrollingExpandsWhenScrolledToEdge: Bool = false,
         prefersEdgeAttachedInCompactHeight: Bool = true,
         prefersGrabberVisible: Bool = false,
         disableSwipeToDismiss: Bool = false,
         preferredCornerRadius: CGFloat? = nil,
         @ViewBuilder content: @escaping () -> T
     )-> some View {
         return modifier(AdaptiveSheet<T>(
             isPresented: isPresented,
             detents : detents,
             largestUndimmedDetentIdentifier: largestUndimmedDetentIdentifier,
             prefersScrollingExpandsWhenScrolledToEdge: prefersScrollingExpandsWhenScrolledToEdge,
             prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight,
             prefersGrabberVisible: prefersGrabberVisible,
             disableSwipeToDismiss: disableSwipeToDismiss,
             preferredCornerRadius: preferredCornerRadius,
             sheetContent: content)
         )
     }
 }
 struct AdaptiveSheet<T: View>: ViewModifier {
     @Binding var isPresented: Bool
     let detents : [UISheetPresentationController.Detent]
     let largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
     let prefersScrollingExpandsWhenScrolledToEdge: Bool
     let prefersEdgeAttachedInCompactHeight: Bool
     let prefersGrabberVisible: Bool
     let disableSwipeToDismiss: Bool
     let preferredCornerRadius: CGFloat?
     @ViewBuilder let sheetContent: T
     
     func body(content: Content) -> some View {
         return content.overlay(
             CustomSheetUI(
                 isPresented: $isPresented,
                 detents: detents,
                 largestUndimmedDetentIdentifier: largestUndimmedDetentIdentifier,
                 prefersScrollingExpandsWhenScrolledToEdge: prefersScrollingExpandsWhenScrolledToEdge,
                 prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight,
                 prefersGrabberVisible: prefersGrabberVisible,
                 disableSwipeToDismiss: disableSwipeToDismiss,
                 preferredCornerRadius: preferredCornerRadius,
                 content: {sheetContent}
             )
             .frame(width: 0, height: 0)
         )
     }
 }
 struct CustomSheetUI<T: View>: UIViewControllerRepresentable {
     @Binding var isPresented: Bool
     var detents : [UISheetPresentationController.Detent] = [.medium(), .large()]
     var largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = .medium
     var prefersScrollingExpandsWhenScrolledToEdge: Bool = false
     var prefersEdgeAttachedInCompactHeight: Bool = true
     var prefersGrabberVisible: Bool = false
     var disableSwipeToDismiss: Bool = false
     var preferredCornerRadius: CGFloat?
     @ViewBuilder let content: T
     
     func makeCoordinator() -> Coordinator {
         Coordinator(self)
     }
     
     func makeUIViewController(context: Context) -> CustomSheetViewController<T> {
         let vc = CustomSheetViewController(
             coordinator: context.coordinator,
             detents: detents,
             largestUndimmedDetentIdentifier: largestUndimmedDetentIdentifier,
             prefersScrollingExpandsWhenScrolledToEdge: prefersScrollingExpandsWhenScrolledToEdge,
             prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight,
             prefersGrabberVisible: prefersGrabberVisible,
             disableSwipeToDismiss: disableSwipeToDismiss,
             preferredCornerRadius: preferredCornerRadius,
             content: { content }
         )
         
         return vc
     }
     
     func updateUIViewController(_ uiViewController: CustomSheetViewController<T>, context: Context) {
         if isPresented {uiViewController.presentModalView() }
         else { uiViewController.dismissModalView() }
     }
     class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
         var parent: CustomSheetUI
         var isPresented: Bool = false
         init(_ parent: CustomSheetUI) {
             self.parent = parent
         }
         
         //Adjust the variable when the user dismisses with a swipe
         func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
             if parent.isPresented { parent.isPresented.toggle() }
         }
     }
 }
 class CustomSheetViewController<Content: View>: UIViewController {
     let content: Content
     var coordinator: CustomSheetUI<Content>.Coordinator
     let detents : [UISheetPresentationController.Detent]
     let largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
     let prefersScrollingExpandsWhenScrolledToEdge: Bool
     let prefersEdgeAttachedInCompactHeight: Bool
     let prefersGrabberVisible: Bool
     let disableSwipeToDismiss: Bool
     let preferredCornerRadius: CGFloat?
     private var isLandscape: Bool = UIDevice.current.orientation.isLandscape
     
     init(
         coordinator: CustomSheetUI<Content>.Coordinator,
         detents : [UISheetPresentationController.Detent] = [.medium(), .large()],
         largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = .medium,
         prefersScrollingExpandsWhenScrolledToEdge: Bool = false,
         prefersEdgeAttachedInCompactHeight: Bool = true,
         prefersGrabberVisible: Bool,
         disableSwipeToDismiss: Bool,
         preferredCornerRadius: CGFloat?,
         @ViewBuilder content: @escaping () -> Content
     ) {
         self.content = content()
         self.coordinator = coordinator
         self.detents = detents
         self.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
         self.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
         self.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
         self.prefersGrabberVisible = prefersGrabberVisible
         self.disableSwipeToDismiss = disableSwipeToDismiss
         self.preferredCornerRadius = preferredCornerRadius
         super.init(nibName: nil, bundle: .main)
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     func dismissModalView() {
         dismiss(animated: true, completion: nil)
     }
     func presentModalView() {
         let hostingController = UIHostingController(rootView: content)
 //        hostingController.view.backgroundColor = .white
         hostingController.modalPresentationStyle = .popover
         hostingController.presentationController?.delegate = coordinator as UIAdaptivePresentationControllerDelegate
         hostingController.modalTransitionStyle = .coverVertical
         hostingController.isModalInPresentation = disableSwipeToDismiss
         
         if let hostPopover = hostingController.popoverPresentationController {
             hostPopover.sourceView = super.view
             
             let sheet = hostPopover.adaptiveSheetPresentationController
             //As of 13 Beta 4 if .medium() is the only detent in landscape error occurs
             sheet.detents = (isLandscape ? [.large()] : detents)
             sheet.largestUndimmedDetentIdentifier =
             largestUndimmedDetentIdentifier
             sheet.prefersScrollingExpandsWhenScrolledToEdge =
             prefersScrollingExpandsWhenScrolledToEdge
             sheet.prefersEdgeAttachedInCompactHeight =
             prefersEdgeAttachedInCompactHeight
             sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
             sheet.prefersGrabberVisible = prefersGrabberVisible
             sheet.preferredCornerRadius = preferredCornerRadius
         }
         
         if presentedViewController == nil {
             present(hostingController, animated: true, completion: nil)
         }
     }
     /// To compensate for l orientation
     override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
         
         if UIDevice.current.orientation.isLandscape {
             isLandscape = true
             self.presentedViewController?.popoverPresentationController?.adaptiveSheetPresentationController.detents = [.large()]
         } else {
             isLandscape = false
             self.presentedViewController?.popoverPresentationController?.adaptiveSheetPresentationController.detents = detents
         }
         super.viewWillTransition(to: size, with: coordinator)
     }
 }
 */
