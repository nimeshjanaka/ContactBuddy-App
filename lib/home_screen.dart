import 'package:buddy/db_helper.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget{
  @override
  State <HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen>{

  List<Map<String, dynamic>> _allData = [];

  bool _isLoading = true;

  //Get all data from database
  void _refreshData() async {
    final data = await SQLHelper.getAllData();
    setState((){
      _allData = data;
      _isLoading = false;
    });
  }


  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  //Add data into the database
  Future<void> _addData() async {
    await SQLHelper.createData(_nameController.text, _phoneController.text, _emailController.text, _groupController.text);
    _refreshData();
  }

  //Update all data
  Future<void> _updateData(int id) async {
    await SQLHelper.updateData(id, _nameController.text, _phoneController.text, _emailController.text, _groupController.text);
    _refreshData();
  }

  //Delete all data
  void _deleteData(int id) async {
    await SQLHelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text("User Deleted"),
    ));
    _refreshData();
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _groupController = TextEditingController();

  void showBottomSheet(int? id) async {

    //if id is not null then it will update otherwise it will new data, when edit icon is pressed then id will be given to bottomSheet function
    //and it will edit
    if(id != null){
      final existingData =
      _allData.firstWhere((element) => element['id'] == id);
      _nameController.text = existingData['name'];
      _phoneController.text = existingData['phone'];
      _emailController.text = existingData['email'];
      _groupController.text = existingData['group'];
    }

    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 30,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Full Name",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Contact Number",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Email",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _groupController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Group",
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if(id == null){
                    await _allData;
                  }
                  if(id != null){
                    await _updateData(id);
                  }

                  _nameController.text ="";
                  _phoneController.text ="";
                  _emailController.text ="";
                  _groupController.text ="";

                  //Hide bottom sheet
                  Navigator.of(context).pop();
                  print("User Added");
                },
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text(id == null ? "Save" : "Update",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      )
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            backgroundColor: Colors.black,
            actions: <Widget>[
              IconButton(icon: Icon(Icons.verified_user, color: Colors.white),
                onPressed: null,)
            ],
            title: Text('Phone', style: GoogleFonts.lato(
                textStyle: TextStyle(color: Colors.white54,
                    fontSize: 30, fontWeight: FontWeight.w600)
            ),),
          ),
          body: new Column(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.all(2.0),
                margin: EdgeInsets.all(5.0),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0))
                      ),
                      prefix: Icon(Icons.search),
                      labelText: 'Search'
                  ),
                  onChanged: (value) {
                    //do Something
                  },
                ),
              ),

              _isLoading ? Center(child:
              CircularProgressIndicator(),): ListView.builder(
                itemCount: _allData.length,
                itemBuilder: (context, index) => Card(
                  margin: EdgeInsets.all(15),
                  child: ListTile(
                    title: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        _allData[index]['Name'],
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    subtitle: Text(_allData[index]['Phone']),
                    trailing: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            showBottomSheet(_allData[index]['id']);
                          },
                          icon: Icon(Icons.edit,
                            color: Colors.blue,),),
                        IconButton(
                          onPressed: () {
                            _deleteData(_allData[index]['id']);
                          },
                          icon: Icon(Icons.delete,
                            color: Colors.red,),)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showBottomSheet(null),
            child: Icon(Icons.add),
          ),
        )
    );
  }
  }

class GoogleFonts {
  static lato({required TextStyle textStyle}) {}
}

