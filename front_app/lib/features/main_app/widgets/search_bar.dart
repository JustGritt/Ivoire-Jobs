
// Container _searchField() {
// return Container(
//   margin: const EdgeInsets.only(top: 40,left: 20,right: 20),
//   decoration: BoxDecoration(
//     boxShadow: [
//       BoxShadow(
//         color: const Color(0xff1D1617).withOpacity(0.11),
//         blurRadius: 40,
//         spreadRadius: 0.0
//       )
//     ]
//   ),
//   child: TextField(
//     decoration: InputDecoration(
//       filled: true,
//       fillColor: Colors.white,
//       contentPadding: const EdgeInsets.all(15),
//       hintText: 'Search Pancake',
//       hintStyle: const TextStyle(
//         color: Color(0xffDDDADA),
//         fontSize: 14
//       ),
//       suffixIcon: Container(
//         width: 100,
//         child: const IntrinsicHeight(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               VerticalDivider(
//                 color: Colors.black,
//                 indent: 10,
//                 endIndent: 10,
//                 thickness: 0.1,
//               ),
//               Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Icon(
//                   Icons.search,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(15),
//         borderSide: BorderSide.none
//       )
//     ),
//   ),
// );
// }