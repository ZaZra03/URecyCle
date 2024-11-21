import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:urecycle_app/services/leaderboard_service.dart';
import '../../../constants.dart';
import '../../../model/hive_model/leaderboard_model_hive.dart';
import '../../../view/widget/leaderboard_position2.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final LeaderboardService _leaderboardService = LeaderboardService();
  List<LeaderboardEntry>? _leaderboardEntries;
  List<LeaderboardEntry>? _top3Entries;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchLeaderboardData();
  }

  Future<void> _fetchLeaderboardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final leaderboardEntries = await _leaderboardService.fetchLeaderboardEntries();
      final top3Entries = await _leaderboardService.fetchTop3Entries();

      setState(() {
        _leaderboardEntries = leaderboardEntries;
        _top3Entries = top3Entries;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _exportToPdf() async {
    final pdf = pw.Document();

    // Add content to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'Leaderboard Report',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.Divider(),
              if (_top3Entries != null && _top3Entries!.isNotEmpty) ...[
                pw.Text('Top 3 Entries', style: pw.TextStyle(fontSize: 18)),
                pw.SizedBox(height: 10),
                pw.Column(
                  children: _top3Entries!.asMap().entries.map((entry) {
                    final rank = entry.key + 1;
                    final leaderboardEntry = entry.value;
                    return pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 5),
                      child: pw.Text(
                        '$rank. ${leaderboardEntry.name} - ${leaderboardEntry.points} PTS',
                        style: pw.TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                ),
                pw.SizedBox(height: 20),
              ],
              if (_leaderboardEntries != null && _leaderboardEntries!.isNotEmpty) ...[
                pw.Text('Full Leaderboard', style: pw.TextStyle(fontSize: 18)),
                pw.SizedBox(height: 10),
                pw.Column(
                  children: _leaderboardEntries!.asMap().entries.map((entry) {
                    final rank = entry.key + 1;
                    final leaderboardEntry = entry.value;
                    return pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 5),
                      child: pw.Text(
                        '$rank. ${leaderboardEntry.name} - ${leaderboardEntry.points} PTS',
                        style: pw.TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          );
        },
      ),
    );

    // Save the PDF file to the public Downloads folder
    final directory = Directory('/storage/emulated/0/Download');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    final file = File('${directory.path}/LeaderboardReport.pdf');
    await file.writeAsBytes(await pdf.save());

    // Show confirmation
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF saved to Downloads folder: ${file.path}')),
      );
    }
  }


  String _sliceName(String? name) {
    if (name == null) return '';
    final parts = name.split(' ');
    return parts.isNotEmpty ? parts[0] : name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Leaderboards',
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                onPressed: _exportToPdf,
              ),
            ],
            expandedHeight: 275.0,
            floating: false,
            pinned: true,
            backgroundColor: Constants.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (_top3Entries == null || _top3Entries!.isEmpty)
                  ? const Center(child: Text('No leaderboard entries found.'))
                  : Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (_top3Entries!.length > 1)
                          LeaderboardPosition(
                            position: 2,
                            name: _sliceName(_top3Entries![1].name),
                            points: '${_top3Entries![1].points} PTS',
                            color: Colors.orange,
                            isFirst: false,
                          ),
                        if (_top3Entries!.isNotEmpty)
                          LeaderboardPosition(
                            position: 1,
                            name: _sliceName(_top3Entries![0].name),
                            points: '${_top3Entries![0].points} PTS',
                            color: Colors.red,
                            isFirst: true,
                          ),
                        if (_top3Entries!.length > 2)
                          LeaderboardPosition(
                            position: 3,
                            name: _sliceName(_top3Entries![2].name),
                            points: '${_top3Entries![2].points} PTS',
                            color: Colors.purpleAccent,
                            isFirst: false,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          _isLoading
              ? const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          )
              : (_leaderboardEntries == null || _leaderboardEntries!.isEmpty)
              ? const SliverFillRemaining(
            child: Center(child: Text('No leaderboard entries found.')),
          )
              : SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                final entry = _leaderboardEntries![index];
                final rank = index + 1;
                return ListTile(
                  leading: CircleAvatar(child: Text(rank.toString())),
                  title: Text(entry.name),
                  subtitle: Text(entry.college),
                  trailing: Text('${entry.points} PTS'),
                );
              },
              childCount: _leaderboardEntries!.length,
            ),
          ),
        ],
      ),
    );
  }
}
