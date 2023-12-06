// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../controller/register_controller.dart';
// import 'custom_colors.dart';

// class MyAppBar extends StatefulWidget {
//   final GlobalKey<ScaffoldState> _scaffoldKey;

//   const MyAppBar(this._scaffoldKey);

//   @override
//   State<MyAppBar> createState() => _MyAppBarState();
// }

// class _MyAppBarState extends State<MyAppBar> {
//   final RegisterController userController = Get.put<RegisterController>(
//     RegisterController(),
//   );
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: lowBlue,
//       elevation: 1,
//       titleSpacing: 0,
//       leading: IconButton(
//         onPressed: () => widget._scaffoldKey.currentState!.openDrawer(),
//         icon: const Icon(
//           Icons.menu,
//           color: primaryColor,
//         ),
//       ),
//       title: Padding(
//         padding: const EdgeInsets.only(right: 20),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Text(
//               userController.name.value.split(' ')[0] != null
//                   ? 'Oi, ${userController.name.value.split(' ')[0]}'
//                   : "",
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: primaryColor,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(width: 10),
//             CircleAvatar(
//               maxRadius: 15,
//               backgroundColor: constLight,
//               child: Text(
//                 userController.name.value.toUpperCase().substring(0, 1) ?? '',
//                 style: const TextStyle(
//                   color: lowBlue,
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
