import 'package:flutter/material.dart';
import 'package:flutter_common/models/user/user.dart';

class UserInfoSection extends StatelessWidget {
  final User user;
  const UserInfoSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '안녕하세요, ${user.username}님!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        // Container(
        //   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        //   decoration: BoxDecoration(
        //     color: Colors.green[600],
        //     borderRadius: BorderRadius.circular(20),
        //   ),
        //   child: Text(
        //     'Lv.${_tree.level}',
        //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        //   ),
        // ),
      ],
    );
  }
}
