import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    // Fetch disposal data when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      adminProvider.fetchDisposalData();
    });

    // Listen to page changes, but only call setState when the page changes
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
    _pageController.dispose(); // Clean up the controller when the widget is disposed
    super.dispose();
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: 2, // Number of pages
                itemBuilder: (context, index) {
                  return index == 0
                      ? _buildPieChartPage(adminProvider)
                      : _buildBarChartPage(adminProvider);
                },
              ),
            ),
            // Custom Page Indicator
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
    return Center( // Centering the content
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center vertically within the column
        children: [
          const Text(
            'Waste Type Distribution',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          _buildPieChart(adminProvider),
        ],
      ),
    );
  }

  Widget _buildBarChartPage(AdminProvider adminProvider) {
    return Center( // Centering the content
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center vertically within the column
        children: [
          const Text(
            'Weekly Disposals',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          _buildBarChart(adminProvider),
        ],
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

  Widget _buildBarChart(AdminProvider adminProvider) {
    if (adminProvider.weeklyDisposals.isEmpty) {
      return const Center(child: Text('No data available for the bar chart'));
    }

    // Generate bar groups based on the number of disposals for each day of the week
    List<BarChartGroupData> barGroups = List.generate(7, (index) {
      // Count the number of disposals for each day of the week (assuming Monday is day 1)
      int countForDay = adminProvider.weeklyDisposals
          .where((disposal) => disposal.createdAt.weekday == index + 1) // Access the weekday via createdAt
          .length; // Count the number of disposals for each day

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: countForDay.toDouble(), // Convert count to double for the chart
            color: Colors.blueAccent,
            width: 20,
          ),
        ],
      );
    });

    return Center(
      child: SizedBox(
        height: 500, // Increase the height for a longer chart
        child: BarChart(
          BarChartData(
            maxY: 100, // Set the maximum Y value to 100
            alignment: BarChartAlignment.spaceAround,
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(daysOfWeek[value.toInt()], style: const TextStyle(fontSize: 12)),
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
            borderData: FlBorderData(show: false),
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
