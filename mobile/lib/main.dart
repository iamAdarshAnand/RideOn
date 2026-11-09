import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Emulator: 10.0.2.2; physical device: your computer's LAN IP.
const apiBase = String.fromEnvironment('API_URL', defaultValue: 'http://10.0.2.2:3000');
void main() => runApp(const RideonApp());
class RideonApp extends StatelessWidget {
  const RideonApp({super.key});
  @override Widget build(BuildContext context) => MaterialApp(
    title: 'RIDEON', debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xfff6c744), scaffoldBackgroundColor: const Color(0xfffafafa)),
    home: const HomePage());
}
class HomePage extends StatefulWidget { const HomePage({super.key}); @override State<HomePage> createState() => _HomePageState(); }
class _HomePageState extends State<HomePage> {
  String role = 'passenger', vehicle = 'bike', status = 'idle', message = '';
  String? rideId;
  final pickup = TextEditingController(text: 'Central Station');
  final drop = TextEditingController(text: 'City Mall');
  final driverName = TextEditingController(text: 'Demo Captain');
  List<dynamic> rides = [];
  bool busy = false;
  Future<Map<String,dynamic>> request(String path, {String method='GET', Map<String,dynamic>? data}) async {
    final uri = Uri.parse('$apiBase$path');
    final response = await (method == 'POST' ? http.post(uri, headers: {'Content-Type':'application/json'}, body:jsonEncode(data ?? {})) : http.get(uri));
    final decoded = jsonDecode(response.body);
    if (response.statusCode >= 400) throw Exception(decoded['error'] ?? 'Request failed');
    return Map<String,dynamic>.from(decoded);
  }
  Future<void> run(Future<void> Function() fn) async {
    setState(() { busy=true; message=''; });
    try { await fn(); } catch(e) { setState(() => message = '$e'); }
    finally { if (mounted) setState(() => busy=false); }
  }
  Future<void> refresh() async { final result = await request('/api/rides'); setState(() => rides=result['rides'] as List<dynamic>); }
  Future<void> book() => run(() async {
    final result = await request('/api/rides', method:'POST', data:{'passengerName':'Demo Passenger','pickup':pickup.text,'dropoff':drop.text,'vehicle':vehicle});
    setState(() { rideId=result['ride']['id'].toString(); status=result['ride']['status']; message='Ride requested • Fare estimate: ${result['ride']['fare']}'; });
    await refresh();
  });
  Future<void> updateRide(String id, String action) => run(() async {
    final result = await request('/api/rides/$id/$action',method:'POST',data:{'driverName':driverName.text});
    setState(() { status=result['ride']['status']; message='Ride ${result['ride']['status']}'; });
    await refresh();
  });
  @override void initState(){super.initState(); Future.microtask(() async {try {await refresh();} catch(_) {}});}
  @override void dispose(){pickup.dispose();drop.dispose();driverName.dispose();super.dispose();}
  Widget field(String label, TextEditingController c) => Padding(padding:const EdgeInsets.only(bottom:12),child:TextField(controller:c,decoration:InputDecoration(labelText:label,border:const OutlineInputBorder())));
  @override Widget build(BuildContext context) => Scaffold(
    appBar:AppBar(title:const Text('RIDEON  /  MOVE FREELY',style:TextStyle(fontWeight:FontWeight.w900)),backgroundColor:const Color(0xfff6c744)),
    body:SafeArea(child:ListView(padding:const EdgeInsets.all(20),children:[
      SegmentedButton<String>(segments:const [ButtonSegment(value:'passenger',label:Text('Passenger'),icon:Icon(Icons.person)),ButtonSegment(value:'captain',label:Text('Captain'),icon:Icon(Icons.two_wheeler))],selected:{role},onSelectionChanged:(v)=>setState(()=>role=v.first)),
      const SizedBox(height:22),
      if(role=='passenger') ...[
        const Text('Where to?',style:TextStyle(fontSize:30,fontWeight:FontWeight.bold)),const SizedBox(height:16),
        field('Pickup location',pickup),field('Destination',drop),
        const Text('Choose your ride',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold)),
        const SizedBox(height:8),
        Wrap(spacing:8,children:[for(final v in ['bike','auto','cab']) ChoiceChip(label:Text(v.toUpperCase()),selected:vehicle==v,onSelected:(_)=>setState(()=>vehicle=v))]),
        const SizedBox(height:18),FilledButton.icon(onPressed:busy?null:book,icon:const Icon(Icons.local_taxi),label:const Text('Request ride')),
        const SizedBox(height:12),const Text('Fare shown is a demo estimate; no GPS routing or payment is connected.',style:TextStyle(color:Colors.black54)),
      ] else ...[
        const Text('Captain console',style:TextStyle(fontSize:30,fontWeight:FontWeight.bold)),const SizedBox(height:16),
        field('Captain name',driverName),const Text('Available ride requests',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold)),
      ],
      if(message.isNotEmpty) Padding(padding:const EdgeInsets.symmetric(vertical:16),child:Text(message,style:const TextStyle(fontWeight:FontWeight.w600))),
      const Divider(height:32),Row(children:[const Expanded(child:Text('Recent trips',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold))),IconButton(onPressed:busy?null:()=>run(refresh),icon:const Icon(Icons.refresh))]),
      if(rides.isEmpty) const Text('No rides yet. Start by requesting one.'),
      for(final raw in rides) Builder(builder:(context){final r=Map<String,dynamic>.from(raw);final id=r['id'].toString();final st=r['status'].toString();return Card(child:Padding(padding:const EdgeInsets.all(12),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text('${r['vehicle'].toString().toUpperCase()}  •  ${r['fare']} credits',style:const TextStyle(fontWeight:FontWeight.bold)),
        Text('${r['pickup']} → ${r['dropoff']}'),Text('Status: $st'),
        if(role=='captain' && st=='requested') TextButton(onPressed:busy?null:()=>updateRide(id,'accept'),child:const Text('Accept ride')),
        if(role=='captain' && st=='accepted') TextButton(onPressed:busy?null:()=>updateRide(id,'start'),child:const Text('Start trip')),
        if(role=='captain' && st=='in_progress') TextButton(onPressed:busy?null:()=>updateRide(id,'complete'),child:const Text('Complete trip')),
        if(role=='passenger' && (st=='requested'||st=='accepted')) TextButton(onPressed:busy?null:()=>updateRide(id,'cancel'),child:const Text('Cancel ride')),
      ])) );}),
    ])));
}
