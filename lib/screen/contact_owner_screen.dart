import 'package:flutter/material.dart';
import 'package:petapp/services/user_firestore_service.dart';

class ContactOwnerScreen extends StatelessWidget {
  final String ownerId;

  const ContactOwnerScreen({
    super.key,
    required this.ownerId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Owner Details"),
      ),
      body: FutureBuilder(
        future: UserFirestoreService().getUserById(ownerId),
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          }

          // No Data
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text("Owner details not found"),
            );
          }

          final data = snapshot.data!.data()!;

          final name = data['name'] ?? 'N/A';
          final email = data['email'] ?? 'N/A';
          final phone = data['phone'] ?? 'N/A';

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 20),

                    _infoRow("Name", name),
                    const SizedBox(height: 10),

                    _infoRow("Email", email),
                    const SizedBox(height: 10),

                    _infoRow("Phone", phone),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
