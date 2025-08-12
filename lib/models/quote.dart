class Quote {
  final int id;
  final String quote;
  final String author;

  Quote({required this.id, required this.quote, required this.author});

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
    id: json['id'] ?? 0,
    quote: json['quote'] ?? '',
    author: json['author'] ?? 'Unknown',
  );

  Map<String, dynamic> toJson() => {'id': id, 'quote': quote, 'author': author};
}
// This class represents a Quote model with properties for id, quote text, and author.
// It includes a factory constructor for creating an instance from JSON and a method for converting the instance to JSON.