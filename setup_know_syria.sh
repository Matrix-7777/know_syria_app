#!/usr/bin/env bash
set -euo pipefail

sedi() { if sed --version >/dev/null 2>&1; then sed -i "$@"; else sed -i '' "$@"; fi; }

if [ ! -d android ]; then
  flutter create . --project-name know_syria --platforms=android
fi

mkdir -p lib/{models,data,providers,services,screens} test

cat << 'EOF' > pubspec.yaml
name: know_syria
description: A study app
publish_to: 'none'
version: 1.0.0+1
environment:
  sdk: '>=3.3.0 <4.0.0'
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.1
  speech_to_text: ^6.6.2
  flutter_tts: ^4.0.2
  shared_preferences: ^2.3.2
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
flutter:
  uses-material-design: true
EOF

cat << 'EOF' > lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_screen.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      home: const HomeScreen(),
    );
  }
}
EOF

cat << 'EOF' > lib/models/subject.dart
class Subject {
  final String name;
  final String gradeLevel;
  final String description;
  Subject({required this.name, required this.gradeLevel, required this.description});
}
EOF

cat << 'EOF' > lib/data/curriculum_data.dart
import '../models/subject.dart';

class CurriculumData {
  static List<Subject> allSubjects = [
    Subject(name: 'Arabic', gradeLevel: 'Grade 7', description: 'Grammar'),
    Subject(name: 'Math', gradeLevel: 'Grade 7', description: 'Algebra'),
    Subject(name: 'Physics', gradeLevel: 'Baccalaureate', description: 'Mechanics'),
  ];
  static List<String> get grades => allSubjects.map((s) => s.gradeLevel).toSet().toList();
  static List<Subject> byGrade(String g) => allSubjects.where((s) => s.gradeLevel == g).toList();
}
EOF

cat << 'EOF' > lib/providers/curriculum_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/curriculum_data.dart';
import '../models/subject.dart';

final gradesProvider = Provider<List<String>>((ref) => CurriculumData.grades);
final subjectsByGradeProvider = Provider.family<List<Subject>, String>((ref, g) => CurriculumData.byGrade(g));
EOF

cat << 'EOF' > lib/services/speech_service.dart
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  Future<void> startListening(Function(String) onResult) async {
    await _speech.initialize();
    await _speech.listen(onResult: (r) => onResult(r.recognizedWords));
  }
}
EOF

cat << 'EOF' > lib/services/tts_service.dart
import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _tts = FlutterTts();
  Future<void> speak(String text) async {
    await _tts.stop();
    await _tts.speak(text);
  }
}
EOF

cat << 'EOF' > lib/services/ai_service.dart
class AIService {
  Future<String> ask(String q) async {
    return 'AI answer for: $q (Demo)';
  }
}
EOF

cat << 'EOF' > lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'voice_assistant_screen.dart';
import 'whiteboard_screen.dart';
import 'curriculum_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Know Syria')),
      body: ListView(children: [
        ListTile(leading: const Icon(Icons.mic), title: const Text('Assistant'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VoiceAssistantScreen()))),
        ListTile(leading: const Icon(Icons.edit), title: const Text('Whiteboard'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WhiteboardScreen()))),
        ListTile(leading: const Icon(Icons.book), title: const Text('Curriculum'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CurriculumScreen()))),
      ]),
    );
  }
}
EOF

cat << 'EOF' > lib/screens/voice_assistant_screen.dart
import 'package:flutter/material.dart';
import '../services/speech_service.dart';
import '../services/tts_service.dart';
import '../services/ai_service.dart';

class VoiceAssistantScreen extends StatefulWidget {
  const VoiceAssistantScreen({super.key});
  @override
  State<VoiceAssistantScreen> createState() => _VoiceAssistantScreenState();
}

class _VoiceAssistantScreenState extends State<VoiceAssistantScreen> {
  final _speech = SpeechService();
  final _tts = TTSService();
  final _ai = AIService();
  final _ctrl = TextEditingController();
  String _ans = 'Ask me anything...';

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _send(String q) async {
    if (q.isEmpty) return;
    final a = await _ai.ask(q);
    if (!mounted) return;
    setState(() => _ans = a);
    _tts.speak(a);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assistant')),
      body: Column(children: [
        Expanded(child: Center(child: Text(_ans))),
        Row(children: [
          Expanded(child: TextField(controller: _ctrl)),
          IconButton(icon: const Icon(Icons.mic), onPressed: () => _speech.startListening((t) => _ctrl.text = t)),
          IconButton(icon: const Icon(Icons.send), onPressed: () => _send(_ctrl.text)),
        ]),
      ]),
    );
  }
}
EOF

cat << 'EOF' > lib/screens/whiteboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WhiteboardScreen extends StatefulWidget {
  const WhiteboardScreen({super.key});
  @override
  State<WhiteboardScreen> createState() => _WhiteboardScreenState();
}

class _WhiteboardScreenState extends State<WhiteboardScreen> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Whiteboard')),
      body: Column(children: [
        Expanded(child: TextField(controller: _ctrl, maxLines: null, expands: true, decoration: const InputDecoration(border: OutlineInputBorder()))),
        Row(children: [
          Expanded(child: ElevatedButton(onPressed: () => Clipboard.setData(ClipboardData(text: _ctrl.text)), child: const Text('Copy'))),
          Expanded(child: ElevatedButton(onPressed: () async { final d = await Clipboard.getData('text/plain'); _ctrl.text += d?.text ?? ''; }, child: const Text('Paste'))),
        ])
      ]),
    );
  }
}
EOF

cat << 'EOF' > lib/screens/curriculum_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/curriculum_provider.dart';

class CurriculumScreen extends ConsumerWidget {
  const CurriculumScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grades = ref.watch(gradesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Curriculum')),
      body: ListView.builder(
        itemCount: grades.length,
        itemBuilder: (c, i) => ExpansionTile(
          title: Text(grades[i]),
          children: ref.watch(subjectsByGradeProvider(grades[i])).map<Widget>((s) => ListTile(title: Text(s.name))).toList(),
        ),
      ),
    );
  }
}
EOF

cat << 'EOF' > test/widget_test.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:know_syria/main.dart';

void main() {
  testWidgets('home screen shows title', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    expect(find.text('Know Syria'), findsOneWidget);
  });
}
EOF

if [ -f android/app/build.gradle.kts ]; then
  sedi 's/minSdk = flutter.minSdkVersion/minSdk = 24/' android/app/build.gradle.kts
elif [ -f android/app/build.gradle ]; then
  sedi 's/minSdkVersion flutter.minSdkVersion/minSdkVersion 24/' android/app/build.gradle
fi

M=android/app/src/main/AndroidManifest.xml

if ! grep -q 'RECORD_AUDIO' "$M"; then
  awk '/<application/ && !done {
         print "    <uses-permission android:name=\"android.permission.RECORD_AUDIO\"/>"
         print "    <uses-permission android:name=\"android.permission.INTERNET\"/>"
         done=1
       } { print }' "$M" > "$M.tmp" && mv "$M.tmp" "$M"
fi

if ! grep -q 'android.speech.RecognitionService' "$M"; then
  if grep -q '<queries>' "$M"; then
    awk '{ print }
         /<queries>/ && !done {
           print "        <intent>"
           print "            <action android:name=\"android.speech.RecognitionService\"/>"
           print "        </intent>"
           done=1
         }' "$M" > "$M.tmp" && mv "$M.tmp" "$M"
  else
    awk '/<\/manifest>/ && !done {
           print "    <queries>"
           print "        <intent>"
           print "            <action android:name=\"android.speech.RecognitionService\"/>"
           print "        </intent>"
           print "    </queries>"
           done=1
         } { print }' "$M" > "$M.tmp" && mv "$M.tmp" "$M"
  fi
fi

flutter pub get
echo "Done. Run: flutter run"
