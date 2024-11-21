import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import '../../../constants.dart';
import '../../../provider/admin_provider.dart';

class VisualMetricsScreen extends StatefulWidget {
  const VisualMetricsScreen({super.key});

  @override
  State createState() => _VisualMetricsScreenState();
}

class _VisualMetricsScreenState extends State<VisualMetricsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      adminProvider.fetchDisposalData();
    });

    _pageController.addListener(() {
      final newPage = _pageController.page!.round();
      if (newPage != _currentPage) {
        setState(() {
          _currentPage = newPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _exportToPdf(AdminProvider adminProvider) async {
    final pdf = pw.Document();

    // Get the waste type counts
    final wasteTypeCounts = adminProvider.wasteTypeTotals;

    // Build content for the single page
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          const daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
          final weeklyData = List.generate(
            7,
                (index) => adminProvider.weeklyDisposals
                .where((disposal) => disposal.createdAt.weekday == index + 1)
                .length,
          );

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Title
              pw.Center(
                child: pw.Text(
                  'Visual Metrics Report',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.Divider(),

              // Waste Type Counts
              if (wasteTypeCounts.isNotEmpty) ...[
                pw.Text('Waste Type Counts', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: wasteTypeCounts.entries.map((entry) {
                    return pw.Container(
                      margin: const pw.EdgeInsets.symmetric(vertical: 5),
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              entry.key,
                              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Expanded(
                            flex: 5,
                            child: pw.Stack(
                              children: [
                                pw.Container(
                                  height: 20,
                                  decoration: pw.BoxDecoration(
                                    color: PdfColor.fromHex('#e0e0e0'),
                                    borderRadius: pw.BorderRadius.circular(10),
                                  ),
                                ),
                                pw.Container(
                                  height: 20,
                                  width: (entry.value / wasteTypeCounts.values.reduce((a, b) => a > b ? a : b)) * 200,
                                  decoration: pw.BoxDecoration(
                                    color: PdfColor.fromHex('#3b82f6'), // Blue color
                                    borderRadius: pw.BorderRadius.circular(10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          pw.SizedBox(width: 10),
                          pw.Text('${entry.value}', style: const pw.TextStyle(fontSize: 14)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                pw.SizedBox(height: 20),
              ],

              // Pie Chart Data
              if (adminProvider.wasteTypePercentages.isNotEmpty) ...[
                pw.Text('Waste Type Distribution', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                ...adminProvider.wasteTypePercentages.entries.map(
                      (entry) => pw.Text(
                    '${entry.key}: ${entry.value.toStringAsFixed(1)}%',
                    style: const pw.TextStyle(fontSize: 14),
                  ),
                ),
                pw.SizedBox(height: 20),
              ],

              // Bar Chart Data
              if (adminProvider.weeklyDisposals.isNotEmpty) ...[
                pw.Text('Weekly Disposals', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.TableHelper.fromTextArray(
                  headers: daysOfWeek,
                  data: [weeklyData.map((count) => count.toString()).toList()],
                  cellStyle: const pw.TextStyle(fontSize: 12),
                  headerStyle: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
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
    final file = File('${directory.path}/VisualMetricsReport.pdf');
    await file.writeAsBytes(await pdf.save());

    // Show confirmation
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF saved to Downloads folder: ${file.path}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Visual Metrics',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Constants.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _exportToPdf(adminProvider),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return index == 0
                      ? _buildPieChartPage(adminProvider)
                      : _buildBarChartPage(adminProvider);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (index) => _buildPageIndicator(index)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChartPage(AdminProvider adminProvider) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Waste Type Distribution',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _buildPieChart(adminProvider),
            const SizedBox(height: 50),
            const Text(
              'Number of Items per Category',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildCategoryCountBullets(adminProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(AdminProvider adminProvider) {
    if (adminProvider.wasteTypePercentages.isEmpty) {
      return const Center(child: Text('No data available for the pie chart'));
    }

    return Center( // Centering the chart
      child: SizedBox(
        width: 300, // Increase the width
        height: 300, // Increase the height
        child: PieChart(
          PieChartData(
            sections: adminProvider.wasteTypePercentages.entries.map((entry) {
              return PieChartSectionData(
                value: entry.value,
                title: '${entry.key} (${entry.value.toStringAsFixed(1)}%)',
                color: _getColorForWasteType(entry.key),
                radius: 50,
                titleStyle: const TextStyle(fontSize: 12, color: Colors.black),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCountBullets(AdminProvider adminProvider) {
    final wasteTypeCounts = adminProvider.wasteTypeTotals;
    if (wasteTypeCounts.isEmpty) {
      return const Center(child: Text('No data available for item counts'));
    }

    // Find the maximum count to scale the bars
    int maxCount = wasteTypeCounts.values.reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: wasteTypeCounts.entries.map((entry) {
        double percentage = (entry.value / maxCount) * 100;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  entry.key,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Container(
                      height: 20,
                      width: (percentage.isFinite)
                          ? percentage * 2.5
                          : 0, // Provide a default fallback value
                      decoration: BoxDecoration(
                        color: _getColorForWasteType(entry.key),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${entry.value}', // Display the count of items
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBarChartPage(AdminProvider adminProvider) {
    // Calculate total waste count for the week
    int totalWasteCount = adminProvider.weeklyDisposals.length;

    return Center( // Centering the content
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center vertically within the column
        children: [
          const Text(
            'Weekly Disposals',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // Display total waste count
          Text(
            'Total Waste Count: $totalWasteCount',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 30),
          _buildBarChart(adminProvider),
        ],
      ),
    );
  }


  Widget _buildBarChart(AdminProvider adminProvider) {
    if (adminProvider.weeklyDisposals.isEmpty) {
      return const Center(child: Text('No data available for the bar chart'));
    }

    List<BarChartGroupData> barGroups = List.generate(7, (index) {
      int countForDay = adminProvider.weeklyDisposals
          .where((disposal) => disposal.dayOfWeek == index + 2)
          .length;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: countForDay.toDouble(),
            color: Colors.blueAccent,
            width: 20,
          ),
        ],
      );
    });

    return Center(
      child: SizedBox(
        height: 500,
        width: double.infinity, // Allow the bar chart to take full width
        child: BarChart(
          BarChartData(
            maxY: 100,
            alignment: BarChartAlignment.spaceAround,
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 10,
                  getTitlesWidget: (value, meta) {
                    const daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        daysOfWeek[value.toInt()],
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 10, // Set the step interval to 10 for whole numbers
                  getTitlesWidget: (value, meta) {
                    if (value % 10 == 0) { // Show titles only for whole number steps
                      return Text(value.toInt().toString(), style: const TextStyle(fontSize: 12));
                    }
                    return const SizedBox.shrink(); // Return an empty widget for non-whole number steps
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: true),
            barGroups: barGroups,
          ),
        ),
      ),
    );
  }

  // Helper function to create page indicators
  Widget _buildPageIndicator(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.blue : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }

  // Helper function to get color for different waste types
  Color _getColorForWasteType(String wasteType) {
    switch (wasteType) {
      case 'Cardboard':
        return Colors.red;
      case 'Glass':
        return Colors.green;
      case 'Metal':
        return Colors.blue;
      case 'Paper':
        return Colors.orange;
      case 'Plastic':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}