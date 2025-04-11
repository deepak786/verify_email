import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:verify_email/email_corrector.dart';
import 'package:verify_email/export_data.dart';
import 'package:verify_email/validations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              hintText: 'Enter your email',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              final email = emailController.text.trim();

              if (Validations.isEmpty(email) ||
                  !Validations.isValidEmail(email)) {
                showToast('Please enter valid email');
                return;
              }

              final suggestion = EmailCorrector().getSuggestion(email);
              if (!Validations.isEmpty(suggestion)) {
                showSuggestions([suggestion!]);
                return;
              }

              showToast('Email is valid');
            },
            child: const Text('Submit'),
          ),
          if (kDebugMode) ...[
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                exportData();
              },
              child: const Text('Export data'),
            ),
          ],
        ],
      ),
    );
  }

  void showSuggestions(List<String> suggestions) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Did you mean...'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: suggestions.map((s) {
              return ListTile(
                title: Text(s),
                onTap: () {
                  Navigator.pop(context, s);
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    ).then((selectedEmail) {
      if (selectedEmail != null) {
        setState(() {
          emailController.text = selectedEmail;
        });
      }
    });
  }

  void showToast(String msg) {
    Fluttertoast.showToast(msg: msg, timeInSecForIosWeb: 3);
  }
}
