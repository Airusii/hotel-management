import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hotel_app/features/news/create_news_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Аналитика'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateNewsScreen()),
          );
        },
        icon: const Icon(Icons.add_alert),
        label: const Text('Создать новость'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Динамика доходов (Неделя)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: _buildRevenueChart(), // Вызов метода для графика доходов
            ),
            const SizedBox(height: 40),
            const Text(
              'Статус номерного фонда',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: _buildRoomStatusChart(), // Вызов метода для круговой диаграммы
            ),
          ],
        ),
      ),
    );
  }

  // --- Приватные методы для сборки UI ---

  Widget _buildRevenueChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barGroups: [
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 15000, color: Colors.blue, width: 16)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 22000, color: Colors.blue, width: 16)]),
          BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 18000, color: Colors.blue, width: 16)]),
          BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 30000, color: Colors.blue, width: 16)]),
        ],
        titlesData: const FlTitlesData(
          leftTitles: AxisTitles(),
          topTitles: AxisTitles(), // Скрываем лишние оси сверху и слева
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _buildRoomStatusChart() {
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 50,
        sections: [
          PieChartSectionData(
            value: 60,
            title: 'Заняты',
            color: Colors.indigo,
            radius: 40,
            titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          PieChartSectionData(
            value: 30,
            title: 'Свободны',
            color: Colors.teal,
            radius: 40,
            titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          PieChartSectionData(
            value: 10,
            title: 'Уборка',
            color: Colors.orange,
            radius: 40,
            titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
