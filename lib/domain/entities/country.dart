class Country {
  final String name;
  final String flagEmoji;
  final String currencyCode;
  final String currencySymbol;
  final double rateToUsd; // mock exchange rate, 1 USD = rateToUsd currency

  const Country({
    required this.name,
    required this.flagEmoji,
    required this.currencyCode,
    required this.currencySymbol,
    required this.rateToUsd,
  });
}
