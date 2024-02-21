// import 'package:flutter/material.dart';
//
// class TodoListScreen extends StatelessWidget {
//   const TodoListScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xff4A3780),
//         title: Text('Add New Task',style: TextStyle(color:Colors.white,fontSize: 14,fontWeight: FontWeight.w400),),
//         centerTitle: true,
//       ),
//       body:Container(
//         // color: Colors.green,
//         padding: EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Task Title',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
//             SizedBox(height: 8,),
//             TextField(
//               decoration: InputDecoration(
//                 label: Text('Pick up Milk'),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(5.4)
//               ),
//
//             ),),
//             SizedBox(height: 12,),
//             Row(children: [
//               Text('Category',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
//               SizedBox(width: 42,),
//               Container(
//                   child: Icon(Icons.file_copy_outlined),
//                   height: 50,
//                   width: 50,
//                   decoration: BoxDecoration(
//                     color: Color(0xFFDBECF6),
//                     borderRadius: BorderRadius.circular(30)
//                   )
//
//       ),
//               SizedBox(width: 12,),
//               Container(
//                   child: Icon(Icons.calendar_month),
//                   height: 50,
//                   width: 50,
//                   decoration: BoxDecoration(
//                       color: Color(0xFFDBECF6),
//
//                       borderRadius: BorderRadius.circular(30)
//                   )
//
//               ),
//               SizedBox(width: 12,),
//
//               Container(
//                   child: Icon(Icons.group),
//                   height: 50,
//                   width: 50,
//                   decoration: BoxDecoration(
//                       color: Color(0xFFFEF5D3),
//
//                       borderRadius: BorderRadius.circular(30)
//                   )
//
//               ),
//
//             ],),
//             SizedBox(height: 12,),
//             Text('When',style: TextStyle(fontSize: 14,fontWeight:FontWeight.w500),),
//             SizedBox(
//               height: 8,
//             ),
//             Row(
//               children: [
//               Expanded(
//                 child:Container(
//                   padding: EdgeInsets.only(left: 10,right: 10),
//                   child: Row(
//                     mainAxisAlignment:MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text('YYYY/MM/DD'),
//                       InkWell(
//                         onTap: (){
//
//                         },
//                           child: Icon((Icons.calendar_month)))
//                     ],
//                   ),
//                   width: double.infinity,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     border: Border.all()
//                   ),
//                 )
//               ),
//                 SizedBox(
//                   width: 12,
//                 ),
//                 Expanded(
//                     child:Container(
//                       padding: EdgeInsets.only(left: 10,right: 10),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//                         children: [
//                           Text('12:00pm'),
//                           Icon((Icons.punch_clock_sharp))
//                         ],
//                       ),
//                       width: double.infinity,
//                       height: 50,
//                       decoration: BoxDecoration(
//                           border: Border.all()
//                       ),
//                     )
//                 ),
//
//
//             ],),
//             SizedBox(height: 12,),
//             Text('Notes',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
//             SizedBox(
//               height: 6,
//             ),
//             TextField(
//               maxLines: 5,
//               decoration: InputDecoration(
//                 label: Text('Add your text here'),
//                 border: OutlineInputBorder(
//                 )
//               ),
//             ),
//             SizedBox(
//               height: 250,
//             ),
//             SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(onPressed: (){}, child: Text('save')))
//           ],
//         ),
//       ) ,
//     );
//   }
// }
