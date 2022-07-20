import 'package:demo/screens/primary_button.dart';
import 'package:flutter/material.dart';
import '../models/auth.dart';
import '../models/notes_database.dart';
import '../theme/note_colors.dart';
import 'notes_edit.dart';

Future<List<Map<String, dynamic>>> readDatabase() async {
  try {
    NotesDatabase notesDb = NotesDatabase();
    await notesDb.initDatabase();
    List<Map> notesList = await notesDb.getAllNotes();
    await notesDb.closeDatabase();
    List<Map<String, dynamic>> notesData = List<Map<String, dynamic>>.from(notesList);
    notesData.sort((a, b) => (a['title']).compareTo(b['title']));
    return notesData;
  } catch(e) {

    return [{}];
  }
}


 class NoteListPage extends StatefulWidget {
   NoteListPage({required this.auth, required this.onSignOut});
   final BaseAuth auth;
   final VoidCallback onSignOut;

   @override
   State<NoteListPage> createState() => _NoteListPageState();



 }

 class _NoteListPageState extends State<NoteListPage> {

   late List<Map<String, dynamic>> notesData ;
   List<int> selectedNoteIds = [];

   void afterNavigatorPop() {
     setState(() {});
   }
   void _signOut() async {
     try {
       await widget.auth.signOut();
       widget.onSignOut();
     } catch (e) {
       print(e);
     }

   }


   @override
   void initState() {
     super.initState();
   }

   @override
   Widget build(BuildContext context) {
     return Scaffold(

       appBar: AppBar(
         automaticallyImplyLeading: false,
         backgroundColor: Colors.white,
         actions: <Widget>[
           new FlatButton(
               onPressed: _signOut,
               child: new Text('Logout', style: new TextStyle(fontSize: 17.0, color: Colors.blue))
           )
         ],

         title: Text(
           (selectedNoteIds.length > 0?
           ('Selected ' + selectedNoteIds.length.toString() + '/' + notesData.length.toString()):
           'Flutter Task'
           ),
           style: TextStyle(
               color: Colors.black
           ),
         ),
       ),

       floatingActionButton: (
           selectedNoteIds.length == 0?
           FloatingActionButton(
             child: const Icon(
               Icons.add,
               color: Colors.white,
             ),
             tooltip: 'New Notes',
             backgroundColor: Colors.blue,
             onPressed: () {

               Navigator.pushNamed(
                 context,
                 '/notes_edit',
                 arguments: [
                   'new',
                   [{}],
                 ],
               ).then((dynamic value) {
                 afterNavigatorPop();
               }
               );
               return;
             },
           ):
           null
       ),

       body: FutureBuilder(
           future: readDatabase(),
           builder: (context, snapshot) {
             if (snapshot.hasData) {
               notesData  = snapshot.data as List<Map<String, dynamic>>;
               return Stack(
                 children: <Widget>[
                   // Display Notes
                   AllNoteLists(
                     snapshot.data,
                     this.selectedNoteIds,
                     afterNavigatorPop,
                   ),
                 ],
               );
             } else if (snapshot.hasError) {

             } else {
               return Center(
                 child: CircularProgressIndicator(
                   backgroundColor: Colors.blue,
                 ),
               );
             }
             return Container();
           }
       ),
     );
   }
 }

// Display all notes
class AllNoteLists extends StatelessWidget {
  final data;
  final selectedNoteIds;
  final afterNavigatorPop;


  AllNoteLists(
      this.data,
      this.selectedNoteIds,
      this.afterNavigatorPop,
      );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          dynamic item = data[index];
          return DisplayNotes(
            item,
            selectedNoteIds,
            (selectedNoteIds.contains(item['id']) == false? false: true),
            afterNavigatorPop,
          );
        }
    );
  }
}


// A Note view showing title, first line of note and color
class DisplayNotes extends StatelessWidget {
  final notesData;
  final selectedNoteIds;
  final selectedNote;
  final callAfterNavigatorPop;

  DisplayNotes(
      this.notesData,
      this.selectedNoteIds,
      this.selectedNote,
      this.callAfterNavigatorPop,
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Material(
        elevation: 1,
        color: (selectedNote == false? Colors.blue: Colors.blue),
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(5.0),
        child: InkWell(
          onTap: () {
            if (selectedNote == false) {
              if (selectedNoteIds.length == 0) {
                Navigator.pushNamed(
                  context,
                  '/notes_edit',
                  arguments: [
                    'update',
                    notesData,
                  ],
                ).then((dynamic value) {
                  callAfterNavigatorPop();
                }
                );
                return;
              }

            }

          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children:<Widget>[
                      Text(
                        notesData['title'] != null? notesData['title']: "",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Container(
                        height: 3,
                      ),

                      Text(
                        notesData['content'] != null? notesData['content'].split('\n')[0]: "",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}