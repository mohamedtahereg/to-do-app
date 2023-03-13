import 'package:flutter/material.dart';

class Task extends StatelessWidget {
  Task({
    super.key,
    required this.model,
  });
  Map model;
  @override
  Widget build(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              CircleAvatar(
                radius: 40,
                child: Text("${model['time']}"),
              ),
              const SizedBox(
                width: 30,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${model['title']}",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  Text("${model['date']}"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
