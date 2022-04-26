//
//  File.swift
//  MyRoutine_CircularDesign
//
//  Created by 김윤석 on 2021/05/11.
//
//
//import Foundation
//
////before edit
//[
//    MyRoutine_CircularDesign.WorkOutInADay(date: "2021-05-03", workOuts:
//                                            [MyRoutine_CircularDesign.WorkOut(workOutName: "", reps: 0, weights: 0.0, isDone: true),
//                                            MyRoutine_CircularDesign.WorkOut(workOutName: "", reps: 0, weights: 0.0, isDone: true),
//                                            MyRoutine_CircularDesign.WorkOut(workOutName: "", reps: 0, weights: 0.0, isDone: true),
//                                            MyRoutine_CircularDesign.WorkOut(workOutName: "", reps: 0, weights: 0.0, isDone: true)]),
//
// MyRoutine_CircularDesign.WorkOutInADay(date: "2021-05-10", workOuts:
//                                            [MyRoutine_CircularDesign.WorkOut(workOutName: "", reps: 0, weights: 0.0, isDone: true),
//                                             MyRoutine_CircularDesign.WorkOut(workOutName: "", reps: 0, weights: 0.0, isDone: true),
//                                             MyRoutine_CircularDesign.WorkOut(workOutName: "", reps: 0, weights: 0.0, isDone: true),
//                                             MyRoutine_CircularDesign.WorkOut(workOutName: "", reps: 0, weights: 0.0, isDone: true),
//                                             MyRoutine_CircularDesign.WorkOut(workOutName: "", reps: 0, weights: 0.0, isDone: true),
//                                             MyRoutine_CircularDesign.WorkOut(workOutName: "", reps: 0, weights: 0.0, isDone: true),
//                                             MyRoutine_CircularDesign.WorkOut(workOutName: "", reps: 0, weights: 0.0, isDone: true),
//                                             MyRoutine_CircularDesign.WorkOut(workOutName: "", reps: 0, weights: 0.0, isDone: true),
//                                             MyRoutine_CircularDesign.WorkOut(workOutName: "", reps: 0, weights: 0.0, isDone: true),
//                                             MyRoutine_CircularDesign.WorkOut(workOutName: "", reps: 0, weights: 0.0, isDone: true),
//                                             MyRoutine_CircularDesign.WorkOut(workOutName: "", reps: 0, weights: 0.0, isDone: true),
//                                             MyRoutine_CircularDesign.WorkOut(workOutName: "", reps: 0, weights: 0.0, isDone: true),
//                                             MyRoutine_CircularDesign.WorkOut(workOutName: "", reps: 0, weights: 0.0, isDone: true),
//                                             MyRoutine_CircularDesign.WorkOut(workOutName: "", reps: 0, weights: 0.0, isDone: true)]),
//
// MyRoutine_CircularDesign.WorkOutInADay(date: "2021-05-10", workOuts:
//                                            [MyRoutine_CircularDesign.WorkOut(workOutName: "pull over", reps: 0, weights: 0.0, isDone: true),
//                                             MyRoutine_CircularDesign.WorkOut(workOutName: "pull over", reps: 0, weights: 0.0, isDone: true),
//                                             MyRoutine_CircularDesign.WorkOut(workOutName: "pull over", reps: 0, weights: 0.0, isDone: true)]),
//
// MyRoutine_CircularDesign.WorkOutInADay(date: "2021-05-10", workOuts:
//                                            [MyRoutine_CircularDesign.WorkOut(workOutName: "bench press", reps: 12, weights: 20.0, isDone: false),
//                                             MyRoutine_CircularDesign.WorkOut(workOutName: "bench press", reps: 12, weights: 20.0, isDone: false),
//                                             MyRoutine_CircularDesign.WorkOut(workOutName: "bench press", reps: 12, weights: 20.0, isDone: false)])
//]
//
//
////After edit
//


//[MyRoutine_CircularDesign.WorkOutInADay(date: "2021-05-11", workOuts2DArray:
//                                            [
//                                                [MyRoutine_CircularDesign.WorkOut(time: "Optional(2021-05-11 06:22:38 +0000)", workOutName: "bench press", reps: 12, weights: 0.0, isDone: false),
//                                                 MyRoutine_CircularDesign.WorkOut(time: "Optional(2021-05-11 06:22:38 +0000)", workOutName: "bench press", reps: 12, weights: 0.0, isDone: false),
//                                                 MyRoutine_CircularDesign.WorkOut(time: "Optional(2021-05-11 06:22:38 +0000)", workOutName: "bench press", reps: 12, weights: 0.0, isDone: false)],
//
//                                                [MyRoutine_CircularDesign.WorkOut(time: "Optional(2021-05-11 06:26:08 +0000)", workOutName: "", reps: 0, weights: 0.0, isDone: false),
//                                                 MyRoutine_CircularDesign.WorkOut(time: "Optional(2021-05-11 06:26:08 +0000)", workOutName: "", reps: 0, weights: 0.0, isDone: false),
//                                                 MyRoutine_CircularDesign.WorkOut(time: "Optional(2021-05-11 06:26:08 +0000)", workOutName: "", reps: 0, weights: 0.0, isDone: false)],
//
//                                                [MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 6:43:24 AM Korean Standard Time", workOutName: "", reps: 0, weights: 0.0, isDone: false)]
//                                            ]
//)
//]
//
//Optional(
//    [
//        [MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 8:06:15 AM Korean Standard Time", workOutName: "bench press", reps: 12, weights: 40.0, isDone: true),
//         MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 8:06:15 AM Korean Standard Time", workOutName: "bench press", reps: 12, weights: 40.0, isDone: true),
//         MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 8:06:15 AM Korean Standard Time", workOutName: "bench press", reps: 12, weights: 40.0, isDone: true),
//         MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 8:06:16 AM Korean Standard Time", workOutName: "bench press", reps: 12, weights: 40.0, isDone: false),
//         MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 8:06:22 AM Korean Standard Time", workOutName: "pull over", reps: 12, weights: 20.0, isDone: false),
//         MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 8:06:22 AM Korean Standard Time", workOutName: "pull over", reps: 12, weights: 20.0, isDone: false)],
//        
//        [MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 9:16:13 AM Korean Standard Time", workOutName: "", reps: 0, weights: 0.0, isDone: false),
//         MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 9:16:13 AM Korean Standard Time", workOutName: "", reps: 0, weights: 0.0, isDone: false)]
//    ]
//)
//
//
//[MyRoutine_CircularDesign.WorkOutInADay(date: "2021-05-11", workOuts2DArray:
//                                            [
//                                                [MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 8:06:15 AM Korean Standard Time", workOutName: "bench press", reps: 12, weights: 40.0, isDone: true), MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 8:06:15 AM Korean Standard Time", workOutName: "bench press", reps: 12, weights: 40.0, isDone: true), MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 8:06:15 AM Korean Standard Time", workOutName: "bench press", reps: 12, weights: 40.0, isDone: true), MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 8:06:16 AM Korean Standard Time", workOutName: "bench press", reps: 12, weights: 40.0, isDone: false), MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 8:06:22 AM Korean Standard Time", workOutName: "pull over", reps: 12, weights: 20.0, isDone: false), MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 8:06:22 AM Korean Standard Time", workOutName: "pull over", reps: 12, weights: 20.0, isDone: false)],
//                                                
//                                                [MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 9:16:13 AM Korean Standard Time", workOutName: "", reps: 0, weights: 0.0, isDone: false), MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 9:16:13 AM Korean Standard Time", workOutName: "", reps: 0, weights: 0.0, isDone: false), MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 9:16:13 AM Korean Standard Time", workOutName: "", reps: 0, weights: 0.0, isDone: false)]
//                                            ]
//)]

//
//WorkOutInADay(date: "2021-05-11", workOuts2DArray:
//                [
//                    [
//                        MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 8:06:15 AM Korean Standard Time", workOutName: "bench press", reps: 12, weights: 40.0, isDone: true),
//                        MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 8:06:15 AM Korean Standard Time", workOutName: "bench press", reps: 12, weights: 40.0, isDone: true),
//                        MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 8:06:15 AM Korean Standard Time", workOutName: "bench press", reps: 12, weights: 40.0, isDone: true),
//                        MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 8:06:16 AM Korean Standard Time", workOutName: "bench press", reps: 12, weights: 40.0, isDone: false),
//                        MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 8:06:22 AM Korean Standard Time", workOutName: "pull over", reps: 12, weights: 20.0, isDone: false)],
//                    [],
//                    [
//                        MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 7:22:40 PM Korean Standard Time", workOutName: "bench press", reps: 120, weights: 40.0, isDone: true),
//                        MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 7:22:41 PM Korean Standard Time", workOutName: "bench press", reps: 120, weights: 40.0, isDone: true),
//                        MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 7:22:41 PM Korean Standard Time", workOutName: "bench press", reps: 120, weights: 40.0, isDone: true),
//                        MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 7:22:41 PM Korean Standard Time", workOutName: "bench press", reps: 120, weights: 40.0, isDone: true)]])
//
//
//
//Optional(
//    [
//        [
//            MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 8:06:15 AM Korean Standard Time", workOutName: "bench press", reps: 12, weights: 40.0, isDone: true),
//            MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 8:06:15 AM Korean Standard Time", workOutName: "bench press", reps: 12, weights: 40.0, isDone: true),
//            MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 8:06:15 AM Korean Standard Time", workOutName: "bench press", reps: 12, weights: 40.0, isDone: true),
//            MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 8:06:16 AM Korean Standard Time", workOutName: "bench press", reps: 12, weights: 40.0, isDone: false)],
//        [],
//        [
//            MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 7:22:40 PM Korean Standard Time", workOutName: "bench press", reps: 120, weights: 40.0, isDone: true),
//            MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 7:22:41 PM Korean Standard Time", workOutName: "bench press", reps: 120, weights: 40.0, isDone: true),
//            MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 7:22:41 PM Korean Standard Time", workOutName: "bench press", reps: 120, weights: 40.0, isDone: true),
//            MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 7:22:41 PM Korean Standard Time", workOutName: "bench press", reps: 120, weights: 40.0, isDone: true)]])
//
//
//WorkOutInADay(date: "2021-05-11", workOuts2DArray:
//                [
//                    [
//                        MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 8:06:15 AM Korean Standard Time", workOutName: "bench press", reps: 12, weights: 40.0, isDone: true),
//                        MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 8:06:15 AM Korean Standard Time", workOutName: "bench press", reps: 12, weights: 40.0, isDone: true),
//                        MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 8:06:15 AM Korean Standard Time", workOutName: "bench press", reps: 12, weights: 40.0, isDone: true),
//                        MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 8:06:16 AM Korean Standard Time", workOutName: "bench press", reps: 12, weights: 40.0, isDone: false)],
//                    [],
//                    [
//                        MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 7:22:40 PM Korean Standard Time", workOutName: "bench press", reps: 120, weights: 40.0, isDone: true),
//                        MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 7:22:41 PM Korean Standard Time", workOutName: "bench press", reps: 120, weights: 40.0, isDone: true),
//                        MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 7:22:41 PM Korean Standard Time", workOutName: "bench press", reps: 120, weights: 40.0, isDone: true),
//                        MyRoutine_CircularDesign.WorkOut(time: "Tuesday, May 11, 2021 at 7:22:41 PM Korean Standard Time", workOutName: "bench press", reps: 120, weights: 40.0, isDone: true)]])

//
//[MyRoutine_CircularDesign.WorkOutInADay(date: "2021-05-12", workOutWithTime:
//                                            [
//                                                MyRoutine_CircularDesign.WorkOutWithTime(time: "Wednesday, May 12, 2021 at 4:02:45 AM Korean Standard Time", workOut:
//                                                                [
//                                                                    MyRoutine_CircularDesign.WorkOut(workOutName: "", reps: 0, weights: 0.0, isDone: false),
//                                                                    MyRoutine_CircularDesign.WorkOut(workOutName: "", reps: 0, weights: 0.0, isDone: false),
//                                                                    MyRoutine_CircularDesign.WorkOut(workOutName: "", reps: 0, weights: 0.0, isDone: false)]),
//                                                
//                                                MyRoutine_CircularDesign.WorkOutWithTime(time: "Wednesday, May 12, 2021 at 4:03:04 AM Korean Standard Time", workOut:
//                                                                [
//                                                                    MyRoutine_CircularDesign.WorkOut(workOutName: "ben", reps: 0, weights: 0.0, isDone: false),
//                                                                    MyRoutine_CircularDesign.WorkOut(workOutName: "", reps: 0, weights: 0.0, isDone: false)
//                                                                ])
//                                            ]
//)]
