import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateAnnouncement extends StatelessWidget {
  static const routeName = '/announcement';

  const CreateAnnouncement({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announce'),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        child: BuildForm(),
      ),
    );
  }
}

class BuildForm extends StatefulWidget {
  const BuildForm({Key? key}) : super(key: key);

  @override
  State<BuildForm> createState() => _BuildFormState();
}

class _BuildFormState extends State<BuildForm> {
  final _formKey = GlobalKey<FormState>();
  final announcementController = TextEditingController();
  final linkController = TextEditingController();
  var doesContainLink = false;

  Future<bool> _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return false;
    }

    DateTime now = DateTime.now();
    Timestamp timestamp = Timestamp.fromDate(now);
    try {
      FirebaseFirestore.instance.collection('announcements').doc().set({
        'added_by': FirebaseAuth.instance.currentUser!.uid,
        'message': announcementController.text,
        'link': doesContainLink ? linkController.text : '',
        'dateAndTime': timestamp,
      });
      return true;
    } on FirebaseException catch (_) {
      // print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: announcementController,
              maxLines: 10,
              maxLength: 5000,
              decoration: InputDecoration(
                labelText: 'Announcement',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              textInputAction: TextInputAction.done,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a message for making an announcement';
                }
                if (value.split(RegExp(r'\s+')).length <= 15) {
                  return 'Please enter a message with more than 15 words';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text('Does the announcement contain a Link?'),
                Switch(
                  value: doesContainLink,
                  onChanged: (value) {
                    setState(() {
                      doesContainLink = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            if (doesContainLink)
              TextFormField(
                controller: linkController,
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'Link',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a link';
                  }

                  final RegExp urlPattern = RegExp(
                    r"^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$",
                    caseSensitive: false,
                  );

                  if (!urlPattern.hasMatch(value)) {
                    return 'Please enter a valid link';
                  }

                  return null; // Return null if the input is a valid link
                },
              ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () async {
                      await _submit()
                          ? {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Uploading was successful'),
                                ),
                              ),
                              // Navigator.of(context).pushReplacementNamed(
                              //     AnnouncementScreen.routeName,),
                            }
                          : ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Uploading was Unsuccessful'),
                              ),
                            );
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
