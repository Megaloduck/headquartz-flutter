/// Runtime flags. Currently fixed; could be wired to env vars or
/// command-line args later.
class Environment {
  const Environment({
    this.verboseLogging = true,
    this.enableReplays = true,
    this.enableMdns = true,
  });

  final bool verboseLogging;
  final bool enableReplays;
  final bool enableMdns;

  static const Environment current = Environment();
}
