import 'package:flutter/material.dart';
import 'package:todolist/const/colors.dart';
import 'package:todolist/data/firestor.dart';
import 'package:todolist/model/notes_model.dart';
import 'package:todolist/screen/edit_screen.dart';

class Task_Widget extends StatefulWidget {
  final Note _note;
  final bool strikethrough;

  const Task_Widget(this._note, {this.strikethrough = false, super.key});

  @override
  State<Task_Widget> createState() => _Task_WidgetState();
}

class _Task_WidgetState extends State<Task_Widget> {
  late bool isDone;

  @override
  void initState() {
    super.initState();
    isDone = widget._note.isDon;
  }

  @override
  Widget build(BuildContext context) {
    // Cek deadline
    bool isDeadline = false;
    try {
      final now = TimeOfDay.now();
      final todoTime = TimeOfDay(
        hour: int.parse(widget._note.time.split(':')[0]),
        minute: int.parse(widget._note.time.split(':')[1]),
      );
      final nowMinutes = now.hour * 60 + now.minute;
      final todoMinutes = todoTime.hour * 60 + todoTime.minute;
      if (todoMinutes - nowMinutes <= 60 && todoMinutes - nowMinutes >= 0) {
        isDeadline = true;
      }
    } catch (_) {}
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        width: double.infinity,
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(65),
          color: isDeadline ? Color(0xFFFFF3CD) : Colors.white, // kuning muda jika deadline
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              imageee(),
              SizedBox(width: 25),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            widget._note.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              decoration: widget.strikethrough
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: widget.strikethrough
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Checkbox(
                          activeColor: custom_green,
                          value: isDone,
                          onChanged: (value) {
                            setState(() {
                              isDone = value!;
                            });
                            Firestore_Datasource().isdone(widget._note.id, isDone);
                          },
                        ),
                      ],
                    ),
                    Text(
                      widget._note.subtitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: widget.strikethrough
                            ? Colors.grey.shade400
                            : Colors.grey.shade700,
                        decoration: widget.strikethrough
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    edit_time(context)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget edit_time(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 28,
            decoration: BoxDecoration(
              color: custom_green,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  Icon(Icons.access_time, color: Colors.white, size: 18),
                  SizedBox(width: 10),
                  Text(
                    widget._note.time,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Edit_Screen(widget._note),
                ),
              );
            },
            child: Container(
              width: 70,
              height: 28,
              decoration: BoxDecoration(
                color: Color(0xffE2F6F1), // biru muda
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.blue, size: 18),
                    SizedBox(width: 5),
                    Text(
                      'edit',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () async {
              await Firestore_Datasource().delet_note(widget._note.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Task dihapus!')),
                );
              }
            },
            child: Container(
              constraints: BoxConstraints(minWidth: 80),
              height: 28,
              decoration: BoxDecoration(
                color: Color(0xFFFFE5E5), // merah muda
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete, color: Colors.red, size: 18),
                    SizedBox(width: 5),
                    Text(
                      'delete',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
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

  Widget imageee() {
    String emoji = '📝'; // default emoji
    switch (widget._note.image) {
      case 'important':
        emoji = '❗';
        break;
      case 'work':
        emoji = '💼';
        break;
      case 'personal':
        emoji = '👤';
        break;
      case 'shopping':
        emoji = '🛒';
        break;
      case 'health':
        emoji = '❤️';
        break;
      case 'study':
        emoji = '📚';
        break;
    }

    return Container(
      height: 130,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          emoji,
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}
