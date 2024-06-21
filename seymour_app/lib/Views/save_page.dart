import 'package:flutter/material.dart';

/*
 * The generic layout of this page was generated with the assistance of GPT-4 and has since been modified. 
 * 
 * The following prompt was used:
 * "I am designing a page to save items using flutter. I want a button at the bottom left to "save" 
 * placeholder items, so that when it is clicked, a keyboard will appear and after selecting confirm, 
 * a new row with the entered name will appear. There will also be a button on the bottom right, that 
 * does not have to do anything at the moment. Can you generate a dart file that will get me this page?"
 */

class SavePage extends StatefulWidget {
  const SavePage({super.key});

  @override
  State<SavePage> createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  // TODO: list of Row Widgets
  List<String> items = [];
  final TextEditingController _textController = TextEditingController();
  
  // TODO: click row widget to expand options

  void _showInputDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Save current journey as..."),
          content: TextField(
            controller: _textController,
            decoration: const InputDecoration(hintText: "Journey name"),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                _textController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Confirm"),
              onPressed: () {
                setState(() {
                  items.add(_textController.text);
                });
                _textController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _showInputDialog,
                child: const Text("SAVE AS"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Placeholder button, does nothing for now
                },
                child: const Text("IMPORT"),
              ),
            ),
          ],
        )
      )
    );
  }
}