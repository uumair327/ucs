import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guardiancare/src/models/Forum.dart';
import 'package:guardiancare/src/models/Comment.dart';
import 'package:intl/intl.dart';
import 'package:guardiancare/src/screens/commentinput.dart';

class ForumWidget extends StatelessWidget {
  final Forum forum;
  const ForumWidget({Key? key, required this.forum}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                forum.title,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(239, 72, 53, 1),
                ),
              ),
              Text(DateFormat('dd MM yy hh:mm a').format(forum.createdAt)),
              const SizedBox(height: 10),
              Text(forum.description),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('forum')
                .doc(forum.id)
                .collection('comments')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              var comments = snapshot.data!.docs
                  .map((doc) => Comment.fromMap(doc.data()))
                  .toList();
              return Column(
                children: comments.map((comment) {
                  return ListTile(
                    title: Text(
                      comment.userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment.userEmail,
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 12),
                        ),
                        Text(comment.text),
                        Text(
                          DateFormat('dd MM yy hh:mm a')
                              .format(comment.createdAt),
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 12),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  );
                }).toList(),
              );
            },
          ),
          const Divider(),
          CommentInput(forumId: forum.id),
        ],
      ),
    );
  }
}
