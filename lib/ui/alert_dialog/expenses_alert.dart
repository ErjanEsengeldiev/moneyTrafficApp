import 'package:flutter/material.dart';

class CustomAlertDialog {
  static expensesAlertDialog({required BuildContext context, required TextEditingController controller},) {
    List<String> _listOfCommonValues = ['15', '11', '50'];
    
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              content: SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Введите Затраты'),
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: controller,
                        keyboardType: const TextInputType.numberWithOptions(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: _listOfCommonValues.length,
                        itemBuilder: (context, index) => ElevatedButton(
                            onPressed: () {
                              setState(() {
                                controller.text = _listOfCommonValues[index];
                              });
                            },
                            child: Text('${_listOfCommonValues[index]} СОМ')),
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 20),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize:
                                Size(MediaQuery.of(context).size.width, 0)),
                        onPressed: () {},
                        child: const Text('ok'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
