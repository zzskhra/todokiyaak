import 'package:flutter/material.dart';
import 'package:todolist/const/colors.dart';
import 'package:todolist/data/firestor.dart';
import 'package:intl/intl.dart';

class Add_screen extends StatefulWidget {
  const Add_screen({super.key});

  @override
  State<Add_screen> createState() => _Add_screenState();
}

class _Add_screenState extends State<Add_screen> {
  final title = TextEditingController();
  final subtitle = TextEditingController();
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  String selectedCategory = 'Work';
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final List<Map<String, String>> categories = [
    {'label': 'Work', 'icon': '🏢'},
    {'label': 'Study', 'icon': '🎓'},
    {'label': 'Personal', 'icon': '👤'},
    {'label': 'Shopping', 'icon': '🛒'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFCFBDB), // background utama
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Color(0xFFFAF5B4), // form container
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFF6DE77).withOpacity(0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Add New Task",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC7CB5F),
                      ),
                    ),
                    const SizedBox(height: 24),
                    titleField(),
                    const SizedBox(height: 16),
                    subtitleField(),
                    const SizedBox(height: 16),
                    categoryDropdown(),
                    const SizedBox(height: 16),
                    deadlinePicker(),
                    const SizedBox(height: 28),
                    actionButtons(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget titleField() {
    return fieldContainer(
      TextField(
        controller: title,
        focusNode: _focusNode1,
        style: const TextStyle(fontSize: 18, color: Color(0xFF7A7A3A)),
        decoration: inputDecoration('Title'),
      ),
    );
  }

  Widget subtitleField() {
    return fieldContainer(
      TextField(
        controller: subtitle,
        focusNode: _focusNode2,
        maxLines: 2,
        style: const TextStyle(fontSize: 18, color: Color(0xFF7A7A3A)),
        decoration: inputDecoration('Subtitle'),
      ),
    );
  }

  Widget categoryDropdown() {
    return fieldContainer(
      DropdownButtonFormField<String>(
        value: selectedCategory,
        decoration: inputDecoration("Category"),
        items: categories.map((cat) {
          return DropdownMenuItem<String>(
            value: cat['label'],
            child: Row(
              children: [
                Text(cat['icon']!, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text(cat['label']!, style: const TextStyle(fontSize: 16, color: Color(0xFF7A7A3A))),
              ],
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            selectedCategory = newValue!;
          });
        },
        dropdownColor: Color(0xFFFCFBDB),
        iconEnabledColor: Color(0xFFC7CB5F),
      ),
    );
  }

  Widget deadlinePicker() {
    return fieldContainer(
      Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: ColorScheme.light(
                          primary: Color(0xFFC7CB5F),
                          onPrimary: Colors.white,
                          surface: Color(0xFFF6DE77),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                decoration: BoxDecoration(
                  color: Color(0xFFF6DE77),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18, color: Color(0xFFC7CB5F)),
                    const SizedBox(width: 8),
                    Text(
                      selectedDate == null
                          ? 'Pilih Tanggal'
                          : DateFormat('dd MMM yyyy').format(selectedDate!),
                      style: const TextStyle(fontSize: 15, color: Color(0xFF7A7A3A)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: selectedTime ?? TimeOfDay.now(),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: ColorScheme.light(
                          primary: Color(0xFFC7CB5F),
                          onPrimary: Colors.white,
                          surface: Color(0xFFF6DE77),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() {
                    selectedTime = picked;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                decoration: BoxDecoration(
                  color: Color(0xFFF6DE77),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, size: 18, color: Color(0xFFC7CB5F)),
                    const SizedBox(width: 8),
                    Text(
                      selectedTime == null
                          ? 'Pilih Jam'
                          : selectedTime!.format(context),
                      style: const TextStyle(fontSize: 15, color: Color(0xFF7A7A3A)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget actionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            if (title.text.isNotEmpty && subtitle.text.isNotEmpty && selectedDate != null && selectedTime != null) {
              Firestore_Datasource().AddNote(
                subtitle.text,
                title.text,
                0, // index gambar dihapus, bisa diganti sesuai kebutuhan
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task added successfully!')),
              );

              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mohon lengkapi semua field!')),
              );
            }
          },
          icon: const Icon(Icons.check, size: 18),
          label: const Text('Add', style: TextStyle(fontSize: 14)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFC7CB5F),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, size: 18),
          label: const Text('Cancel', style: TextStyle(fontSize: 14)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFF9DB91),
            foregroundColor: Color(0xFF7A7A3A),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
          ),
        ),
      ],
    );
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      filled: true,
      fillColor: Color(0xFFFCFBDB),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFF6DE77), width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFC7CB5F), width: 2.0),
      ),
    );
  }

  Widget fieldContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Color(0xFFF6DE77).withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
