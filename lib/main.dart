import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keep Note',
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xff1F1F1F)),
      home: const MyHomePage(title: 'Keep Note Home Page'),
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
  final List<Map<String, String>> notes = []; // Specify the type explicitly

  void _showOverlay(BuildContext context) async {
    await Navigator.of(context).push(
      AddOverlay(
        notes: notes,
        onAddNote: (String? title, String? note) {
          notes.add({'title': title ?? '', 'note': note ?? ''});
        },
      ),
    );

    // After popping the overlay, call setState to update the UI with the new notes list
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: textController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search Note',
            hintStyle: const TextStyle(color: Colors.white),
            contentPadding:
                const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(50),
            ),
            filled: true,
            fillColor: const Color(0xff2D2D2D),
            suffixIcon: IconButton(
              onPressed: () {
                //
              },
              icon: const Icon(Icons.wc_rounded),
            ),
          ),
        ),
        backgroundColor: const Color(0xff1F1F1F),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: buildNoteCards(notes),
              ),
            ),
            const BottomBox(),
          ],
        ),
      ),
      floatingActionButton: Transform.translate(
        offset: const Offset(0, -10),
        child: FloatingActionButton(
          backgroundColor: const Color(0xff2F2E33),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(width: 5, color: Color(0xff1F1F1F)),
          ),
          onPressed: () => _showOverlay(context),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

List<Widget> buildNoteCards(List<Map<String, String>> notes) {
  return notes.map((note) {
    return Card(
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note['title'] ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              note['note'] ?? '',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }).toList();
}

class BottomBox extends StatelessWidget {
  const BottomBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16.0),
        color: const Color(0xff2F2E33),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: addGap(
            gapSize: 20,
            children: [
              const Icon(Icons.home, color: Colors.white),
              const Icon(Icons.search, color: Colors.white),
              const Icon(Icons.favorite, color: Colors.white),
              const Icon(Icons.settings, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

List<Widget> addGap({required double gapSize, required List<Widget> children}) {
  List<Widget> spacedChildren = [];
  for (int i = 0; i < children.length; i++) {
    spacedChildren.add(children[i]);
    if (i < children.length - 1) {
      spacedChildren.add(SizedBox(width: gapSize));
    }
  }
  return spacedChildren;
}

class AddOverlay extends ModalRoute<void> {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.canvas,
      color: const Color(0xff1F1F1F),
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  var notes = [];
  final Function(String? title, String? note) onAddNote;

  AddOverlay({required this.notes, required this.onAddNote});

  Widget _buildOverlayContent(BuildContext context) {
    final note = TextEditingController();
    final title = TextEditingController();

    void onBackPressed() {
      final String titleText = title.text;
      final String noteText = note.text;
      onAddNote(titleText, noteText); // Add the note to the list
      Navigator.of(context).pop();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // back button
        IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          color: Colors.white,
          onPressed: () => onBackPressed(),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12), // Adjust the value as needed
            child: Column(
              children: [
                TextField(
                  autofocus: true,
                  controller: title,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Title',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ), // Add some space between the two fields
                Expanded(
                  child: TextField(
                    autofocus: true,
                    controller: note,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Note',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
