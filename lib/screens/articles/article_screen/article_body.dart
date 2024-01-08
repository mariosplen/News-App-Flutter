import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/articles.dart';
import 'package:flutter_news_app/widgets/custom_chip.dart';

class NewsBody extends StatelessWidget {
  const NewsBody(this.article, {super.key});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomChip(
                borderRadius: BorderRadius.circular(20.0),
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(width: 10),
                  Text(article.date),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                article.description,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                article.content,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
