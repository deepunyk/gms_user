import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gms_core/models/collection.dart';
import 'package:gms_core/services/collection_service.dart';
import 'package:gms_core/services/report_service.dart';
import 'package:gms_user/widgets/custom_error_widget.dart';
import 'package:gms_user/widgets/custom_loading_button.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CollectionScreen extends StatefulWidget {
  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  List<Collection> collections = [];

  bool isLoad = true;

  getCollections() async {
    CollectionService collectionService = CollectionService();
    collections = await collectionService.getCollections();
    isLoad = false;
    setState(() {});
  }

  addReport() {
    ReportService reportService = ReportService();

    Get.dialog(AlertDialog(
      title: Text("Report an Issue"),
      content: Text(
          "Click on the report button if your garbage was not collected today. Your report will be sent to the officials."),
      actions: [
        FlatButton(
            onPressed: () {
              Get.close(1);
            },
            child: Text("Back")),
        FlatButton(
            onPressed: () async {
              Get.close(1);
              isLoad = true;
              setState(() {});
              await reportService.addReport();

              Get.rawSnackbar(
                  message:
                      "Your report has been sent to the government officials");
              isLoad = false;
              setState(() {});
            },
            child: Text("Report")),
      ],
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCollections();
  }

  @override
  Widget build(BuildContext context) {
    return isLoad
        ? CustomLoading()
        : collections.length == 0
            ? CustomErrorWidget(
                title: "No collections found",
                iconData: MdiIcons.deleteEmpty,
              )
            : SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: Get.height * 0.05,
                      ),
                      Text(
                        "COLLECTION HISTORY",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 22),
                      ),
                      SizedBox(
                        height: Get.height * 0.03,
                      ),
                      Container(
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final date = DateTime(
                                collections[index].startTime.year,
                                collections[index].startTime.month,
                                collections[index].startTime.day);
                            final now = DateTime.now();
                            final today =
                                DateTime(now.year, now.month, now.day);
                            return collections[index].startTime !=
                                    collections[index].endTime
                                ? Card(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: Get.width * 0.04),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Get.width * 0.08,
                                          vertical: 16),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Date: ${DateFormat.yMMMEd().format(collections[index].startTime)}",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 0.5,
                                            color:
                                                Theme.of(context).primaryColor,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 16),
                                          ),
                                          Text(
                                            "Collected between: ${DateFormat.jm().format(collections[index].startTime)} - ${DateFormat.jm().format(collections[index].endTime)}",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          if (date == today)
                                            Container(
                                              margin: EdgeInsets.only(top: 16),
                                              child: RaisedButton(
                                                onPressed: () {
                                                  addReport();
                                                },
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                child: Text(
                                                  "Report",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink();
                          },
                          itemCount: collections.length,
                        ),
                      ),
                    ],
                  ),
                ),
              );
  }
}
