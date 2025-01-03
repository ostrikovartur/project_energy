import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  final String message;
  final VoidCallback onClose;

  const Message({super.key, required this.message, required this.onClose});

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  bool _showCloseButton = false;

  void _toggleCloseButton() {
    setState(() {
      _showCloseButton = !_showCloseButton;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50.0,
      left: 10.0,
      right: 10.0,
      child: GestureDetector(
        onTap: _toggleCloseButton,
        child: Card(
          color: Colors.yellow[700],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/attention.png', width: 24, height: 24),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Увага',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(widget.message),
                      Text(
                        'Дата: ${DateTime.now().toLocal().toString().split(' ')[0]}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                if (_showCloseButton)
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: widget.onClose,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}