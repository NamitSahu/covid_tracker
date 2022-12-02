import 'package:covid_tracker/View/countries_list.dart';
import 'package:covid_tracker/models/world_states_model.dart';
import 'package:covid_tracker/services/states_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStateScreen extends StatefulWidget {
  const WorldStateScreen({Key? key}) : super(key: key);

  @override
  State<WorldStateScreen> createState() => _WorldStateScreenState();
}

class _WorldStateScreenState extends State<WorldStateScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 3))
        ..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final colorList = <Color>[
    const Color(0xFF4285f4),
    const Color(0xFF1aa260),
    const Color(0xFFde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                FutureBuilder(
                    future: statesServices.fetchWorkedStatesRecords(),
                    builder: (context, AsyncSnapshot<WorldStatesModel> snapshot) {
                      if (!snapshot.hasData) {
                        return Expanded(
                          flex: 1,
                          child: SpinKitFadingCircle(
                            color: Colors.white38,
                            size: 50.0,
                            controller: _controller,
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            PieChart(
                              dataMap: {
                                "Total": double.parse(
                                    snapshot.data!.cases!.toString()),
                                "Recovered": double.parse(
                                    snapshot.data!.recovered.toString()),
                                "Death": double.parse(
                                    snapshot.data!.deaths!.toString()),
                              },
                              chartValuesOptions: const ChartValuesOptions(
                                showChartValuesInPercentage: true,
                              ),
                              chartRadius:
                                  MediaQuery.of(context).size.width / 3.2,
                              legendOptions: const LegendOptions(
                                  legendPosition: LegendPosition.left),
                              animationDuration:
                                  const Duration(milliseconds: 1200),
                              chartType: ChartType.ring,
                              colorList: colorList,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).size.height * 0.06),
                              child: Card(
                                child: Column(
                                  children: [
                                    ReusableRow(
                                        title: "Total",
                                        value: snapshot.data!.cases!.toString()),
                                    ReusableRow(
                                        title: "Deaths",
                                        value: snapshot.data!.deaths!.toString()),
                                    ReusableRow(
                                        title: "Recovered",
                                        value:
                                            snapshot.data!.recovered!.toString()),
                                    ReusableRow(
                                        title: "Active",
                                        value: snapshot.data!.active!.toString()),
                                    ReusableRow(
                                        title: "Critical",
                                        value:
                                            snapshot.data!.critical!.toString()),
                                    ReusableRow(
                                        title: "Today Deaths",
                                        value: snapshot.data!.todayDeaths!
                                            .toString()),
                                    ReusableRow(
                                        title: "Today Recovered",
                                        value: snapshot.data!.todayRecovered!
                                            .toString()),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          const CountriesListScreen()),
                                );
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    color: const Color(0xff1aa260),
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Center(
                                  child: Text("Track Countries",
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  final String title, value;
  const ReusableRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          const SizedBox(height: 5),
          const Divider()
        ],
      ),
    );
  }
}
