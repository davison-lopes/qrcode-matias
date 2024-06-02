import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:qrcode_matias/model/qr.dart';


class QrcodeListItem extends StatelessWidget {
  const QrcodeListItem({Key? key, required this.todo, required this.onDelete}) : super(key: key);

  final Qrcode todo;
  final Function(Qrcode) onDelete;


  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      // Your Function
    });
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Slidable(

        //key: const ValueKey(0),

        // The start action pane is the one at the left or the top side.
        startActionPane: ActionPane(

          extentRatio: 0.25,
          // A motion is a widget used to control how the pane animates.
          motion: ScrollMotion(),

          // A pane can dismiss the Slidable.
        //  dismissible: DismissiblePane(onDismissed: () {onDelete(todo);}),

          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              padding: const EdgeInsets.all(1),

              onPressed: ((context) {
                onDelete(todo);
              }),
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),

          ],
        ),

        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey[300],
          ),

                  padding: EdgeInsets.all(4),
                  child: ListTile(
                      title: Text(todo.title,
                        style:const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                              ) ,
                           ),
                      subtitle: Text(
                              DateFormat('dd/MM/yyyy').format(todo.dateTime),
                              style:const TextStyle(
                                    fontSize: 12,
                                 ),
                              ),
                    ),

                  ),
      ),
    );


  }


}
