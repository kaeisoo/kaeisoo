import 'package:flutter/material.dart';

void main() => runApp(const FitStrongApp());

const lime = Color(0xFFD7FF00);
const bg = Color(0xFF080A0B);
const card = Color(0xFF15191C);
const muted = Color(0xFF969DA0);

class FitStrongApp extends StatelessWidget {
  const FitStrongApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Fit & Strong',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: bg,
          colorScheme: const ColorScheme.dark(primary: lime, secondary: lime, surface: card, onPrimary: Colors.black),
        ),
        home: const AppHome(),
      );
}

class AppHome extends StatefulWidget {
  const AppHome({super.key});
  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  int tab = 0;
  int completed = 12;
  int period = 0;

  void startSession(String name, String duration) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
      builder: (sheet) => SessionSheet(
        name: name,
        duration: duration,
        onComplete: () {
          setState(() => completed++);
          Navigator.pop(sheet);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Workout completed. Great work!')));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      DashboardPage(onStart: () => startSession('Upper Body Strength', '45 min'), completed: completed, onProgress: () => setState(() => tab = 2)),
      WorkoutPage(onStart: startSession),
      ActivityPage(period: period, onPeriod: (v) => setState(() => period = v), completed: completed),
      const ProfilePage(),
    ];
    return Scaffold(
      body: IndexedStack(index: tab, children: pages),
      bottomNavigationBar: NavigationBar(
        height: 70,
        backgroundColor: const Color(0xFF101315),
        selectedIndex: tab,
        onDestinationSelected: (v) => setState(() => tab = v),
        indicatorColor: lime.withValues(alpha: .13),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home, color: lime), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.fitness_center), selectedIcon: Icon(Icons.fitness_center, color: lime), label: 'Workouts'),
          NavigationDestination(icon: Icon(Icons.bar_chart), selectedIcon: Icon(Icons.bar_chart, color: lime), label: 'Progress'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person, color: lime), label: 'Profile'),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});
  @override
  Widget build(BuildContext context) => Row(children: [
        Container(width: 42, height: 42, decoration: BoxDecoration(color: lime, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.fitness_center, color: Colors.black)),
        const SizedBox(width: 11),
        const Expanded(child: Text('FIT & STRONG', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1))),
        IconButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You are all caught up!'))), icon: const Icon(Icons.notifications_none), style: IconButton.styleFrom(backgroundColor: card)),
      ]);
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.onStart, required this.completed, required this.onProgress});
  final VoidCallback onStart, onProgress;
  final int completed;
  @override
  Widget build(BuildContext context) => SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
        const Header(), const SizedBox(height: 24),
        const Text('PUSH YOUR LIMITS', style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900, height: 1.05)),
        const Text('EVERY DAY', style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900, color: lime)),
        const SizedBox(height: 8), const Text('Stronger Body.\nStronger You.', style: TextStyle(color: muted, height: 1.4)),
        const SizedBox(height: 18),
        Container(height: 215, padding: const EdgeInsets.all(20), decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), gradient: const LinearGradient(colors: [Color(0xFF303B1A), Color(0xFF111619)], begin: Alignment.topRight, end: Alignment.bottomLeft)), child: Stack(children: [
          const Positioned(right: 2, top: 25, child: Icon(Icons.fitness_center, size: 125, color: Color(0x44D7FF00))),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("TODAY'S CHALLENGE", style: TextStyle(color: lime, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
            const Spacer(), const Text('UPPER BODY', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const Text('STRENGTH', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: lime)),
            const Text('Build power. Beat yesterday.', style: TextStyle(color: muted, fontSize: 11)),
            const SizedBox(height: 12), FilledButton.icon(onPressed: onStart, icon: const Icon(Icons.play_arrow), label: const Text('Get Started'), style: FilledButton.styleFrom(backgroundColor: lime, foregroundColor: Colors.black)),
          ]),
        ])),
        const SizedBox(height: 22),
        Row(children: [const Text("Today's Progress", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)), const Spacer(), TextButton(onPressed: onProgress, child: const Text('View activity', style: TextStyle(color: lime))) ]),
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(22)), child: Column(children: [
          Row(children: [const Text('Daily goal', style: TextStyle(fontWeight: FontWeight.w700)), const Spacer(), Text(completed.toString() + ' workouts this week', style: const TextStyle(color: muted, fontSize: 10))]),
          const SizedBox(height: 14), SizedBox(height: 125, child: Stack(alignment: Alignment.center, children: [
            CustomPaint(size: const Size(210, 118), painter: GaugePainter(.68)),
            const Positioned(bottom: 5, child: Column(children: [Text('68%', style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900)), Text('Completed', style: TextStyle(color: muted, fontSize: 10))])),
          ])),
          const Divider(color: Color(0xFF2B3033)),
          const Row(children: [Expanded(child: MiniStat(Icons.local_fire_department, 'Calories', '560', 'kcal')), Expanded(child: MiniStat(Icons.favorite, 'Heart Rate', '142', 'bpm')), Expanded(child: MiniStat(Icons.timer_outlined, 'Duration', '45', 'min'))]),
        ])),
      ]));
}

class GaugePainter extends CustomPainter {
  const GaugePainter(this.value);
  final double value;
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(3, 0, size.width - 6, size.height * 2);
    final track = Paint()..color = const Color(0xFF41474A)..style = PaintingStyle.stroke..strokeWidth = 10..strokeCap = StrokeCap.round;
    final active = Paint()..color = lime..style = PaintingStyle.stroke..strokeWidth = 10..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 3.14159, 3.14159, false, track);
    canvas.drawArc(rect, 3.14159, 3.14159 * value, false, active);
  }
  @override
  bool shouldRepaint(covariant GaugePainter oldDelegate) => oldDelegate.value != value;
}

class MiniStat extends StatelessWidget {
  const MiniStat(this.icon, this.label, this.value, this.unit, {super.key});
  final IconData icon;
  final String label, value, unit;
  @override
  Widget build(BuildContext context) => Column(children: [Icon(icon, color: lime, size: 18), const SizedBox(height: 5), Text(label, style: const TextStyle(color: muted, fontSize: 9)), Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)), Text(unit, style: const TextStyle(color: muted, fontSize: 9))]);
}

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key, required this.onStart});
  final void Function(String, String) onStart;
  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  String filter = 'All';
  static const categories = ['All', 'Strength', 'Cardio', 'Flexibility'];
  static const names = ['Upper Body Strength', 'HIIT Cardio', 'Core & Abs', 'Full Body Stretch'];
  static const durations = ['45 min', '30 min', '20 min', '15 min'];
  static const types = ['Strength', 'Cardio', 'Strength', 'Flexibility'];
  static const levels = ['Intermediate', 'High intensity', 'All levels', 'Beginner'];
  static const icons = [Icons.fitness_center, Icons.bolt, Icons.accessibility_new, Icons.self_improvement];
  @override
  Widget build(BuildContext context) => SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
        const Header(), const SizedBox(height: 26), const Text('Find your', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900)),
        const Text('next workout.', style: TextStyle(fontSize: 27, color: lime, fontWeight: FontWeight.w900)),
        const SizedBox(height: 7), const Text('Small steps every day make big changes.', style: TextStyle(color: muted, fontSize: 12)),
        const SizedBox(height: 18), Wrap(spacing: 7, children: categories.map((c) => ChoiceChip(label: Text(c), selected: filter == c, onSelected: (_) => setState(() => filter = c), selectedColor: lime, backgroundColor: card, side: BorderSide.none, showCheckmark: false, labelStyle: TextStyle(color: filter == c ? Colors.black : Colors.white70, fontSize: 11))).toList()),
        const SizedBox(height: 17),
        Container(padding: const EdgeInsets.all(17), decoration: BoxDecoration(color: lime, borderRadius: BorderRadius.circular(22)), child: Row(children: [
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('FEATURED PLAN', style: TextStyle(color: Colors.black54, fontSize: 9, fontWeight: FontWeight.w900)), SizedBox(height: 7), Text('Upper Body\nStrength', style: TextStyle(color: Colors.black, fontSize: 22, height: 1.05, fontWeight: FontWeight.w900)), SizedBox(height: 7), Text('5 exercises  •  45 min', style: TextStyle(color: Colors.black87, fontSize: 10))])),
          const Icon(Icons.fitness_center, color: Color(0xFF334000), size: 65),
        ])),
        const SizedBox(height: 18), SizedBox(width: double.infinity, child: FilledButton(onPressed: () => widget.onStart(names[0], durations[0]), style: FilledButton.styleFrom(backgroundColor: lime, foregroundColor: Colors.black), child: const Text('Start featured workout'))),
        const SizedBox(height: 22), const Text('Workout library', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)), const SizedBox(height: 11),
        for (var i = 0; i < names.length; i++)
          if (filter == 'All' || filter == types[i])
            Padding(padding: const EdgeInsets.only(bottom: 9), child: Material(color: card, borderRadius: BorderRadius.circular(17), child: ListTile(
              onTap: () => widget.onStart(names[i], durations[i]),
              leading: Container(width: 43, height: 43, decoration: BoxDecoration(color: lime.withValues(alpha: .12), borderRadius: BorderRadius.circular(12)), child: Icon(icons[i], color: lime)),
              title: Text(names[i], style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
              subtitle: Text(durations[i] + '  •  ' + levels[i], style: const TextStyle(color: muted, fontSize: 10)),
              trailing: const Icon(Icons.chevron_right, color: muted),
            ))),
      ]));
}

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key, required this.period, required this.onPeriod, required this.completed});
  final int period, completed;
  final ValueChanged<int> onPeriod;
  @override
  Widget build(BuildContext context) {
    const steps = ['7,842', '48,230', '186,420'];
    const goals = ['10,000', '60,000', '200,000'];
    const values = [.7842, .8038, .9321];
    return SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
      const Header(), const SizedBox(height: 24), const Text('Your activity', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900)),
      const SizedBox(height: 5), const Text('Every move brings you closer.', style: TextStyle(color: muted, fontSize: 12)), const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(30)),
        child: Row(
          children: ['Day', 'Week', 'Month'].asMap().entries.map((e) {
            return Expanded(
              child: GestureDetector(
                onTap: () => onPeriod(e.key),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: period == e.key ? lime : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    e.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: period == e.key ? Colors.black : muted,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      const SizedBox(height: 18), Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(24)), child: Column(children: [
        Text(['TODAY', 'THIS WEEK', 'THIS MONTH'][period], style: const TextStyle(color: muted, letterSpacing: 1, fontWeight: FontWeight.w800, fontSize: 10)),
        const SizedBox(height: 17), SizedBox(width: 190, height: 190, child: Stack(alignment: Alignment.center, children: [
          SizedBox(width: 180, height: 180, child: CircularProgressIndicator(value: values[period], strokeWidth: 10, strokeCap: StrokeCap.round, backgroundColor: const Color(0xFF343A3D), valueColor: const AlwaysStoppedAnimation(lime))),
          Column(mainAxisSize: MainAxisSize.min, children: [const Text('Steps', style: TextStyle(color: muted, fontSize: 11)), const SizedBox(height: 5), Text(steps[period], style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)), Text('Goal: ' + goals[period], style: const TextStyle(color: muted, fontSize: 10))]),
        ])),
        const SizedBox(height: 15), const Row(children: [Expanded(child: MiniStat(Icons.local_fire_department, 'Calories', '560', 'kcal')), Expanded(child: MiniStat(Icons.timer, 'Active Time', '1h 25m', '')), Expanded(child: MiniStat(Icons.location_on, 'Distance', '6.2', 'km'))]),
      ])),
      const SizedBox(height: 22), Row(children: [const Text('Recent workouts', style: TextStyle(fontWeight: FontWeight.w800)), const Spacer(), Text(completed.toString() + ' completed', style: const TextStyle(color: lime, fontSize: 11))]),
      const SizedBox(height: 11), const RecentRow('Upper Body Strength', '45 min  •  320 kcal', Icons.fitness_center), const SizedBox(height: 8), const RecentRow('HIIT Cardio', '30 min  •  280 kcal', Icons.bolt),
    ]));
  }
}

class RecentRow extends StatelessWidget {
  const RecentRow(this.title, this.detail, this.icon, {super.key});
  final String title, detail;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(16)), child: Row(children: [
        Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFF202528), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: lime)),
        const SizedBox(width: 11), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)), Text(detail, style: const TextStyle(color: muted, fontSize: 9))])),
        const Icon(Icons.check_circle, color: lime),
      ]));
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
        const Header(), const SizedBox(height: 30),
        const CircleAvatar(radius: 46, backgroundColor: Color(0x33D7FF00), child: Icon(Icons.person, color: lime, size: 48)),
        const SizedBox(height: 12), const Center(child: Text('Emon', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900))),
        const Center(child: Text('Consistency is the key.', style: TextStyle(color: muted, fontSize: 11))),
        const SizedBox(height: 25), const Row(children: [Expanded(child: ProfileStat('12', 'Workouts')), SizedBox(width: 9), Expanded(child: ProfileStat('8.5k', 'Avg. steps')), SizedBox(width: 9), Expanded(child: ProfileStat('6', 'Day streak'))]),
        const SizedBox(height: 27), const Text('Preferences', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)), const SizedBox(height: 8),
        const ProfileOption(Icons.flag_outlined, 'Daily goals', 'Manage your fitness targets'),
        const ProfileOption(Icons.notifications_none, 'Notifications', 'Workout reminders and updates'),
        const ProfileOption(Icons.privacy_tip_outlined, 'Privacy & security', 'Manage your account settings'),
        const ProfileOption(Icons.help_outline, 'Help & support', 'FAQs and contact information'),
      ]));
}

class ProfileStat extends StatelessWidget {
  const ProfileStat(this.value, this.label, {super.key});
  final String value, label;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(vertical: 14), decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(16)), child: Column(children: [Text(value, style: const TextStyle(color: lime, fontWeight: FontWeight.w900, fontSize: 20)), Text(label, style: const TextStyle(color: muted, fontSize: 9))]));
}

class ProfileOption extends StatelessWidget {
  const ProfileOption(this.icon, this.title, this.subtitle, {super.key});
  final IconData icon;
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 7),
        leading: Container(width: 40, height: 40, decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: lime)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
        subtitle: Text(subtitle, style: const TextStyle(color: muted, fontSize: 9)),
        trailing: const Icon(Icons.chevron_right, color: muted),
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title + ' settings coming soon.'))),
      );
}

class SessionSheet extends StatefulWidget {
  const SessionSheet({super.key, required this.name, required this.duration, required this.onComplete});
  final String name, duration;
  final VoidCallback onComplete;
  @override
  State<SessionSheet> createState() => _SessionSheetState();
}

class _SessionSheetState extends State<SessionSheet> {
  bool started = false;
  @override
  Widget build(BuildContext context) => SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(22, 18, 22, 25), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(child: Container(width: 42, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)))),
        const SizedBox(height: 20), const Icon(Icons.fitness_center, color: lime, size: 34), const SizedBox(height: 12),
        Text(widget.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)), Text(widget.duration + '  •  Warm up, main workout, cool down', style: const TextStyle(color: muted, fontSize: 11)),
        const SizedBox(height: 18), const Text('IN THIS SESSION', style: TextStyle(color: lime, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
        const ListTile(contentPadding: EdgeInsets.zero, leading: Text('01', style: TextStyle(color: lime)), title: Text('Warm up'), subtitle: Text('5 minutes')),
        const ListTile(contentPadding: EdgeInsets.zero, leading: Text('02', style: TextStyle(color: lime)), title: Text('Main workout'), subtitle: Text('Follow your planned sets')),
        const ListTile(contentPadding: EdgeInsets.zero, leading: Text('03', style: TextStyle(color: lime)), title: Text('Cool down'), subtitle: Text('Stretch and recover')),
        const SizedBox(height: 13), SizedBox(width: double.infinity, child: FilledButton(onPressed: started ? widget.onComplete : () => setState(() => started = true), style: FilledButton.styleFrom(backgroundColor: lime, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 14)), child: Text(started ? 'Complete workout' : 'Start session'))),
      ])));
}
