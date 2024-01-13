import 'package:choice/choice.dart';
import 'package:flutter/material.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({super.key});

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  final List<ChoiceType> sortChoices = [
    ChoiceType('Latest', 'date'),
    ChoiceType('By Title', 'title'),
    ChoiceType('By Author', 'author'),
  ];
  String selectedValue = 'date';

  void setNewSort(String? value) {
    setState(() => selectedValue = value!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Screen')),
      body: Center(
        child: Choice<String>.inline(
          clearable: true,
          value: ChoiceSingle.value(selectedValue),
          onChanged: ChoiceSingle.onChanged(setNewSort),
          itemCount: sortChoices.length,
          itemBuilder: (state, i) {
            final choice = sortChoices[i];
            return ChoiceChip(
              selected: state.selected(choice.value),
              onSelected: state.onSelected(choice.value),
              label: Text(choice.title),
            );
          },
          listBuilder: ChoiceList.createScrollable(
            spacing: 10,
          ),
        ),
      ),
    );
  }
}

class ChoiceType {
  final String title;
  final String value;
  const ChoiceType(this.title, this.value);
}

//
// Test Screen, Write the TestWidget above
//

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Testing Screen')),
      body: Center(
        child: TestWidget(),
      ),
    );
  }
}
