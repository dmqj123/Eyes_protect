import 'dart:async';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '护眼提醒',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 59, 209, 36)),
        useMaterial3: true,
      ),
      home: MyHomePage(title: '护眼提醒'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: HomePage(

      )
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int time = 5; // 默认5分钟
  bool is_timering = false;

  Future<void> startTimer() async {
    setState(() {
      is_timering = true;
    });
    //窗口最小化
    await windowManager.minimize();
    // 开始倒计时
    Timer(Duration(minutes: time), () async {
      await windowManager.center();
      await windowManager.restore();
      await windowManager.maximize();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          is_timering = false;
          return AlertDialog(
            title: const Text('休息时间到！'),
            content: const Text('请休息一下眼睛，保护视力！'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  startTimer(); // 重新开始计时
                },
                child: const Text('好的'),
              ),
            ],
          );
        },
      );
    });
  }
  @override
  Widget _buildTimerUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "让我们来保护眼睛",
            style: TextStyle(fontSize: 80),
          ),
          const SizedBox(height: 10),
          DropdownButton<int>(
            value: time,
            items: [5, 10, 15, 20, 25, 30, 40, 60].map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('$value 分钟', style: const TextStyle(fontSize: 30, color: Colors.black)),
              );
            }).toList(),
            onChanged: (int? newValue) {
              setState(() {
                time = newValue!;
              });
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              startTimer();
            },
            child: const Text('开始吧！', style: TextStyle(fontSize: 30)),
          ),
        ],
      ),
    );
  }

  Widget _buildProtectingUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "已启用护眼提醒",
            style: TextStyle(
              fontSize: 80,
              color: Colors.green,
              fontWeight: FontWeight.bold
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                is_timering = false;
              });
            },
            child: Text("停止",style: TextStyle(fontSize: 30))
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return !is_timering ? _buildTimerUI() : _buildProtectingUI();
  }
}
