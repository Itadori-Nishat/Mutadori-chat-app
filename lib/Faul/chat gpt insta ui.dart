// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
//
// class Profile extends StatefulWidget {
//   @override
//   _ProfileState createState() => _ProfileState();
// }
//
// class _ProfileState extends State<Profile> {
//   String username = "username";
//   String name = "Name";
//   String bio = "Bio";
//   String profileImage = "https://via.placeholder.com/150";
//
//   int followersCount = 100;
//   int followingCount = 200;
//   int postsCount = 50;
//
//   List<String> posts = [
//     "https://via.placeholder.com/300",
//     "https://via.placeholder.com/300",
//     "https://via.placeholder.com/300",
//     "https://via.placeholder.com/300",
//     "https://via.placeholder.com/300",
//     "https://via.placeholder.com/300",
//     "https://via.placeholder.com/300",
//     "https://via.placeholder.com/300",
//     "https://via.placeholder.com/300",
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//           Container(
//           height: 200.0,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               fit: BoxFit.cover,
//               image: CachedNetworkImageProvider(
//                 "https://via.placeholder.com/500x200",
//               ),
//             ),
//           ),
//         ),
//         Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//     child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//     SizedBox(height: 16.0),
//     Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//     CircleAvatar(
//     radius: 40.0,
//     backgroundImage: CachedNetworkImageProvider(profileImage),
//     ),
//     SizedBox(width: 16.0),
//     Expanded(
//     child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//     Text(
//     username,
//     style: TextStyle(
//     fontSize: 18.0,
//     fontWeight: FontWeight.bold,
//     ),
//     ),
//     Text(
//     name,
//     style: TextStyle(
//     fontSize: 16.0,
//     ),
//     ),
//     SizedBox(height: 8.0),
//     Text(
//     bio,
//     style: TextStyle(
//     fontSize: 14.0,
//     ),
//     ),
//     SizedBox(height: 8.0),
//     Row(
//     children: [
//     Icon(
//     Icons.location_on,
//     size: 16.0,
//     ),
//     SizedBox(width: 4.0),
//     Text(
//     "Location",
//     style: TextStyle(
//     fontSize: 14.0,
//     ),
//     ),
//     ],
//     ),
//     ],
//     ),
//     ),
//     SizedBox(width: 16.0),
//     ElevatedButton(
//     onPressed: () {},
//     child: Text("Edit Profile")),;
