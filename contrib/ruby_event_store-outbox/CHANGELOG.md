### 0.0.20

* Fixed problem with missing constant `SIDEKIQ5_FORMAT`

### 0.0.19

* `RubyEventStore::Outbox::SidekiqScheduler` which works for RES 1.x will is now called `RubyEventStore::Outbox::LegacySidekiqScheduler`
* `RubyEventStore::Outbox::SidekiqScheduler` is now a scheduler for RES 2.x
