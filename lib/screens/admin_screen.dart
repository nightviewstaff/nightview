import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/helpers/users/friends/friends_helper.dart';
import 'package:nightview/models/users/user_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminScreen> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _partyStatusController = TextEditingController();
  final TextEditingController _adminStatusController = TextEditingController();
  final TextEditingController _friendIdController = TextEditingController();

  @override
  void dispose() {
    _userIdController.dispose();
    _partyStatusController.dispose();
    _adminStatusController.dispose();
    _friendIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final globalProvider = Provider.of<GlobalProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: primaryColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Section 1: User Management
          const Text(
            'User Management',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: _userIdController,
            decoration: const InputDecoration(labelText: 'Enter User ID'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              String userId = _userIdController.text.trim();
              if (userId.isNotEmpty) {
                try {
                  final firestore = FirebaseFirestore.instance;
                  DocumentSnapshot<Map<String, dynamic>> snapshot =
                      await firestore.collection('user_data').doc(userId).get();
                  if (snapshot.exists) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('User found: ${snapshot.data()}')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User not found')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text('Fetch User Data'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _partyStatusController,
            decoration: const InputDecoration(
                labelText: 'Set Party Status (yes/no/unsure)'),
          ),
          ElevatedButton(
            onPressed: () async {
              String userId = _userIdController.text.trim();
              String status = _partyStatusController.text.trim().toLowerCase();
              if (userId.isNotEmpty && status.isNotEmpty) {
                PartyStatus? partyStatus;
                if (status == 'yes') partyStatus = PartyStatus.yes;
                if (status == 'no') partyStatus = PartyStatus.no;
                if (status == 'unsure') partyStatus = PartyStatus.unsure;
                if (partyStatus != null) {
                  try {
                    await FirebaseFirestore.instance
                        .collection('user_data')
                        .doc(userId)
                        .update({'partyStatus': status});
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Party status updated')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid party status')),
                  );
                }
              }
            },
            child: const Text('Update Party Status'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _adminStatusController,
            decoration: const InputDecoration(
                labelText: 'Set Admin Status (true/false)'),
          ),
          ElevatedButton(
            onPressed: () async {
              String userId = _userIdController.text.trim();
              String adminStatus =
                  _adminStatusController.text.trim().toLowerCase();
              if (userId.isNotEmpty &&
                  (adminStatus == 'true' || adminStatus == 'false')) {
                try {
                  await FirebaseFirestore.instance
                      .collection('user_data')
                      .doc(userId)
                      .update({'isAdmin': adminStatus == 'true'});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Admin status updated')),
                  );
                  // Refresh the current user's admin status if it's the logged-in user
                  if (userId == globalProvider.userDataHelper.currentUserId) {
                    await globalProvider.refreshAdminStatus();
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text('Update Admin Status'),
          ),
          const SizedBox(height: 20),

          // Section 2: Friend Management
          const Text(
            'Friend Management',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: _friendIdController,
            decoration: const InputDecoration(labelText: 'Enter Friend ID'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              String friendId = _friendIdController.text.trim();
              if (friendId.isNotEmpty) {
                try {
                  await FriendsHelper.addFriend(friendId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Friend added')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text('Add Friend'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              String friendId = _friendIdController.text.trim();
              if (friendId.isNotEmpty) {
                try {
                  await FriendsHelper.removeFriend(friendId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Friend removed')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text('Remove Friend'),
          ),
          const SizedBox(height: 20),

          // Section 3: List All Friends Out
          const Text(
            'Friends Out',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          FutureBuilder<List<UserData>>(
            future: FriendsHelper.getFriendsOut(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading...');
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No friends out');
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: snapshot.data!.map((friend) {
                  return Text(
                      'ID: ${friend.id}, Status: ${friend.partyStatus}');
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 20),

          // Placeholder for Future Expansion
          const Text(
            'Add More Sections Below...',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Placeholder Buttons
          ElevatedButton(
            onPressed: () {
              print('Placeholder Button 1 pressed');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Placeholder Button 1 pressed')),
              );
            },
            child: const Text('Placeholder Button 1'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              print('Placeholder Button 2 pressed');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Placeholder Button 2 pressed')),
              );
            },
            child: const Text('Placeholder Button 2'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              print('Placeholder Button 3 pressed');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Placeholder Button 3 pressed')),
              );
            },
            child: const Text('Placeholder Button 3'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              print('Placeholder Button 4 pressed');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Placeholder Button 4 pressed')),
              );
            },
            child: const Text('Placeholder Button 4'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              print('Placeholder Button 5 pressed');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Placeholder Button 5 pressed')),
              );
            },
            child: const Text('Placeholder Button 5'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
