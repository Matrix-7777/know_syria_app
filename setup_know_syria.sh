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

cat << 'EOF' > lib/screens/assistant_screen.dart
import 'package:flutter/material.dart';
import '../data.dart';
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
  final _speech = SpeechService();
  final _tts = TTSService();
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  final List<_Msg> _messages = [
    const _Msg('مرحباً! اسألني عن موادك الدراسية، مثلاً: ما وحدة قياس القوة؟', false),
  ];
  bool _listening = false;
  bool _voiceReplies = false;

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  String _answer(String question) {
    final cleaned = question.replaceAll(RegExp(r'[؟?!.,،]'), ' ');
    final words = cleaned.split(RegExp(r'\s+')).where((w) => w.length >= 3).toList();
    Flashcard? best;
    var bestScore = 0;
    for (final s in AppData.subjects) {
      for (final c in s.cards) {
        var score = 0;
        for (final w in words) {
          if (c.question.contains(w)) score++;
        }
        if (score > bestScore) {
          bestScore = score;
          best = c;
        }
      }
    }
    if (best != null) {
      return '${best.question}\n${best.answer}';
    }
    return 'لم أجد إجابة في المواد المتوفرة حالياً. جرّب كلمات أخرى مثل: نيوتن، الماء، دمشق.';
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
    final a = _answer(q);
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
                    style: TextStyle(color: m.mine ? Colors.white : Colors.black87, fontSize: 15),
                  ),
                ),
              );
            },
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
