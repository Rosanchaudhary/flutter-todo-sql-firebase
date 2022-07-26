import 'package:client/blocs/cubit/internet_cubit.dart';
import 'package:client/blocs/todos/todos_bloc.dart';
import 'package:client/helper/firebase_repository.dart';
import 'package:client/helper/sql_helper.dart';
import 'package:client/screens/list_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SQLHelper>(create: (context) => SQLHelper()),
        RepositoryProvider(create: (context)=>FireBaseRepository(firebaseFirestore: FirebaseFirestore.instance))
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => InternetCubit(connectivity: Connectivity())),
          BlocProvider(
              create: (context) => TodosBloc(
                fireBaseRepository: context.read<FireBaseRepository>(),
                  internetCubit: context.read<InternetCubit>(),
                  sqlHelper: context.read<SQLHelper>())),
          

        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const TodoList(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
