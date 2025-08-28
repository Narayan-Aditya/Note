import 'package:flutter/material.dart';

class NotesTile extends StatelessWidget {
  final String text;
  final void Function()? onEdit;
  final void Function()? onDelete;
  const NotesTile({
    super.key,
    required this.text,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(top: 12, left: 6, right: 6),
      child: ListTile(
        title: Text(text, maxLines: 3, overflow: TextOverflow.ellipsis),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: onEdit, icon: Icon(Icons.edit)),
            IconButton(onPressed: onDelete, icon: Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}
