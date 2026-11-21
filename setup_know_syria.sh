#!/usr/bin/env bash
set -euo pipefail

sedi() { if sed --version >/dev/null 2>&1; then sed -i "$@"; else sed -i '' "$@"; fi; }

if [ ! -d android ]; then
  flutter create . --project-name know_syria --platforms=android
fi

mkdir -p lib/screens lib/services test

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
  speech_to_text: ^7.2.0
  flutter_tts: ^4.0.2
  shared_preferences: ^2.3.2
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
flutter:
  uses-material-design: true
EOF

cat << 'EOF' > lib/data.dart
import 'package:flutter/material.dart';

class Flashcard {
  final String question;
  final String answer;
  const Flashcard(this.question, this.answer);
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correct;
  const QuizQuestion(this.question, this.options, this.correct);
}

class Subject {
  final String name;
  final IconData icon;
  final Color color;
  final List<String> grades;
  final List<Flashcard> cards;
  final List<QuizQuestion> quiz;
  const Subject({
    required this.name,
    required this.icon,
    required this.color,
    required this.grades,
    required this.cards,
    required this.quiz,
  });
}

class AppData {
  static const List<String> grades = ['الكل', 'السابع', 'التاسع', 'البكالوريا'];

  static const List<Subject> subjects = [
    Subject(
      name: 'اللغة العربية',
      icon: Icons.menu_book_rounded,
      color: Color(0xFF8E44AD),
      grades: ['السابع', 'التاسع'],
      cards: [
        Flashcard('ما حكم إعراب الفاعل؟', 'مرفوع'),
        Flashcard('ما جمع كلمة (كتاب)؟', 'كُتُب'),
        Flashcard('ما ضد كلمة (كريم)؟', 'بخيل'),
      ],
      quiz: [
        QuizQuestion('ما نوع الكلمة (كتب) في جملة: كتب الطالب الدرس؟', ['اسم', 'فعل ماضٍ', 'حرف', 'فعل أمر'], 1),
        QuizQuestion('ما إعراب كلمة (الطالب) في: كتب الطالب الدرس؟', ['فاعل مرفوع', 'مفعول به منصوب', 'مبتدأ مرفوع', 'خبر مرفوع'], 0),
      ],
    ),
    Subject(
      name: 'الرياضيات',
      icon: Icons.calculate_rounded,
      color: Color(0xFF2980B9),
      grades: ['السابع', 'التاسع', 'البكالوريا'],
      cards: [
        Flashcard('ما ناتج 12 × 12؟', '144'),
        Flashcard('ما مساحة المستطيل؟', 'الطول × العرض'),
        Flashcard('ما مجموع زوايا المثلث؟', '180 درجة'),
      ],
      quiz: [
        QuizQuestion('ما ناتج 7 + 8 × 2؟', ['30', '23', '22', '16'], 1),
        QuizQuestion('ما محيط مربع طول ضلعه 5 سم؟', ['10 سم', '15 سم', '20 سم', '25 سم'], 2),
        QuizQuestion('ما ناتج 3² + 4²؟', ['25', '24', '49', '14'], 0),
      ],
    ),
    Subject(
      name: 'الفيزياء',
      icon: Icons.bolt_rounded,
      color: Color(0xFFE67E22),
      grades: ['التاسع', 'البكالوريا'],
      cards: [
        Flashcard('ما وحدة قياس القوة؟', 'النيوتن (N)'),
        Flashcard('ما نص قانون نيوتن الثاني؟', 'القوة = الكتلة × التسارع'),
        Flashcard('ما سرعة الضوء في الفراغ تقريباً؟', '300000 كم/ث تقريباً'),
      ],
      quiz: [
        QuizQuestion('ما وحدة قياس الطاقة؟', ['نيوتن', 'جول', 'واط', 'باسكال'], 1),
        QuizQuestion('أي مما يلي كمية متجهة؟', ['المسافة', 'الزمن', 'الإزاحة', 'الكتلة'], 2),
      ],
    ),
    Subject(
      name: 'الكيمياء',
      icon: Icons.science_rounded,
      color: Color(0xFF16A085),
      grades: ['التاسع', 'البكالوريا'],
      cards: [
        Flashcard('ما الصيغة الكيميائية للماء؟', 'H₂O'),
        Flashcard('ما رمز عنصر الصوديوم؟', 'Na'),
        Flashcard('ما العدد الذري للهيدروجين؟', '1'),
      ],
      quiz: [
        QuizQuestion('ما رمز عنصر الذهب؟', ['Ag', 'Au', 'Fe', 'Gd'], 1),
        QuizQuestion('ما الغاز الأكثر وجوداً في الغلاف الجوي؟', ['الأكسجين', 'النيتروجين', 'ثاني أكسيد الكربون', 'الهيدروجين'], 1),
      ],
    ),
    Subject(
      name: 'الأحياء',
      icon: Icons.biotech_rounded,
      color: Color(0xFF27AE60),
      grades: ['التاسع', 'البكالوريا'],
      cards: [
        Flashcard('ما وظيفة الميتوكوندريا؟', 'إنتاج الطاقة للخلية'),
        Flashcard('ما العملية التي تصنع بها النباتات غذاءها؟', 'البناء الضوئي'),
        Flashcard('كم عدد الكروموسومات في خلايا الإنسان الجسدية؟', '46 كروموسوماً (23 زوجاً)'),
      ],
      quiz: [
        QuizQuestion('أي عضو يضخ الدم في الجسم؟', ['الكبد', 'الرئتان', 'القلب', 'الكلية'], 2),
        QuizQuestion('ما الغاز الذي تمتصه النباتات في البناء الضوئي؟', ['الأكسجين', 'ثاني أكسيد الكربون', 'النيتروجين', 'الهيدروجين'], 1),
      ],
    ),
    Subject(
      name: 'الاجتماعيات',
      icon: Icons.public_rounded,
      color: Color(0xFFC0392B),
      grades: ['السابع', 'التاسع'],
      cards: [
        Flashcard('ما عاصمة سوريا؟', 'دمشق'),
        Flashcard('ما أطول نهر يعبر سوريا؟', 'نهر الفرات'),
        Flashcard('على أي بحر تطل سوريا؟', 'البحر الأبيض المتوسط'),
      ],
      quiz: [
        QuizQuestion('ما عاصمة سوريا؟', ['حلب', 'حمص', 'دمشق', 'اللاذقية'], 2),
        QuizQuestion('أي مدينة سورية تقع على الساحل؟', ['حماة', 'اللاذقية', 'دير الزور', 'السويداء'], 1),
      ],
    ),
    Subject(
      name: 'اللغة الإنجليزية',
      icon: Icons.translate_rounded,
      color: Color(0xFF34495E),
      grades: ['السابع', 'التاسع', 'البكالوريا'],
      cards: [
        Flashcard('Book', 'كتاب'),
        Flashcard('Teacher', 'معلّم'),
        Flashcard('Apple', 'تفاحة'),
      ],
      quiz: [
        QuizQuestion('She ___ to school every day.', ['go', 'goes', 'going', 'gone'], 1),
        QuizQuestion("What is the plural of 'child'?", ['childs', 'childes', 'children', 'childrens'], 2),
      ],
    ),
  ];
}
EOF

cat << 'EOF' > lib/widgets.dart
import 'package:flutter/material.dart';
import 'data.dart';

class SubjectTile extends StatelessWidget {
  final Subject subject;
  final VoidCallback onTap;
  const SubjectTile({super.key, required this.subject, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        leading: CircleAvatar(
          backgroundColor: subject.color.withAlpha(40),
          child: Icon(subject.icon, color: subject.color),
        ),
        title: Text(subject.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${subject.cards.length} بطاقات • ${subject.quiz.length} أسئلة'),
        trailing: const Icon(Icons.chevron_left),
      ),
    );
  }
}

class SubjectCard extends StatelessWidget {
  final Subject subject;
  final VoidCallback onTap;
  const SubjectCard({super.key, required this.subject, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: subject.color.withAlpha(40),
                child: Icon(subject.icon, color: subject.color, size: 26),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subject.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${subject.cards.length} بطاقات', style: const TextStyle(color: Colors.black54, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
EOF

cat << 'EOF' > lib/main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/subjects_screen.dart';
import 'screens/assistant_screen.dart';
import 'screens/notes_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Know Syria',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C4DFF)),
        scaffoldBackgroundColor: const Color(0xFFF7F5FF),
      ),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      home: const RootScreen(),
    );
  }
}

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _index = 0;

  void _go(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeScreen(onNavigate: _go),
      const SubjectsScreen(),
      const AssistantScreen(),
      const NotesScreen(),
    ];
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: _index, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _go,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.grid_view_outlined), selectedIcon: Icon(Icons.grid_view_rounded), label: 'المواد'),
          NavigationDestination(icon: Icon(Icons.smart_toy_outlined), selectedIcon: Icon(Icons.smart_toy), label: 'المساعد'),
          NavigationDestination(icon: Icon(Icons.edit_note_outlined), selectedIcon: Icon(Icons.edit_note), label: 'ملاحظاتي'),
        ],
      ),
    );
  }
}
EOF

cat << 'EOF' > lib/services/speech_service.dart
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _ready = false;

  Future<bool> start(void Function(String text, bool isFinal) onResult) async {
    if (!_ready) {
      _ready = await _speech.initialize();
    }
    if (!_ready) return false;
    await _speech.listen(
      localeId: 'ar_SA',
      onResult: (r) => onResult(r.recognizedWords, r.finalResult),
    );
    return true;
  }

  Future<void> stop() async {
    await _speech.stop();
  }
}
EOF

cat << 'EOF' > lib/services/tts_service.dart
import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _tts = FlutterTts();

  Future<void> speak(String text) async {
    await _tts.setLanguage('ar');
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}
EOF

cat << 'EOF' > lib/screens/home_screen.dart
import 'dart:math';
import 'package:flutter/material.dart';
import '../data.dart';
import '../widgets.dart';
import 'subject_screen.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int) onNavigate;
  const HomeScreen({super.key, required this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query = '';

  void _openSubject(Subject s) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => SubjectScreen(subject: s)));
  }

  void _randomQuiz() {
    final s = AppData.subjects[Random().nextInt(AppData.subjects.length)];
    Navigator.push(context, MaterialPageRoute(builder: (_) => QuizScreen(subject: s)));
  }

  @override
  Widget build(BuildContext context) {
    final q = _query.trim();
    final list = AppData.subjects.where((s) => s.name.contains(q)).toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6C4DFF), Color(0xFF9B7BFF)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('أهلاً بك في Know Syria 👋', style: TextStyle(color: Colors.white70, fontSize: 15)),
              SizedBox(height: 8),
              Text(
                'ماذا تريد أن تتعلم اليوم؟',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          onChanged: (v) => setState(() => _query = v),
          decoration: InputDecoration(
            hintText: 'ابحث عن مادة...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _Tool(icon: Icons.grid_view_rounded, label: 'المواد', color: const Color(0xFF6C4DFF), onTap: () => widget.onNavigate(1))),
            Expanded(child: _Tool(icon: Icons.smart_toy_rounded, label: 'المساعد', color: const Color(0xFF16A085), onTap: () => widget.onNavigate(2))),
            Expanded(child: _Tool(icon: Icons.edit_note_rounded, label: 'ملاحظاتي', color: const Color(0xFFE67E22), onTap: () => widget.onNavigate(3))),
            Expanded(child: _Tool(icon: Icons.bolt_rounded, label: 'اختبار سريع', color: const Color(0xFFE84393), onTap: _randomQuiz)),
          ],
        ),
        const SizedBox(height: 20),
        const Text('موادك', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        if (list.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text('لا توجد نتائج')),
          ),
        ...list.map((s) => SubjectTile(subject: s, onTap: () => _openSubject(s))),
      ],
    );
  }
}

class _Tool extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _Tool({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withAlpha(40),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
EOF

cat << 'EOF' > lib/screens/subjects_screen.dart
import 'package:flutter/material.dart';
import '../data.dart';
import '../widgets.dart';
import 'subject_screen.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  String _grade = 'الكل';

  @override
  Widget build(BuildContext context) {
    final list = AppData.subjects.where((s) => _grade == 'الكل' || s.grades.contains(_grade)).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text('المواد الدراسية', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: AppData.grades.map<Widget>((g) {
              return Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: ChoiceChip(
                  label: Text(g),
                  selected: _grade == g,
                  onSelected: (_) => setState(() => _grade = g),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(16),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: list.map<Widget>((s) {
              return SubjectCard(
                subject: s,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SubjectScreen(subject: s)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
EOF

cat << 'EOF' > lib/screens/subject_screen.dart
import 'package:flutter/material.dart';
import '../data.dart';
import 'flashcards_screen.dart';
import 'quiz_screen.dart';

class SubjectScreen extends StatelessWidget {
  final Subject subject;
  const SubjectScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(subject.name), backgroundColor: Colors.transparent),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: _ActionCard(
                  icon: Icons.style_rounded,
                  label: 'البطاقات التعليمية',
                  color: subject.color,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => FlashcardsScreen(subject: subject)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionCard(
                  icon: Icons.quiz_rounded,
                  label: 'اختبر نفسك',
                  color: subject.color,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => QuizScreen(subject: subject)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('ملخص سريع', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...subject.cards.map(
            (c) => Card(
              elevation: 0,
              color: Colors.white,
              child: ExpansionTile(
                shape: const Border(),
                collapsedShape: const Border(),
                title: Text(c.question),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(c.answer, style: TextStyle(color: subject.color, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionCard({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 36),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
EOF

cat << 'EOF' > lib/screens/flashcards_screen.dart
import 'package:flutter/material.dart';
import '../data.dart';

class FlashcardsScreen extends StatefulWidget {
  final Subject subject;
  const FlashcardsScreen({super.key, required this.subject});

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  int _i = 0;
  bool _showAnswer = false;

  void _move(int delta) {
    final next = _i + delta;
    if (next < 0 || next >= widget.subject.cards.length) return;
    setState(() {
      _i = next;
      _showAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cards = widget.subject.cards;
    final card = cards[_i];
    final color = widget.subject.color;
    return Scaffold(
      appBar: AppBar(title: Text('بطاقات ${widget.subject.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('${_i + 1} / ${cards.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (_i + 1) / cards.length,
                minHeight: 8,
                color: color,
                backgroundColor: color.withAlpha(40),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _showAnswer = !_showAnswer),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Container(
                    key: ValueKey('$_i-$_showAnswer'),
                    width: double.infinity,
                    height: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: _showAnswer ? color : Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _showAnswer ? 'الإجابة' : 'السؤال',
                          style: TextStyle(color: _showAnswer ? Colors.white70 : color, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _showAnswer ? card.answer : card.question,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _showAnswer ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'اضغط لقلب البطاقة',
                          style: TextStyle(color: _showAnswer ? Colors.white60 : Colors.black45),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _i == 0 ? null : () => _move(-1),
                    child: const Text('السابق'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _i == cards.length - 1 ? null : () => _move(1),
                    child: const Text('التالي'),
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
EOF

cat << 'EOF' > lib/screens/quiz_screen.dart
import 'package:flutter/material.dart';
import '../data.dart';

class QuizScreen extends StatefulWidget {
  final Subject subject;
  const QuizScreen({super.key, required this.subject});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _i = 0;
  int _score = 0;
  int? _picked;
  bool _done = false;

  void _pick(int index) {
    if (_picked != null) return;
    setState(() {
      _picked = index;
      if (index == widget.subject.quiz[_i].correct) _score++;
    });
  }

  void _next() {
    if (_i == widget.subject.quiz.length - 1) {
      setState(() => _done = true);
    } else {
      setState(() {
        _i++;
        _picked = null;
      });
    }
  }

  void _restart() {
    setState(() {
      _i = 0;
      _score = 0;
      _picked = null;
      _done = false;
    });
  }

  Widget _option(QuizQuestion q, int k) {
    Color bg = Colors.white;
    Color border = Colors.black12;
    IconData? icon;
    if (_picked != null) {
      if (k == q.correct) {
        bg = const Color(0xFFE3F7E8);
        border = Colors.green;
        icon = Icons.check_circle;
      } else if (k == _picked) {
        bg = const Color(0xFFFDE7E7);
        border = Colors.red;
        icon = Icons.cancel;
      }
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _pick(k),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: border),
            ),
            child: Row(
              children: [
                Expanded(child: Text(q.options[k], style: const TextStyle(fontSize: 16))),
                if (icon != null) Icon(icon, color: border),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quiz = widget.subject.quiz;
    final total = quiz.length;
    final color = widget.subject.color;

    if (_done) {
      final msg = _score == total
          ? 'ممتاز! 🎉'
          : (_score >= total / 2 ? 'جيد، تابع التقدّم 👍' : 'حاول مرة أخرى 💪');
      return Scaffold(
        appBar: AppBar(title: Text('اختبار ${widget.subject.name}')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.emoji_events_rounded, size: 90, color: Colors.amber),
                const SizedBox(height: 16),
                Text('نتيجتك: $_score من $total', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(msg, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 24),
                FilledButton(onPressed: _restart, child: const Text('إعادة الاختبار')),
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('رجوع')),
              ],
            ),
          ),
        ),
      );
    }

    final q = quiz[_i];
    return Scaffold(
      appBar: AppBar(title: Text('اختبار ${widget.subject.name}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('السؤال ${_i + 1} من $total', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (_i + 1) / total,
                minHeight: 8,
                color: color,
                backgroundColor: color.withAlpha(40),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(q.question, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            for (var k = 0; k < q.options.length; k++) _option(q, k),
            const SizedBox(height: 8),
            if (_picked != null)
              FilledButton(
                onPressed: _next,
                child: Text(_i == total - 1 ? 'عرض النتيجة' : 'السؤال التالي'),
              ),
          ],
        ),
      ),
    );
  }
}
EOF

cat << 'EOF' > lib/assistant_engine.dart
import 'dart:math' as math;

class KbEntry {
  final String subject;
  final String question;
  final String answer;
  final String keys;
  final double boost;
  const KbEntry(this.subject, this.question, this.answer,
      [this.keys = '', this.boost = 0]);
}

class _Hit {
  final KbEntry entry;
  final double score;
  final int matched;
  const _Hit(this.entry, this.score, this.matched);
}

class AssistantEngine {
  static const String notFound =
      'لم أجد جواباً دقيقاً لهذا السؤال في معلوماتي الحالية. جرّب صياغة أخرى بكلمات مفتاحية، أو اضغط ➕ بالأعلى وعلّمني الجواب وسأتذكره.';

  static const List<String> _rawStop = [
    'ما',
    'ماذا',
    'هو',
    'هي',
    'هم',
    'من',
    'في',
    'على',
    'عن',
    'إلى',
    'كم',
    'كيف',
    'لماذا',
    'لما',
    'متى',
    'أين',
    'هل',
    'الذي',
    'التي',
    'هذا',
    'هذه',
    'ذلك',
    'تلك',
    'أو',
    'أن',
    'إن',
    'أنا',
    'لي',
    'لك',
    'به',
    'بها',
    'له',
    'لها',
    'هناك',
    'أريد',
    'أعرف',
    'أخبرني',
    'اشرح',
    'شرح',
    'عرف',
    'وضح',
    'اذكر',
    'قل',
    'يعني',
    'معنى',
    'كلمة',
    'عدد',
    'اكتب',
    'أعطني',
    'ممكن',
    'لو',
    'سمحت',
    'يكون',
    'تكون',
    'شو',
    'ايش',
    'إيش',
    'وش',
    'ليش',
    'مين',
    'وين',
    'قديش',
    'كام',
    'شلون',
    'تعريف',
    'مفهوم',
  ];

  static final Set<String> _stop = _rawStop.map(normalize).toSet();

  static String _digits(String input) {
    var s = input;
    const arabicIndic = '٠١٢٣٤٥٦٧٨٩';
    const eastern = '۰۱۲۳۴۵۶۷۸۹';
    for (var d = 0; d < 10; d++) {
      s = s.replaceAll(arabicIndic[d], '$d').replaceAll(eastern[d], '$d');
    }
    return s;
  }

  static String normalize(String input) {
    var s = _digits(input.toLowerCase());
    s = s.replaceAll(RegExp('[\u064B-\u0652\u0670\u0640]'), '');
    s = s.replaceAll(RegExp('[أإآٱ]'), 'ا');
    s = s
        .replaceAll('ى', 'ي')
        .replaceAll('ة', 'ه')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي');
    return s;
  }

  static final RegExp _nonWord = RegExp('[^\u0621-\u063A\u0641-\u064Aa-z0-9 ]');

  static String _clean(String s) => normalize(s).replaceAll(_nonWord, ' ');

  static String _stem(String t) {
    if (t.length > 5 &&
        (t.startsWith('وال') ||
            t.startsWith('بال') ||
            t.startsWith('كال') ||
            t.startsWith('فال'))) {
      return t.substring(3);
    }
    if (t.length > 4 && (t.startsWith('ال') || t.startsWith('لل'))) {
      return t.substring(2);
    }
    return t;
  }

  static List<String> tokens(String s) {
    final out = <String>[];
    for (final raw in _clean(s).split(' ')) {
      if (raw.isEmpty) continue;
      final t = _stem(raw);
      if (_stop.contains(raw) || _stop.contains(t)) continue;
      if (t.length < 2 && !RegExp(r'^[a-z0-9]$').hasMatch(t)) continue;
      out.add(t);
    }
    return out;
  }

  static bool _partial(String t, List<String> words) {
    if (t.length < 3) return false;
    for (final w in words) {
      if (w.length >= 3 && (w.startsWith(t) || t.startsWith(w))) return true;
    }
    return false;
  }

  static String? _smalltalk(String cleaned) {
    final w = cleaned.split(' ').where((x) => x.isNotEmpty).toSet();
    if (w.contains('مرحبا') ||
        w.contains('اهلا') ||
        w.contains('هلا') ||
        w.contains('سلام') ||
        w.contains('السلام')) {
      return 'أهلاً بك! اسألني عن موادك الدراسية، أو اكتب عملية حسابية مثل 12 × 12 وسأحسبها لك.';
    }
    if (w.contains('شكرا') || w.contains('مشكور') || w.contains('يعطيك')) {
      return 'العفو! بالتوفيق في دراستك 🌟';
    }
    if (w.contains('حالك') || w.contains('اخبارك')) {
      return 'أنا بخير، شكراً لسؤالك! كيف أساعدك في دراستك اليوم؟';
    }
    if ((w.contains('انت') && w.contains('من')) || w.contains('اسمك')) {
      return 'أنا مساعد Know Syria للدراسة. أجيب من المعلومات المخزّنة في التطبيق ومن المعلومات التي تعلّمني إياها.';
    }
    return null;
  }

  static String reply(String input, List<KbEntry> kb) {
    final text = input.trim();
    if (text.isEmpty) return '';

    final calc = _tryCalc(text);
    if (calc != null) return calc;

    final small = _smalltalk(_clean(text));
    if (small != null) return small;

    final q = tokens(text);
    if (q.isEmpty) return notFound;

    final n = kb.length;
    final eqs = <List<String>>[];
    final eas = <List<String>>[];
    final qos = <List<String>>[];
    final df = <String, int>{};
    for (final e in kb) {
      final eq = tokens('${e.question} ${e.keys} ${e.subject}');
      eqs.add(eq);
      eas.add(tokens(e.answer));
      qos.add(tokens(e.question));
      for (final t in eq.toSet()) {
        df[t] = (df[t] ?? 0) + 1;
      }
    }
    double weight(String t) {
      final v = 1 + math.log(n / ((df[t] ?? 0) + 1));
      return v < 1 ? 1 : v;
    }

    final strong = <_Hit>[];
    final weak = <_Hit>[];
    for (var i = 0; i < n; i++) {
      final eq = eqs[i];
      final ea = eas[i];
      var score = 0.0;
      var matched = 0;
      for (final t in q) {
        final w = weight(t);
        if (eq.contains(t)) {
          score += w;
          matched++;
        } else if (_partial(t, eq)) {
          score += w * 0.66;
          matched++;
        } else if (ea.contains(t)) {
          score += w * 0.33;
          matched++;
        }
      }
      if (matched == 0) continue;
      if (matched == q.length) score += 1.5;
      final qo = qos[i];
      if (qo.isNotEmpty) {
        var cover = 0;
        for (final t in qo) {
          if (q.contains(t)) cover++;
        }
        score += 2 * cover / qo.length;
      }
      final h = _Hit(kb[i], score + kb[i].boost, matched);
      if (matched >= 2 || (q.length == 1 && score >= 2)) {
        strong.add(h);
      } else if (score >= 4) {
        weak.add(h);
      }
    }

    if (strong.isEmpty) {
      if (weak.isEmpty) return notFound;
      weak.sort((a, b) => b.score.compareTo(a.score));
      final sb = StringBuffer(
          'لم أجد جواباً مطابقاً تماماً. هل تقصد أحد هذه الأسئلة؟');
      for (final h in weak.take(3)) {
        sb.write('\n• ${h.entry.question}');
      }
      return sb.toString();
    }

    strong.sort((a, b) => b.score.compareTo(a.score));
    final best = strong.first;
    final sb = StringBuffer(
        '📌 ${best.entry.subject}\n❓ ${best.entry.question}\n✅ ${best.entry.answer}');
    final related = strong
        .skip(1)
        .where((h) =>
            h.entry.question != best.entry.question &&
            h.score >= best.score * 0.6)
        .take(2)
        .toList();
    if (related.isNotEmpty) {
      sb.write('\n\nأسئلة قريبة:');
      for (final h in related) {
        sb.write('\n• ${h.entry.question}');
      }
    }
    return sb.toString();
  }

  // ---------- Calculator ----------

  static String? _tryCalc(String text) {
    var s = _digits(text.toLowerCase());
    s = s
        .replaceAll('×', '*')
        .replaceAll('✕', '*')
        .replaceAll('÷', '/')
        .replaceAll('−', '-')
        .replaceAll('–', '-')
        .replaceAll('²', '^2')
        .replaceAll('³', '^3')
        .replaceAll('زائد', '+')
        .replaceAll('ناقص', '-')
        .replaceAll('ضرب', '*')
        .replaceAll('تقسيم', '/');
    s = s.replaceAllMapped(
        RegExp(r'(\d)\s*x\s*(\d)'), (m) => '${m[1]}*${m[2]}');
    if (s.contains('جذر')) {
      s = s
          .replaceAll('الجذر التربيعي', '√')
          .replaceAll('جذر', '√')
          .replaceAll(RegExp(r'(للعدد|لعدد|العدد)'), ' ');
    }
    for (final m in RegExp(r'[0-9.()+\-*/^√\s]+').allMatches(s)) {
      var c = m.group(0)!.trim().replaceAll(RegExp(r'[.\s]+$'), '');
      if (!RegExp(r'\d').hasMatch(c)) continue;
      final hasOp =
          RegExp(r'[+*/^√]').hasMatch(c) || RegExp(r'\d\s*-\s*\d').hasMatch(c);
      if (!hasOp) continue;
      try {
        final v = _Parser(c).parse();
        return '🧮 النتيجة: ${_fmt(v)}';
      } on ArithmeticException {
        return 'لا يمكن القسمة على صفر.';
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  static String _fmt(double v) {
    if (v.isNaN || v.isInfinite) throw const FormatException('bad');
    if (v == v.roundToDouble() && v.abs() < 1e15) return v.toInt().toString();
    var t = v.toStringAsFixed(6);
    t = t.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
    return t;
  }
}

class ArithmeticException implements Exception {
  const ArithmeticException();
}

class _Parser {
  final String s;
  int i = 0;
  _Parser(this.s);

  double parse() {
    final v = _expr();
    _ws();
    if (i != s.length) throw const FormatException('extra');
    return v;
  }

  void _ws() {
    while (i < s.length && s[i] == ' ') {
      i++;
    }
  }

  bool _peek(String ch) {
    _ws();
    return i < s.length && s[i] == ch;
  }

  double _expr() {
    var v = _term();
    while (true) {
      if (_peek('+')) {
        i++;
        v += _term();
      } else if (_peek('-')) {
        i++;
        v -= _term();
      } else {
        break;
      }
    }
    return v;
  }

  double _term() {
    var v = _pow();
    while (true) {
      if (_peek('*')) {
        i++;
        v *= _pow();
      } else if (_peek('/')) {
        i++;
        final d = _pow();
        if (d == 0) throw const ArithmeticException();
        v /= d;
      } else {
        break;
      }
    }
    return v;
  }

  double _pow() {
    final b = _unary();
    if (_peek('^')) {
      i++;
      final e = _pow();
      return math.pow(b, e).toDouble();
    }
    return b;
  }

  double _unary() {
    if (_peek('-')) {
      i++;
      return -_unary();
    }
    if (_peek('+')) {
      i++;
      return _unary();
    }
    return _atom();
  }

  double _atom() {
    _ws();
    if (i >= s.length) throw const FormatException('end');
    if (s[i] == '(') {
      i++;
      final v = _expr();
      if (!_peek(')')) throw const FormatException('paren');
      i++;
      return v;
    }
    if (s[i] == '√') {
      i++;
      final v = _unary();
      if (v < 0) throw const FormatException('sqrt');
      return math.sqrt(v);
    }
    final start = i;
    while (i < s.length &&
        (s.codeUnitAt(i) >= 48 && s.codeUnitAt(i) <= 57 || s[i] == '.')) {
      i++;
    }
    if (start == i) throw const FormatException('num');
    return double.parse(s.substring(start, i));
  }
}
EOF

cat << 'EOF' > lib/knowledge.dart
import 'assistant_engine.dart';

class Knowledge {
  static const List<KbEntry> facts = [
    // ---------------- الرياضيات ----------------
    KbEntry(
        'الرياضيات', 'ما مساحة المستطيل؟', 'مساحة المستطيل = الطول × العرض.'),
    KbEntry('الرياضيات', 'ما محيط المستطيل؟',
        'محيط المستطيل = 2 × (الطول + العرض).'),
    KbEntry('الرياضيات', 'ما مساحة المربع؟',
        'مساحة المربع = طول الضلع × طول الضلع.'),
    KbEntry('الرياضيات', 'ما محيط المربع؟', 'محيط المربع = 4 × طول الضلع.'),
    KbEntry('الرياضيات', 'ما مساحة المثلث؟',
        'مساحة المثلث = ½ × القاعدة × الارتفاع.'),
    KbEntry('الرياضيات', 'ما محيط المثلث؟',
        'محيط المثلث = مجموع أطوال أضلاعه الثلاثة.'),
    KbEntry('الرياضيات', 'ما مساحة الدائرة؟',
        'مساحة الدائرة = π × نق²، حيث نق نصف القطر.'),
    KbEntry('الرياضيات', 'ما محيط الدائرة؟', 'محيط الدائرة = 2 × π × نق.'),
    KbEntry('الرياضيات', 'ما مساحة متوازي الأضلاع؟',
        'مساحة متوازي الأضلاع = القاعدة × الارتفاع.'),
    KbEntry(
        'الرياضيات', 'ما مساحة المعين؟', 'مساحة المعين = ½ × حاصل ضرب قطريه.'),
    KbEntry('الرياضيات', 'ما مساحة شبه المنحرف؟',
        'مساحة شبه المنحرف = ½ × (مجموع القاعدتين) × الارتفاع.'),
    KbEntry('الرياضيات', 'ما قيمة π تقريباً؟', 'π ≈ 3.14 (أو 22/7 تقريباً).',
        'باي ط النسبة التقريبية'),
    KbEntry('الرياضيات', 'ما مجموع زوايا المثلث؟',
        'مجموع زوايا المثلث = 180 درجة.'),
    KbEntry('الرياضيات', 'ما مجموع زوايا الشكل الرباعي؟',
        'مجموع زوايا الشكل الرباعي = 360 درجة.'),
    KbEntry('الرياضيات', 'ما نص نظرية فيثاغورس؟',
        'في المثلث القائم الزاوية: مربع الوتر = مجموع مربعي الضلعين القائمين، أي أ² + ب² = ج².'),
    KbEntry('الرياضيات', 'ما العدد الأولي؟',
        'عدد طبيعي أكبر من 1 لا يقبل القسمة إلا على 1 وعلى نفسه، مثل 2 و3 و5 و7 و11.'),
    KbEntry('الرياضيات', 'ما العدد الأولي الزوجي الوحيد؟', 'العدد 2.'),
    KbEntry('الرياضيات', 'ما العدد الزوجي والعدد الفردي؟',
        'الزوجي يقبل القسمة على 2 (مثل 4 و10)، والفردي لا يقبلها (مثل 3 و9).'),
    KbEntry(
        'الرياضيات',
        'ما المضاعف المشترك الأصغر (م.م.أ)؟',
        'أصغر عدد يقبل القسمة على العددين معاً. مثال: م.م.أ للعددين 4 و6 هو 12.',
        'ككم مضاعف'),
    KbEntry('الرياضيات', 'ما القاسم المشترك الأكبر (ق.م.أ)؟',
        'أكبر عدد يقسم العددين معاً. مثال: ق.م.أ للعددين 12 و18 هو 6.', 'قاسم'),
    KbEntry('الرياضيات', 'كيف أحسب النسبة المئوية؟',
        'النسبة المئوية = (الجزء ÷ الكل) × 100.', 'بالمئة'),
    KbEntry('الرياضيات', 'ما المتوسط الحسابي؟',
        'المتوسط الحسابي = مجموع القيم ÷ عددها.', 'معدل وسطي'),
    KbEntry('الرياضيات', 'ما الوسيط في الإحصاء؟',
        'القيمة التي تتوسط البيانات بعد ترتيبها تصاعدياً.'),
    KbEntry('الرياضيات', 'ما المنوال في الإحصاء؟',
        'القيمة الأكثر تكراراً في البيانات.'),
    KbEntry('الرياضيات', 'ما حجم المكعب؟',
        'حجم المكعب = طول الضلع × طول الضلع × طول الضلع.'),
    KbEntry('الرياضيات', 'ما حجم متوازي المستطيلات؟',
        'الحجم = الطول × العرض × الارتفاع.'),
    KbEntry('الرياضيات', 'ما قانون حل المعادلة من الدرجة الثانية؟',
        'للمعادلة أس² + بس + ج = 0: س = (−ب ± √(ب² − 4أج)) ÷ (2أ).', 'تربيعية'),
    KbEntry(
        'الرياضيات',
        'ما المميّز في المعادلة التربيعية؟',
        'المميز Δ = ب² − 4أج. إن كان موجباً فللمعادلة حلان حقيقيان، وإن كان صفراً فحل واحد، وإن كان سالباً فلا حلول حقيقية.',
        'دلتا'),
    KbEntry(
        'الرياضيات',
        'ما النسب المثلثية في المثلث القائم؟',
        'جا = المقابل ÷ الوتر، جتا = المجاور ÷ الوتر، ظا = المقابل ÷ المجاور.',
        'sin cos tan جيب'),
    KbEntry(
        'الرياضيات',
        'ما أنواع الزوايا؟',
        'حادة (أقل من 90°)، قائمة (90°)، منفرجة (بين 90° و180°)، مستقيمة (180°).',
        'حادة قائمة منفرجة'),
    KbEntry(
        'الرياضيات',
        'ما المتطابقات الجبرية المهمة؟',
        '(أ + ب)² = أ² + 2أب + ب²، (أ − ب)² = أ² − 2أب + ب²، (أ + ب)(أ − ب) = أ² − ب².',
        'مربع المجموع الفرق'),
    KbEntry(
        'الرياضيات',
        'ما قوانين الأسس؟',
        'أ^م × أ^ن = أ^(م+ن)، أ^م ÷ أ^ن = أ^(م−ن)، (أ^م)^ن = أ^(م×ن)، وأي عدد غير صفري أس صفر يساوي 1.',
        'قوى'),
    KbEntry(
        'الرياضيات',
        'ما ترتيب العمليات الحسابية؟',
        'الأقواس أولاً، ثم الأسس، ثم الضرب والقسمة، ثم الجمع والطرح.',
        'أولوية'),
    KbEntry('الرياضيات', 'ما مشتق الدالة س^ن؟', 'مشتق س^ن = ن × س^(ن−1).',
        'اشتقاق تفاضل'),
    KbEntry('الرياضيات', 'ما الاحتمال؟',
        'الاحتمال = عدد الحالات المناسبة ÷ عدد الحالات الممكنة.'),

    // ---------------- الفيزياء ----------------
    KbEntry('الفيزياء', 'ما وحدة قياس القوة؟', 'النيوتن (N).'),
    KbEntry(
        'الفيزياء',
        'ما قانون نيوتن الأول؟',
        'قانون القصور الذاتي: يبقى الجسم ساكناً أو متحركاً بسرعة ثابتة في خط مستقيم ما لم تؤثر فيه قوة محصلة غير معدومة.',
        'القصور'),
    KbEntry('الفيزياء', 'ما قانون نيوتن الثاني؟',
        'القوة المحصلة = الكتلة × التسارع (ق = ك × ت).'),
    KbEntry(
        'الفيزياء',
        'ما قانون نيوتن الثالث؟',
        'لكل فعل ردّ فعل يساويه في المقدار ويعاكسه في الاتجاه.',
        'الفعل ورد الفعل'),
    KbEntry('الفيزياء', 'ما سرعة الضوء في الفراغ؟',
        'تقريباً 300000 كم/ث (3 × 10⁸ م/ث).'),
    KbEntry('الفيزياء', 'ما قانون السرعة؟', 'السرعة = المسافة ÷ الزمن.'),
    KbEntry('الفيزياء', 'ما وحدة قياس السرعة؟',
        'متر/ثانية (م/ث) في النظام الدولي، أو كم/ساعة.'),
    KbEntry('الفيزياء', 'ما التسارع؟',
        'معدل تغيّر السرعة بالنسبة للزمن: التسارع = (السرعة النهائية − السرعة الابتدائية) ÷ الزمن، ووحدته م/ث².'),
    KbEntry('الفيزياء', 'ما تسارع السقوط الحر (الجاذبية الأرضية)؟',
        'تقريباً 9.8 م/ث² (ويؤخذ 10 م/ث² في كثير من المسائل).', 'جاذبية'),
    KbEntry('الفيزياء', 'ما الشغل في الفيزياء؟',
        'الشغل = القوة × الإزاحة (في اتجاه القوة)، ووحدته الجول.'),
    KbEntry(
        'الفيزياء',
        'ما الاستطاعة (القدرة)؟',
        'الشغل المنجز في وحدة الزمن: الاستطاعة = الشغل ÷ الزمن، ووحدتها الواط.',
        'قدرة واط'),
    KbEntry('الفيزياء', 'ما الطاقة الحركية؟',
        'الطاقة الحركية = ½ × الكتلة × مربع السرعة.'),
    KbEntry('الفيزياء', 'ما طاقة الوضع الثقالية؟',
        'طاقة الوضع = الكتلة × تسارع الجاذبية × الارتفاع.', 'كامنة'),
    KbEntry('الفيزياء', 'ما قانون أوم؟',
        'الجهد = شدة التيار × المقاومة (V = I × R).', 'ohm'),
    KbEntry(
        'الفيزياء',
        'ما وحدات قياس الكهرباء؟',
        'شدة التيار: الأمبير (A)، الجهد: الفولت (V)، المقاومة: الأوم (Ω)، الاستطاعة: الواط (W).',
        'أمبير فولت أوم'),
    KbEntry('الفيزياء', 'ما الاستطاعة الكهربائية؟',
        'الاستطاعة الكهربائية = الجهد × شدة التيار (P = V × I).'),
    KbEntry('الفيزياء', 'ما الضغط وما وحدته؟',
        'الضغط = القوة ÷ المساحة، ووحدته الباسكال (Pa).', 'باسكال'),
    KbEntry(
        'الفيزياء', 'ما الكثافة؟', 'الكثافة = الكتلة ÷ الحجم، ووحدتها كغ/م³.'),
    KbEntry('الفيزياء', 'ما وحدات النظام الدولي الأساسية؟',
        'الطول: المتر، الكتلة: الكيلوغرام، الزمن: الثانية، شدة التيار: الأمبير، درجة الحرارة: الكلفن.'),
    KbEntry('الفيزياء', 'ما وحدة التردد؟',
        'الهرتز (Hz)، وهو عدد الاهتزازات في الثانية.'),
    KbEntry('الفيزياء', 'ما سرعة الصوت في الهواء؟',
        'تقريباً 340 م/ث، ولا ينتقل الصوت في الفراغ.'),
    KbEntry('الفيزياء', 'ما قانون انعكاس الضوء؟',
        'زاوية السقوط تساوي زاوية الانعكاس، ويقع الشعاعان والناظم في مستوٍ واحد.'),
    KbEntry(
        'الفيزياء',
        'ما الانكسار؟',
        'انحراف الضوء عن مساره عند انتقاله بين وسطين شفافين مختلفين.',
        'انكسار الضوء'),
    KbEntry(
        'الفيزياء',
        'ما الكميات المتجهة والكميات القياسية؟',
        'المتجهة لها مقدار واتجاه (القوة، الإزاحة، السرعة المتجهة، التسارع)، والقياسية لها مقدار فقط (الكتلة، الزمن، المسافة، الطاقة).',
        'شعاعية'),
    KbEntry('الفيزياء', 'ما وحدة قياس الطاقة؟', 'الجول (J).'),
    KbEntry('الفيزياء', 'ما وحدة قياس الشحنة الكهربائية؟', 'الكولوم (C).'),
    KbEntry('الفيزياء', 'ما الفرق بين الكتلة والوزن؟',
        'الكتلة كمية المادة وتقاس بالكيلوغرام ولا تتغير، والوزن قوة جذب الأرض للجسم ويقاس بالنيوتن ويتغير بتغير الجاذبية. الوزن = الكتلة × تسارع الجاذبية.'),
    KbEntry('الفيزياء', 'ما قانون حفظ الطاقة؟',
        'الطاقة لا تفنى ولا تُستحدث، وإنما تتحول من شكل إلى آخر.'),
    KbEntry('الفيزياء', 'ما طرق انتقال الحرارة؟', 'التوصيل، والحمل، والإشعاع.'),
    KbEntry('الفيزياء', 'ما العلاقة بين الكلفن والسيلسيوس؟',
        'الكلفن = السيلسيوس + 273.', 'درجة الحرارة المطلقة'),
    KbEntry(
        'الفيزياء',
        'ما الفرق بين التوصيل على التوالي وعلى التفرع؟',
        'في التوالي يمر التيار نفسه في كل العناصر ويتوزع الجهد، وفي التفرع يتوزع التيار ويكون الجهد نفسه على الفروع.',
        'دارة كهربائية'),
    KbEntry(
        'الفيزياء',
        'ما قانون الجذب العام؟',
        'قوة التجاذب بين كتلتين تتناسب طرداً مع جداء كتلتيهما وعكساً مع مربع المسافة بينهما.',
        'نيوتن الجاذبية'),

    // ---------------- الكيمياء ----------------
    KbEntry('الكيمياء', 'ما الصيغة الكيميائية للماء؟',
        'H₂O (ذرتا هيدروجين وذرة أكسجين).', 'H2O'),
    KbEntry('الكيمياء', 'ما الصيغة الكيميائية لملح الطعام؟',
        'NaCl (كلوريد الصوديوم).'),
    KbEntry('الكيمياء', 'ما صيغة ثاني أكسيد الكربون؟', 'CO₂.', 'CO2'),
    KbEntry('الكيمياء', 'ما صيغة الأمونيا؟', 'NH₃.', 'NH3'),
    KbEntry('الكيمياء', 'ما صيغة الميثان؟', 'CH₄.', 'CH4'),
    KbEntry('الكيمياء', 'ما صيغة الغلوكوز؟', 'C₆H₁₂O₆.', 'الجلوكوز سكر'),
    KbEntry('الكيمياء', 'ما صيغة حمض الهيدروكلوريك؟', 'HCl.'),
    KbEntry('الكيمياء', 'ما صيغة حمض الكبريتيك؟', 'H₂SO₄.', 'H2SO4'),
    KbEntry(
        'الكيمياء', 'ما صيغة هيدروكسيد الصوديوم (الصودا الكاوية)؟', 'NaOH.'),
    KbEntry('الكيمياء', 'ما رمز عنصر الهيدروجين؟', 'H.', 'H'),
    KbEntry('الكيمياء', 'ما رمز عنصر الأكسجين؟', 'O.', 'O'),
    KbEntry('الكيمياء', 'ما رمز عنصر الكربون؟', 'C.', 'C'),
    KbEntry('الكيمياء', 'ما رمز عنصر النيتروجين (الآزوت)؟', 'N.', 'N آزوت'),
    KbEntry('الكيمياء', 'ما رمز عنصر الكبريت؟', 'S.', 'S'),
    KbEntry('الكيمياء', 'ما رمز عنصر الكلور؟', 'Cl.', 'Cl'),
    KbEntry('الكيمياء', 'ما رمز عنصر الصوديوم؟', 'Na (من اللاتينية Natrium).',
        'Na'),
    KbEntry(
        'الكيمياء', 'ما رمز عنصر البوتاسيوم؟', 'K (من اللاتينية Kalium).', 'K'),
    KbEntry('الكيمياء', 'ما رمز عنصر الكالسيوم؟', 'Ca.', 'Ca'),
    KbEntry(
        'الكيمياء', 'ما رمز عنصر الحديد؟', 'Fe (من اللاتينية Ferrum).', 'Fe'),
    KbEntry(
        'الكيمياء', 'ما رمز عنصر النحاس؟', 'Cu (من اللاتينية Cuprum).', 'Cu'),
    KbEntry('الكيمياء', 'ما رمز عنصر الخارصين (الزنك)؟', 'Zn.', 'Zn زنك'),
    KbEntry(
        'الكيمياء', 'ما رمز عنصر الفضة؟', 'Ag (من اللاتينية Argentum).', 'Ag'),
    KbEntry('الكيمياء', 'ما رمز عنصر الذهب؟', 'Au (من اللاتينية Aurum).', 'Au'),
    KbEntry('الكيمياء', 'ما رمز عنصر الزئبق؟', 'Hg (من اللاتينية Hydrargyrum).',
        'Hg'),
    KbEntry(
        'الكيمياء', 'ما رمز عنصر الرصاص؟', 'Pb (من اللاتينية Plumbum).', 'Pb'),
    KbEntry('الكيمياء', 'ما العدد الذري؟',
        'عدد البروتونات في نواة الذرة، وهو ما يميّز العنصر عن غيره.'),
    KbEntry('الكيمياء', 'ما العدد الكتلي؟',
        'مجموع عدد البروتونات والنيوترونات في النواة.'),
    KbEntry(
        'الكيمياء',
        'مم تتألف الذرة؟',
        'نواة فيها بروتونات (موجبة) ونيوترونات (متعادلة)، وإلكترونات (سالبة) تدور حولها.',
        'مكونات الذرة'),
    KbEntry('الكيمياء', 'كيف رُتّب الجدول الدوري؟',
        'العناصر مرتبة تصاعدياً حسب العدد الذري؛ الصفوف الأفقية تسمى دورات والأعمدة الرأسية تسمى مجموعات.'),
    KbEntry('الكيمياء', 'ما الرقم الهيدروجيني pH؟',
        'مقياس للحموضة: أقل من 7 حمضي، 7 متعادل، أكبر من 7 قاعدي.', 'pH'),
    KbEntry(
        'الكيمياء',
        'ما قانون حفظ الكتلة؟',
        'في التفاعل الكيميائي تكون كتلة المواد المتفاعلة مساوية لكتلة المواد الناتجة (قانون لافوازييه).',
        'لافوازييه'),
    KbEntry('الكيمياء', 'ما الرابطة الأيونية والرابطة التساهمية؟',
        'الأيونية: انتقال إلكترونات من ذرة (غالباً فلز) إلى أخرى (غالباً لافلز). التساهمية: مشاركة الإلكترونات بين ذرتين (غالباً لافلزين).'),
    KbEntry('الكيمياء', 'ما الغازات النبيلة؟',
        'هيليوم ونيون وأرغون وكريبتون وزينون ورادون؛ مستقرة وقليلة التفاعل.'),
    KbEntry(
        'الكيمياء', 'ما حالات المادة؟', 'صلبة وسائلة وغازية (وهناك البلازما).'),
    KbEntry('الكيمياء', 'ما درجة غليان الماء وتجمده؟',
        'يغلي عند 100°م ويتجمد عند 0°م تحت الضغط الجوي العادي.', 'تجمد غليان'),
    KbEntry(
        'الكيمياء',
        'ما نسبة الغازات في الهواء؟',
        'النيتروجين ≈ 78%، الأكسجين ≈ 21%، والباقي غازات أخرى منها الأرغون وثاني أكسيد الكربون.',
        'الغلاف الجوي'),
    KbEntry(
        'الكيمياء',
        'ما الفلزات؟',
        'عناصر لامعة موصلة للحرارة والكهرباء وقابلة للطرق والسحب غالباً، مثل الحديد والنحاس.',
        'معادن'),
    KbEntry('الكيمياء', 'ما المحلول؟', 'مزيج متجانس من مادة مذابة ومذيب.'),
    KbEntry('الكيمياء', 'ما الأكسدة والإرجاع؟',
        'الأكسدة فقدان إلكترونات، والإرجاع اكتساب إلكترونات.', 'الاختزال'),
    KbEntry('الكيمياء', 'ما الصدأ؟', 'أكسدة الحديد بوجود الأكسجين والرطوبة.'),
    KbEntry('الكيمياء', 'ما المول؟',
        'كمية المادة التي تحوي 6.02 × 10²³ جسيماً (عدد أفوغادرو).', 'أفوغادرو'),
    KbEntry(
        'الكيمياء',
        'ما الحمض والقاعدة؟',
        'الحمض يعطي أيونات H⁺ في الماء ويحمّر ورقة عباد الشمس الزرقاء؛ والقاعدة تعطي أيونات OH⁻ وتزرّق ورقة عباد الشمس الحمراء.',
        'حموض'),
    KbEntry('الكيمياء', 'ما التفاعل الكيميائي؟',
        'عملية تتحول فيها مواد إلى مواد جديدة بخواص مختلفة.'),
    KbEntry('الكيمياء', 'ما تفاعل التعادل؟',
        'تفاعل حمض مع قاعدة ينتج ملحاً وماءً.'),
    KbEntry('الكيمياء', 'ما الفرق بين العنصر والمركب والمزيج؟',
        'العنصر مادة من نوع واحد من الذرات، والمركب ذرات عناصر مختلفة مرتبطة كيميائياً، والمزيج مواد مختلطة غير مرتبطة كيميائياً.'),

    // ---------------- الأحياء ----------------
    KbEntry(
        'الأحياء',
        'ما وظيفة الميتوكوندريا؟',
        'إنتاج الطاقة (ATP) للخلية عبر التنفس الخلوي، وتُسمى محطة الطاقة.',
        'ميتوكندريا'),
    KbEntry(
        'الأحياء',
        'ما البناء الضوئي؟',
        'عملية تصنع بها النباتات الغذاء (الغلوكوز) من ثاني أكسيد الكربون والماء بوجود الضوء والكلوروفيل، ويتحرر الأكسجين.',
        'التمثيل الضوئي'),
    KbEntry('الأحياء', 'ما الكلوروفيل؟',
        'صبغة خضراء في البلاستيدات الخضراء تمتص ضوء الشمس.', 'اليخضور'),
    KbEntry('الأحياء', 'ما وظيفة النواة؟',
        'تحوي المادة الوراثية وتتحكم بنشاطات الخلية.'),
    KbEntry('الأحياء', 'ما الفرق بين الخلية النباتية والخلية الحيوانية؟',
        'النباتية لها جدار خلوي وبلاستيدات خضراء وفجوة عصارية كبيرة، أما الحيوانية فلا.'),
    KbEntry('الأحياء', 'كم عدد الكروموسومات عند الإنسان؟',
        '46 كروموسوماً (23 زوجاً) في الخلايا الجسدية.', 'صبغيات'),
    KbEntry(
        'الأحياء',
        'ما DNA؟',
        'الحمض النووي الريبي منقوص الأكسجين، يحمل المعلومات الوراثية.',
        'دنا الحمض النووي'),
    KbEntry('الأحياء', 'ما الجين؟',
        'مقطع من DNA يحمل المعلومات الخاصة بصفة وراثية.', 'المورثة'),
    KbEntry('الأحياء', 'ما تركيب القلب؟',
        'أربع حجرات: أذينان (أيمن وأيسر) وبطينان (أيمن وأيسر).', 'حجرات القلب'),
    KbEntry('الأحياء', 'ما الفرق بين الشرايين والأوردة؟',
        'الشرايين تحمل الدم من القلب إلى الجسم، والأوردة تعيده إلى القلب، والشعيرات الدموية تصل بينهما.'),
    KbEntry('الأحياء', 'ما وظيفة كريات الدم الحمراء؟',
        'نقل الأكسجين بواسطة الهيموغلوبين.', 'الهيموغلوبين'),
    KbEntry('الأحياء', 'ما وظيفة كريات الدم البيضاء؟',
        'الدفاع عن الجسم ضد الجراثيم.'),
    KbEntry('الأحياء', 'ما وظيفة الصفيحات الدموية؟', 'المساعدة على تخثر الدم.'),
    KbEntry('الأحياء', 'ما أجزاء الجهاز الهضمي؟',
        'الفم، المريء، المعدة، الأمعاء الدقيقة (حيث يُمتص معظم الغذاء)، الأمعاء الغليظة (امتصاص الماء)، ثم الشرج.'),
    KbEntry(
        'الأحياء',
        'ما وظيفة الرئتين؟',
        'تبادل الغازات: دخول الأكسجين إلى الدم وخروج ثاني أكسيد الكربون، ويتم ذلك في الحويصلات الرئوية.',
        'التنفس'),
    KbEntry('الأحياء', 'ما أكبر عضو في جسم الإنسان؟', 'الجلد.'),
    KbEntry('الأحياء', 'ما أكبر غدة في جسم الإنسان؟', 'الكبد.'),
    KbEntry('الأحياء', 'كم عدد عظام جسم الإنسان البالغ؟', '206 عظام.',
        'الهيكل العظمي'),
    KbEntry('الأحياء', 'ما مراتب التصنيف الحيوي؟',
        'المملكة، الشعبة، الصف، الرتبة، الفصيلة، الجنس، النوع.'),
    KbEntry(
        'الأحياء',
        'ما السلسلة الغذائية؟',
        'انتقال الغذاء والطاقة من المنتجات (النباتات) إلى المستهلكات (آكلات الأعشاب ثم آكلات اللحوم) وصولاً إلى المحلّلات.',
        'منتج مستهلك محلل'),
    KbEntry('الأحياء', 'ما وظيفة الأنسولين؟',
        'هرمون ينتجه البنكرياس ويخفض سكر الدم.', 'السكري'),
    KbEntry('الأحياء', 'ما فائدة فيتامين C؟',
        'يوجد في الحمضيات، ونقصه يسبب مرض الأسقربوط.', 'سي'),
    KbEntry(
        'الأحياء',
        'ما فائدة فيتامين D؟',
        'يقوي العظام، ويصنعه الجلد بتأثير أشعة الشمس، ونقصه يسبب الكساح عند الأطفال.',
        'دي'),
    KbEntry('الأحياء', 'هل تقتل المضادات الحيوية الفيروسات؟',
        'لا، فهي تعمل على البكتيريا فقط.'),
    KbEntry(
        'الأحياء',
        'ما الانتخاب الطبيعي؟',
        'بقاء الكائنات الأنسب لبيئتها وتكاثرها أكثر؛ وهي فكرة وضعها تشارلز داروين.',
        'داروين التطور'),
    KbEntry('الأحياء', 'ما الدورتان الدمويتان؟',
        'الدورة الكبرى: من القلب إلى أنحاء الجسم ثم العودة. الدورة الصغرى: من القلب إلى الرئتين ثم العودة.'),
    KbEntry('الأحياء', 'ما التنفس الخلوي؟',
        'تفكيك الغلوكوز بوجود الأكسجين لإنتاج الطاقة، مع ناتجين هما ثاني أكسيد الكربون والماء.'),
    KbEntry('الأحياء', 'ما مكونات الجهاز العصبي؟',
        'الدماغ والنخاع الشوكي والأعصاب، وهو يتحكم في الأعضاء ويستقبل المنبهات.'),
    KbEntry('الأحياء', 'ما وظيفة الكلية؟',
        'ترشيح الدم وطرح الفضلات والماء الزائد على شكل بول.'),
    KbEntry('الأحياء', 'ما وظيفة الكبد؟',
        'إنتاج الصفراء، وتخزين الغليكوجين، وتنقية الدم من المواد الضارة.'),
    KbEntry(
        'الأحياء',
        'ما الفرق بين الخلية بدائية النواة والخلية حقيقية النواة؟',
        'بدائية النواة (كالبكتيريا) بلا غشاء نووي، وحقيقية النواة لها نواة محاطة بغشاء.'),

    // ---------------- اللغة العربية ----------------
    KbEntry('اللغة العربية', 'ما إعراب الفاعل؟',
        'الفاعل اسم مرفوع يأتي بعد الفعل ويدل على من قام بالفعل.'),
    KbEntry('اللغة العربية', 'ما إعراب المفعول به؟',
        'اسم منصوب يقع عليه فعل الفاعل.'),
    KbEntry('اللغة العربية', 'ما إعراب المبتدأ والخبر؟',
        'كلاهما مرفوع؛ المبتدأ يبدأ به الكلام، والخبر يتم به المعنى.'),
    KbEntry('اللغة العربية', 'ما علامات الرفع؟',
        'الأصلية: الضمة. والفرعية: الواو (جمع المذكر السالم والأسماء الخمسة)، والألف (المثنى)، وثبوت النون (الأفعال الخمسة).'),
    KbEntry('اللغة العربية', 'ما علامات النصب؟',
        'الفتحة، والياء (المثنى وجمع المذكر السالم)، والألف (الأسماء الخمسة)، والكسرة (جمع المؤنث السالم)، وحذف النون (الأفعال الخمسة).'),
    KbEntry('اللغة العربية', 'ما علامات الجر؟',
        'الكسرة، والياء (المثنى وجمع المذكر السالم والأسماء الخمسة)، والفتحة (الممنوع من الصرف).'),
    KbEntry('اللغة العربية', 'ما أقسام الكلام في العربية؟', 'اسم وفعل وحرف.'),
    KbEntry('اللغة العربية', 'ما أقسام الفعل؟', 'ماضٍ ومضارع وأمر.'),
    KbEntry('اللغة العربية', 'ما إنّ وأخواتها؟',
        'حروف تنصب المبتدأ ويسمى اسمها، وترفع الخبر ويسمى خبرها: إنّ، أنّ، كأنّ، لكنّ، ليت، لعلّ.'),
    KbEntry('اللغة العربية', 'ما كان وأخواتها؟',
        'أفعال ترفع المبتدأ ويسمى اسمها، وتنصب الخبر ويسمى خبرها: كان، أصبح، أمسى، ظلّ، بات، صار، ليس.'),
    KbEntry('اللغة العربية', 'ما الفرق بين همزة الوصل وهمزة القطع؟',
        'همزة الوصل تُنطق في بداية الكلام وتسقط في وسطه، وهمزة القطع تُنطق دائماً.'),
    KbEntry('اللغة العربية', 'ما الجملة الاسمية والجملة الفعلية؟',
        'الاسمية تبدأ باسم (محمد مجتهد)، والفعلية تبدأ بفعل (كتب محمد).'),
    KbEntry('اللغة العربية', 'ما إعراب المثنى وجمع المذكر السالم؟',
        'المثنى يُرفع بالألف ويُنصب ويُجر بالياء. وجمع المذكر السالم يُرفع بالواو ويُنصب ويُجر بالياء.'),
    KbEntry('اللغة العربية', 'ما الأسماء الخمسة؟',
        'أب، أخ، حم، فو، ذو (بشروط معروفة).'),
    KbEntry('اللغة العربية', 'ما الممنوع من الصرف؟',
        'اسم لا يُنوَّن ويُجر بالفتحة نيابة عن الكسرة، مثل: أحمد، مساجد.'),
    KbEntry('اللغة العربية', 'ما التشبيه؟',
        'مشاركة أمر لآخر في صفة بأداة، مثل: العلم كالنور.', 'البلاغة'),
    KbEntry('اللغة العربية', 'ما الاستعارة؟',
        'تشبيه حُذف أحد طرفيه (المشبه أو المشبه به).', 'البلاغة'),
    KbEntry(
        'اللغة العربية',
        'ما الكناية؟',
        'لفظ أُريد به لازم معناه مع جواز إرادة المعنى الأصلي، مثل: كثير الرماد كناية عن الكرم.',
        'البلاغة'),
    KbEntry('اللغة العربية', 'ما الحال؟',
        'وصف منصوب يبيّن هيئة صاحبه وقت وقوع الفعل، مثل: جاء الطالب مبتسماً.'),
    KbEntry('اللغة العربية', 'ما جمع كلمة كتاب؟', 'كُتُب.'),
    KbEntry('اللغة العربية', 'ما ضد كلمة كريم؟', 'بخيل.', 'عكس'),
    KbEntry('اللغة العربية', 'ما عصور الأدب العربي؟',
        'الجاهلي، صدر الإسلام، الأموي، العباسي، الأندلسي، ثم العصر الحديث.'),
    KbEntry('اللغة العربية', 'ما المعلقات؟',
        'قصائد طويلة من أشهر ما قيل في العصر الجاهلي، ومن أصحابها امرؤ القيس وطرفة وزهير وعنترة.'),
    KbEntry('اللغة العربية', 'من أمير الشعراء؟', 'أحمد شوقي.'),
    KbEntry('اللغة العربية', 'من هو المتنبي؟',
        'أبو الطيب المتنبي شاعر عباسي (نحو 915–965م)، ولد في الكوفة، ومن أشهر شعراء العربية.'),
    KbEntry(
        'اللغة العربية',
        'متى تُكتب التاء مربوطة ومتى مفتوحة؟',
        'تُكتب مربوطة (ة) في آخر الاسم المفرد المؤنث وتُنطق هاءً عند الوقف، وتُكتب مفتوحة (ت) في الأفعال وجمع المؤنث السالم.',
        'التاء المربوطة المفتوحة'),

    // ---------------- اللغة الإنجليزية ----------------
    KbEntry('اللغة الإنجليزية', 'كيف نكوّن المضارع البسيط مع he وshe وit؟',
        'نضيف s أو es للفعل: She goes، He plays.', 'present simple'),
    KbEntry(
        'اللغة الإنجليزية',
        'ما الأفعال الشاذة الشائعة في الماضي؟',
        'go→went، see→saw، eat→ate، write→wrote، take→took، do→did، have→had، buy→bought، come→came، make→made، give→gave.',
        'past simple irregular went saw ate wrote took did bought came made gave'),
    KbEntry('اللغة الإنجليزية', 'ما الماضي البسيط من be؟',
        'was مع I وhe وshe وit، وwere مع you وwe وthey.', 'was were'),
    KbEntry(
        'اللغة الإنجليزية',
        'ما الجموع الشاذة في الإنجليزية؟',
        'child→children، man→men، woman→women، person→people، foot→feet، tooth→teeth، mouse→mice.',
        'plural children men women people feet teeth mice'),
    KbEntry(
        'اللغة الإنجليزية',
        'متى نستخدم a ومتى نستخدم an؟',
        'نستخدم a قبل الصوت الساكن (a book)، و an قبل الصوت المتحرك (an apple).',
        'article'),
    KbEntry('اللغة الإنجليزية', 'ما المضارع المستمر؟',
        'am أو is أو are + الفعل مع ing: I am studying.', 'present continuous'),
    KbEntry(
        'اللغة الإنجليزية',
        'ما المضارع التام؟',
        'have أو has + التصريف الثالث للفعل: I have finished.',
        'present perfect'),
    KbEntry(
        'اللغة الإنجليزية',
        'كيف نكوّن صيغة المقارنة؟',
        'نضيف er للصفات القصيرة (bigger)، و more للطويلة (more beautiful)، ومن الشاذ good→better وbad→worse.',
        'comparative'),
    KbEntry('اللغة الإنجليزية', 'ما معنى كلمة Book؟', 'كتاب.', 'book'),
    KbEntry('اللغة الإنجليزية', 'ما معنى كلمة Teacher؟', 'معلّم.', 'teacher'),
    KbEntry('اللغة الإنجليزية', 'ما معنى كلمة Student؟', 'طالب.', 'student'),
    KbEntry('اللغة الإنجليزية', 'ما معنى كلمة Apple؟', 'تفاحة.', 'apple'),
    KbEntry('اللغة الإنجليزية', 'ما معنى كلمة Water؟', 'ماء.', 'water'),
    KbEntry('اللغة الإنجليزية', 'ما معنى كلمة School؟', 'مدرسة.', 'school'),
    KbEntry('اللغة الإنجليزية', 'ما معنى كلمة Friend؟', 'صديق.', 'friend'),
    KbEntry('اللغة الإنجليزية', 'ما معنى كلمة House؟', 'بيت.', 'house'),
    KbEntry('اللغة الإنجليزية', 'ما معنى كلمة Family؟', 'عائلة.', 'family'),
    KbEntry('اللغة الإنجليزية', 'ما معنى كلمة Food؟', 'طعام.', 'food'),
    KbEntry('اللغة الإنجليزية', 'ما معنى Hello؟', 'مرحباً.', 'hello'),
    KbEntry(
        'اللغة الإنجليزية', 'ما معنى Thank you؟', 'شكراً.', 'thank you thanks'),
    KbEntry('اللغة الإنجليزية', 'ما معنى Please؟', 'من فضلك.', 'please'),
    KbEntry('اللغة الإنجليزية', 'ما معنى Good morning؟', 'صباح الخير.',
        'good morning'),

    // ---------------- الاجتماعيات (سوريا) ----------------
    KbEntry('الاجتماعيات', 'ما عاصمة سوريا؟',
        'دمشق، وهي من أقدم العواصم المأهولة في العالم.'),
    KbEntry('الاجتماعيات', 'ما مساحة سوريا؟', 'نحو 185 ألف كم².'),
    KbEntry(
        'الاجتماعيات',
        'ما الدول المجاورة لسوريا؟',
        'تركيا (شمالاً)، العراق (شرقاً)، الأردن (جنوباً)، لبنان (غرباً)، وفلسطين المحتلة (جنوب غرب)، ويحدّها البحر المتوسط غرباً.',
        'حدود جيران'),
    KbEntry('الاجتماعيات', 'على أي بحر تطل سوريا؟', 'البحر الأبيض المتوسط.',
        'الساحل'),
    KbEntry('الاجتماعيات', 'ما أطول نهر يعبر سوريا؟', 'نهر الفرات.', 'الأنهار'),
    KbEntry('الاجتماعيات', 'ما نهر العاصي؟',
        'ينبع من لبنان ويجري شمالاً عبر حمص وحماة وصولاً إلى تركيا حيث يصب في البحر المتوسط.'),
    KbEntry('الاجتماعيات', 'ما نهر بردى؟',
        'ينبع من جبال لبنان الشرقية ويمر في مدينة دمشق.'),
    KbEntry('الاجتماعيات', 'ما أعلى قمة في سوريا؟',
        'جبل الشيخ (حرمون)، ويبلغ ارتفاعه نحو 2814 م.', 'أعلى جبل'),
    KbEntry('الاجتماعيات', 'ما أكبر المحافظات السورية مساحة؟', 'محافظة حمص.'),
    KbEntry('الاجتماعيات', 'كم عدد المحافظات السورية؟',
        '14 محافظة: دمشق، ريف دمشق، حلب، حمص، حماة، اللاذقية، طرطوس، إدلب، الرقة، دير الزور، الحسكة، درعا، السويداء، القنيطرة.'),
    KbEntry('الاجتماعيات', 'ما أكبر سد في سوريا؟',
        'سد الفرات (سد الطبقة) على نهر الفرات قرب مدينة الطبقة.'),
    KbEntry('الاجتماعيات', 'ما البادية السورية؟',
        'منطقة صحراوية واسعة تغطي الجزء الأكبر من وسط سوريا وجنوبها الشرقي.'),
    KbEntry('الاجتماعيات', 'ما مناخ سوريا؟',
        'متوسطي على الساحل (حار جاف صيفاً ودافئ ماطر شتاءً)، وتزداد القارية والجفاف نحو الداخل والبادية.'),
    KbEntry('الاجتماعيات', 'ما أهم المحاصيل الزراعية في سوريا؟',
        'القمح والشعير والقطن والزيتون والحمضيات والخضروات والفواكه.', 'زراعة'),
    KbEntry(
        'الاجتماعيات',
        'ما المواقع الأثرية السورية المسجلة عالمياً؟',
        'مدينة دمشق القديمة، وبصرى الشام، وتدمر، وحلب القديمة، وقلعة الحصن وقلعة صلاح الدين، والقرى القديمة في شمال سوريا.',
        'اليونسكو آثار'),
    KbEntry(
        'الاجتماعيات',
        'ما أوغاريت؟',
        'مدينة سورية قديمة قرب اللاذقية (رأس شمرا)، ظهرت فيها أقدم أبجدية معروفة مكتوبة بالمسمارية نحو القرن 14 قبل الميلاد.',
        'الأبجدية'),
    KbEntry('الاجتماعيات', 'من أسس الدولة الأموية؟',
        'معاوية بن أبي سفيان، واتخذ دمشق عاصمة لها.'),
    KbEntry('الاجتماعيات', 'من بنى الجامع الأموي في دمشق؟',
        'الخليفة الأموي الوليد بن عبد الملك.'),
    KbEntry(
        'الاجتماعيات',
        'ما معركة ميسلون؟',
        'معركة وقعت في 24 تموز 1920 بين الجيش السوري بقيادة وزير الحربية يوسف العظمة والقوات الفرنسية.',
        'يوسف العظمة'),
    KbEntry(
        'الاجتماعيات',
        'متى عيد الجلاء؟',
        'في 17 نيسان، ذكرى خروج آخر جندي فرنسي من سوريا عام 1946.',
        'الجلاء الاستقلال'),
    KbEntry('الاجتماعيات', 'من هي الملكة زنوبيا؟',
        'ملكة تدمر في القرن الثالث الميلادي، اشتهرت بقوتها وحكمتها.'),
    KbEntry(
        'الاجتماعيات',
        'من هو صلاح الدين الأيوبي؟',
        'قائد مسلم انتصر في معركة حطين عام 1187م وحرّر القدس، ودُفن في دمشق.',
        'حطين'),
    KbEntry('الاجتماعيات', 'ما أكبر المدن السورية؟',
        'من أكبر المدن: دمشق وحلب وحمص وحماة واللاذقية.'),
    KbEntry('الاجتماعيات', 'ما عاصمة لبنان؟', 'بيروت.'),
    KbEntry('الاجتماعيات', 'ما عاصمة الأردن؟', 'عمّان.'),
    KbEntry('الاجتماعيات', 'ما عاصمة العراق؟', 'بغداد.'),
    KbEntry('الاجتماعيات', 'ما عاصمة تركيا؟', 'أنقرة.'),
    KbEntry('الاجتماعيات', 'ما عاصمة مصر؟', 'القاهرة.'),
    KbEntry('الاجتماعيات', 'ما عاصمة السعودية؟', 'الرياض.'),
    KbEntry('الاجتماعيات', 'ما عاصمة فرنسا؟', 'باريس.'),
    KbEntry('الاجتماعيات', 'ما عاصمة بريطانيا؟', 'لندن.'),
    KbEntry('الاجتماعيات', 'ما عاصمة ألمانيا؟', 'برلين.'),
    KbEntry('الاجتماعيات', 'ما عاصمة اليابان؟', 'طوكيو.'),
    KbEntry('الاجتماعيات', 'ما عاصمة الصين؟', 'بكين.'),
    KbEntry('الاجتماعيات', 'ما عاصمة روسيا؟', 'موسكو.'),

    // ---------------- علوم عامة ----------------
    KbEntry('علوم عامة', 'كم عدد كواكب المجموعة الشمسية؟',
        '8 كواكب: عطارد، الزهرة، الأرض، المريخ، المشتري، زحل، أورانوس، نبتون.'),
    KbEntry('علوم عامة', 'ما أكبر كواكب المجموعة الشمسية؟', 'المشتري.'),
    KbEntry('علوم عامة', 'ما أقرب كوكب إلى الشمس؟', 'عطارد.'),
    KbEntry('علوم عامة', 'ما الكوكب الأحمر؟', 'المريخ.'),
    KbEntry('علوم عامة', 'كم تستغرق الأرض لتدور حول الشمس؟',
        'سنة كاملة، أي نحو 365 يوماً وربع.'),
    KbEntry('علوم عامة', 'كم تستغرق الأرض لتدور حول نفسها؟',
        'نحو 24 ساعة (يوم كامل)، وينتج عن ذلك تعاقب الليل والنهار.'),
    KbEntry('علوم عامة', 'ما سبب الفصول الأربعة؟',
        'ميل محور دوران الأرض مع دورانها حول الشمس.'),
    KbEntry('علوم عامة', 'ما سبب خسوف القمر؟',
        'مرور القمر في ظل الأرض عندما تقع الأرض بين الشمس والقمر.'),
    KbEntry('علوم عامة', 'ما سبب كسوف الشمس؟',
        'مرور القمر بين الشمس والأرض فيحجب ضوء الشمس عن جزء من الأرض.'),
    KbEntry('علوم عامة', 'كم عدد قارات العالم؟',
        '7 قارات: آسيا، أفريقيا، أمريكا الشمالية، أمريكا الجنوبية، أنتاركتيكا، أوروبا، أستراليا (أوقيانوسيا).'),
    KbEntry('علوم عامة', 'ما أكبر محيط في العالم؟', 'المحيط الهادئ.'),
    KbEntry('علوم عامة', 'ما أعلى جبل في العالم؟', 'قمة إيفرست (نحو 8849 م).'),
    KbEntry('علوم عامة', 'ما أكبر قارة في العالم؟', 'آسيا.'),
    KbEntry('علوم عامة', 'ما أطول نهر في العالم؟',
        'يُعدّ النيل (نحو 6650 كم) الأطول تقليدياً، وتختلف بعض القياسات الحديثة بينه وبين الأمازون.'),
  ];
}
EOF

cat << 'EOF' > lib/screens/assistant_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../assistant_engine.dart';
import '../data.dart';
import '../knowledge.dart';
import '../services/speech_service.dart';
import '../services/tts_service.dart';

class _Msg {
  final String text;
  final bool mine;
  const _Msg(this.text, this.mine);
}

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  static const String _customKey = 'custom_kb_v1';
  static const List<String> _samples = [
    'ما قانون نيوتن الثاني؟',
    'كم عدد المحافظات السورية؟',
    'ما رمز الحديد؟',
    '12 × 12',
  ];

  final _speech = SpeechService();
  final _tts = TTSService();
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  final List<KbEntry> _base = [];
  final List<KbEntry> _custom = [];
  final List<_Msg> _messages = [
    const _Msg('مرحباً! اسألني عن موادك الدراسية، أو اكتب عملية حسابية وسأحسبها لك.', false),
  ];
  bool _listening = false;
  bool _voiceReplies = false;

  @override
  void initState() {
    super.initState();
    for (final s in AppData.subjects) {
      for (final c in s.cards) {
        _base.add(KbEntry(s.name, c.question, c.answer));
      }
    }
    _base.addAll(Knowledge.facts);
    _loadCustom();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _loadCustom() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_customKey);
      if (raw == null) return;
      final list = jsonDecode(raw) as List<dynamic>;
      final loaded = list.map((e) {
        final m = e as Map;
        return KbEntry('معلومة أضفتها', '${m['q']}', '${m['a']}', '', 2);
      }).toList();
      if (!mounted) return;
      setState(() {
        _custom
          ..clear()
          ..addAll(loaded);
      });
    } catch (_) {}
  }

  Future<void> _saveCustom() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = _custom.map((e) => {'q': e.question, 'a': e.answer}).toList();
      await prefs.setString(_customKey, jsonEncode(data));
    } catch (_) {}
  }

  Future<void> _teach() async {
    final qCtrl = TextEditingController();
    final aCtrl = TextEditingController();
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(ctx).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('علّمني معلومة جديدة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(controller: qCtrl, decoration: const InputDecoration(labelText: 'السؤال')),
            const SizedBox(height: 8),
            TextField(
              controller: aCtrl,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'الجواب', alignLabelWithHint: true),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('حفظ')),
          ],
        ),
      ),
    );
    final q = qCtrl.text.trim();
    final a = aCtrl.text.trim();
    if (saved == true && q.isNotEmpty && a.isNotEmpty) {
      setState(() => _custom.add(KbEntry('معلومة أضفتها', q, a, '', 2)));
      await _saveCustom();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم الحفظ، سأتذكر هذه المعلومة ✓')),
      );
    }
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send(String text) async {
    final q = text.trim();
    if (q.isEmpty) return;
    _ctrl.clear();
    final a = AssistantEngine.reply(q, [..._base, ..._custom]);
    setState(() {
      _messages.add(_Msg(q, true));
      _messages.add(_Msg(a, false));
    });
    _scrollDown();
    if (_voiceReplies) {
      try {
        await _tts.speak(a);
      } catch (_) {}
    }
  }

  Future<void> _toggleMic() async {
    if (_listening) {
      await _speech.stop();
      if (!mounted) return;
      setState(() => _listening = false);
      return;
    }
    try {
      final ok = await _speech.start((text, isFinal) {
        if (!mounted) return;
        _ctrl.text = text;
        if (isFinal) {
          setState(() => _listening = false);
          _send(text);
        }
      });
      if (!mounted) return;
      setState(() => _listening = ok);
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذّر تشغيل الميكروفون')),
        );
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _listening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.75;
    final primary = Theme.of(context).colorScheme.primary;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
          child: Row(
            children: [
              const Expanded(
                child: Text('المساعد الذكي', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              IconButton(
                tooltip: 'علّمني معلومة',
                icon: const Icon(Icons.add_circle_outline),
                onPressed: _teach,
              ),
              IconButton(
                tooltip: 'الرد بالصوت',
                icon: Icon(_voiceReplies ? Icons.volume_up : Icons.volume_off),
                onPressed: () => setState(() => _voiceReplies = !_voiceReplies),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _scroll,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, i) {
              final m = _messages[i];
              return Align(
                alignment: m.mine ? AlignmentDirectional.centerStart : AlignmentDirectional.centerEnd,
                child: Container(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: m.mine ? primary : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    m.text,
                    style: TextStyle(color: m.mine ? Colors.white : Colors.black87, fontSize: 15, height: 1.5),
                  ),
                ),
              );
            },
          ),
        ),
        if (_messages.length == 1)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _samples.map<Widget>((s) {
                return ActionChip(label: Text(s), onPressed: () => _send(s));
              }).toList(),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
          child: Row(
            children: [
              IconButton.filledTonal(
                onPressed: _toggleMic,
                icon: Icon(_listening ? Icons.stop : Icons.mic),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  onSubmitted: _send,
                  decoration: InputDecoration(
                    hintText: 'اكتب سؤالك...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: () => _send(_ctrl.text),
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
EOF

cat << 'EOF' > lib/screens/notes_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  static const String _key = 'notes_v1';
  List<Map<String, String>> _notes = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null) return;
      final list = jsonDecode(raw) as List<dynamic>;
      final loaded = list.map((e) => Map<String, String>.from(e as Map)).toList();
      if (!mounted) return;
      setState(() => _notes = loaded);
    } catch (_) {}
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, jsonEncode(_notes));
    } catch (_) {}
  }

  Future<void> _edit({int? index}) async {
    final titleCtrl = TextEditingController(text: index == null ? '' : _notes[index]['title']);
    final bodyCtrl = TextEditingController(text: index == null ? '' : _notes[index]['body']);
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(ctx).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'العنوان')),
            const SizedBox(height: 8),
            TextField(
              controller: bodyCtrl,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'الملاحظة', alignLabelWithHint: true),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('حفظ')),
          ],
        ),
      ),
    );
    final title = titleCtrl.text.trim();
    final body = bodyCtrl.text.trim();
    if (saved == true && (title.isNotEmpty || body.isNotEmpty)) {
      final note = <String, String>{'title': title, 'body': body};
      setState(() {
        if (index == null) {
          _notes.insert(0, note);
        } else {
          _notes[index] = note;
        }
      });
      await _save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(),
        icon: const Icon(Icons.add),
        label: const Text('ملاحظة جديدة'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('ملاحظاتي', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: _notes.isEmpty
                ? const Center(child: Text('لا توجد ملاحظات بعد. اضغط + لإضافة أول ملاحظة.'))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                    itemCount: _notes.length,
                    itemBuilder: (context, i) {
                      final n = _notes[i];
                      return Dismissible(
                        key: ObjectKey(n),
                        background: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.red.shade300,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          alignment: AlignmentDirectional.centerStart,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          setState(() => _notes.removeAt(i));
                          _save();
                        },
                        child: Card(
                          elevation: 0,
                          color: Colors.white,
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          child: ListTile(
                            onTap: () => _edit(index: i),
                            title: Text(
                              (n['title'] ?? '').isEmpty ? 'بدون عنوان' : n['title']!,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(n['body'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
EOF

cat << 'EOF' > test/widget_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:know_syria/main.dart';

void main() {
  testWidgets('home screen shows greeting', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('ماذا تريد أن تتعلم اليوم؟'), findsOneWidget);
  });
}
EOF

# Android: minSdk 24
if [ -f android/app/build.gradle.kts ]; then
  sedi 's/minSdk = flutter.minSdkVersion/minSdk = 24/' android/app/build.gradle.kts
elif [ -f android/app/build.gradle ]; then
  sedi 's/minSdkVersion flutter.minSdkVersion/minSdkVersion 24/' android/app/build.gradle
fi

M=android/app/src/main/AndroidManifest.xml

# App name shown on the phone
sedi 's/android:label="[^"]*"/android:label="Know Syria"/' "$M"

if ! grep -q 'RECORD_AUDIO' "$M"; then
  awk '/<application/ && !done {
         print "    <uses-permission android:name=\"android.permission.RECORD_AUDIO\"/>"
         print "    <uses-permission android:name=\"android.permission.INTERNET\"/>"
         done=1
       } { print }' "$M" > "$M.tmp" && mv "$M.tmp" "$M"
fi

add_query() {
  local a="$1"
  if grep -q "$a" "$M"; then return 0; fi
  if grep -q '<queries>' "$M"; then
    awk -v a="$a" '{ print }
         /<queries>/ && !done {
           print "        <intent>"
           print "            <action android:name=\"" a "\"/>"
           print "        </intent>"
           done=1
         }' "$M" > "$M.tmp" && mv "$M.tmp" "$M"
  else
    awk -v a="$a" '/<\/manifest>/ && !done {
           print "    <queries>"
           print "        <intent>"
           print "            <action android:name=\"" a "\"/>"
           print "        </intent>"
           print "    </queries>"
           done=1
         } { print }' "$M" > "$M.tmp" && mv "$M.tmp" "$M"
  fi
}
add_query android.speech.RecognitionService
add_query android.intent.action.TTS_SERVICE

flutter pub get
echo "Done. Run: flutter run"
