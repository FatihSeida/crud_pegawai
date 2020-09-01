import 'package:crud_pegawai/providers/employee_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'employee_add.dart';
import 'employee_edit.dart';

class Employee extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FS Employee CRUD'),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            Provider.of<EmployeeProvider>(context, listen: false).getEmployee(),
        color: Colors.red,
        child: Container(
          margin: EdgeInsets.all(10),
          child: FutureBuilder(
            future: Provider.of<EmployeeProvider>(context, listen: false)
                .getEmployee(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Consumer<EmployeeProvider>(builder: (context, data, _) {
                return ListView.builder(
                  itemCount: data.dataEmployee.length,
                  itemBuilder: (context, i) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EmployeeEdit(
                              id: data.dataEmployee[i].id,
                            ),
                          ),
                        );
                      },
                      child: Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (DismissDirection direction) async {
                          final bool res = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Konfirmasi'),
                                  content: Text('Kamu Yakin?'),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text('HAPUS'),
                                    ),
                                    FlatButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text('BATALKAN'),
                                    ),
                                  ],
                                );
                              });
                          return res;
                        },
                        onDismissed: (value) {
                          Provider.of<EmployeeProvider>(context, listen: false)
                              .deleteEmployee(data.dataEmployee[i].id);
                        },
                        child: Card(
                          elevation: 8,
                          child: ListTile(
                            title: Text(
                              data.dataEmployee[i].employeeName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                                'Umur: ${data.dataEmployee[i].employeeAge}'),
                            trailing: Text(
                                '\$${data.dataEmployee[i].employeeSalary}'),
                          ),
                        ),
                      ),
                    );
                  },
                );
              });
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        child: Text('+'),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => EmployeeAdd()));
        },
      ),
    );
  }
}
