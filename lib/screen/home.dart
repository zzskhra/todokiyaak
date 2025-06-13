import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todolist/const/colors.dart';
import 'package:todolist/screen/add_note_screen.dart';
import 'package:todolist/widgets/stream_note.dart';
import 'package:todolist/auth/auth_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

bool show = true;

class _Home_ScreenState extends State<Home_Screen> {
  DateTime selectedDate = DateTime.now();
  String searchQuery = "";
  bool showCompleted = true;
  bool showPending = true;

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Auth_Page()),
    );
  }

  Widget buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFCFBDB),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFF6DE77).withOpacity(0.12),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: TableCalendar(
        focusedDay: selectedDate,
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        calendarFormat: CalendarFormat.week,
        selectedDayPredicate: (day) => isSameDay(selectedDate, day),
        onDaySelected: (selected, focused) {
          setState(() {
            selectedDate = selected;
          });
        },
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(color: Color(0xFFC7CB5F), shape: BoxShape.circle),
          selectedDecoration: BoxDecoration(color: Color(0xFFF6DE77), shape: BoxShape.circle),
          markerDecoration: BoxDecoration(color: Color(0xFFF9DB91), shape: BoxShape.circle),
        ),
      ),
    );
  }

  Widget buildChartAndStats() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return SizedBox();
    final notesRef = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('notes');
    return StreamBuilder<QuerySnapshot>(
      stream: notesRef.snapshots(),
      builder: (context, snapshot) {
        int total = 0;
        int completed = 0;
        int pending = 0;
        if (snapshot.hasData) {
          total = snapshot.data!.docs.length;
          completed = snapshot.data!.docs.where((doc) => doc['isDon'] == true).length;
          pending = total - completed;
        }
        return Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Color(0xFFFCFBDB),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFF6DE77).withOpacity(0.12),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: pending.toDouble(),
                        title: 'Pending',
                        color: Color(0xFFF6DE77),
                        radius: 50,
                        titleStyle: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7A7A3A)),
                      ),
                      PieChartSectionData(
                        value: completed.toDouble(),
                        title: 'Completed',
                        color: Color(0xFFC7CB5F),
                        radius: 50,
                        titleStyle: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7A7A3A)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFFAF5B4),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFF6DE77).withOpacity(0.12),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Task Statistics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC7CB5F),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStatItem('Total Tasks', total.toString(), Icons.task),
                  _buildStatItem('Completed', completed.toString(), Icons.check_circle),
                  _buildStatItem('Pending', pending.toString(), Icons.pending),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFCFBDB),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              if (notification.direction == ScrollDirection.forward) {
                setState(() => show = true);
              }
              if (notification.direction == ScrollDirection.reverse) {
                setState(() => show = false);
              }
              return true;
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.sticky_note_2, color: Color(0xFFC7CB5F), size: 28),
                          SizedBox(width: 8),
                          Text(
                            'My Listy To-Dos',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF7A7A3A),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: _logout,
                        icon: Icon(Icons.logout, color: Colors.red[400]),
                        tooltip: 'Logout',
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// Search Bar
                  TextField(
                    onChanged: (value) => setState(() => searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Search ToDos...',
                      prefixIcon: Icon(Icons.search, color: Color(0xFFC7CB5F)),
                      filled: true,
                      fillColor: Color(0xFFFAF5B4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Main Content Row
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Left Side - Todo List
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              buildCalendar(),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      FilterChip(
                                        label: Text("Pending"),
                                        selected: showPending,
                                        onSelected: (val) => setState(() => showPending = val),
                                        selectedColor: Color(0xFFF6DE77),
                                      ),
                                      SizedBox(width: 8),
                                      FilterChip(
                                        label: Text("Completed"),
                                        selected: showCompleted,
                                        onSelected: (val) => setState(() => showCompleted = val),
                                        selectedColor: Color(0xFFC7CB5F),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => Add_screen()));
                                    },
                                    icon: Icon(Icons.add),
                                    label: Text("Add Task"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFFC7CB5F),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: ListView(
                                  padding: const EdgeInsets.only(bottom: 100),
                                  children: [
                                    if (showPending)
                                      Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.hourglass_empty, color: Color(0xFF7A7A3A)),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Pending',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                    color: Color(0xFF7A7A3A),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Stream_note(false, searchQuery: searchQuery),
                                          ],
                                        ),
                                      ),
                                    const SizedBox(height: 24),
                                    if (showCompleted)
                                      Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.check_circle, color: Color(0xFF7A7A3A)),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Completed',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                    color: Color(0xFF7A7A3A),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Stream_note(true, searchQuery: searchQuery),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// Right Side - Chart & Stats
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 2,
                          child: buildChartAndStats(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF7A7A3A), size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF7A7A3A),
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFF7A7A3A),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
