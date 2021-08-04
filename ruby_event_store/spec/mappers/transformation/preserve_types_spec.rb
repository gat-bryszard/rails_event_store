require 'spec_helper'
require 'json'

module RubyEventStore
  module Mappers
    module Transformation
      RSpec.describe PreserveTypes do
        let(:time)  { Time.now.utc }
        let(:uuid)  { SecureRandom.uuid }
        let(:record)  {
          Record.new(
            event_id:   uuid,
            metadata:   {some: 'meta'},
            data:       {
              'any' => 'data',
              at_some: time,
              nested: {
                another_time: time,
                array: [
                  123,
                  {
                    'deeply_nested' => {
                      time: time,
                      'and' => 'something'
                    }
                  },
                  { and_another_time: time },
                ],
              }
            },
            event_type: 'TestEvent',
            timestamp:  time,
            valid_at:   time
          )
        }
        let(:dump_of_record)  {
          Record.new(
            event_id:   uuid,
            metadata:   {
              some: 'meta',
              types: {
                'any' => 'String',
                'at_some' => 'Time',
                'nested' => {
                  'another_time' => 'Time',
                  'array' => [
                    'Integer',
                    { 'deeply_nested' => {
                        'time' => 'Time',
                        'and' => 'String',
                        '_res_symbol_keys' => ['time']
                      },
                      '_res_symbol_keys' => []
                    },
                    {
                      'and_another_time' => 'Time',
                      '_res_symbol_keys' => ['and_another_time']
                    },
                  ],
                  '_res_symbol_keys' => ['another_time', 'array']
                },
                '_res_symbol_keys' => ['at_some', 'nested']
              },
            },
            data:       {
              'any' => 'data',
              at_some: time,
              nested: {
                another_time: time,
                array: [
                  123,
                  {
                    'deeply_nested' => {
                      time: time,
                      'and' => 'something'
                    }
                  },
                  { and_another_time: time },
                ],
              }
            },
            event_type: 'TestEvent',
            timestamp:  time,
            valid_at:   time
          )
        }

        let(:json_record) {
          Record.new(
            event_id: uuid,
            metadata: TransformKeys.symbolize(JSON.parse(JSON.dump(dump_of_record.metadata))),
            data: JSON.parse(JSON.dump(dump_of_record.data)),
            event_type: 'TestEvent',
            timestamp:  time,
            valid_at:   time
          )
        }

        let(:transformation) {
          PreserveTypes.new.register(
            Time,
            serializer: ->(v) { v.iso8601(9) },
            deserializer: ->(v) { Time.iso8601(v) },
          )
        }

        specify "#dump" do
          result = transformation.dump(record)
          expect(result).to eq(dump_of_record)
          expect(result.metadata).to eq(dump_of_record.metadata)
        end

        specify "#load" do
          result = transformation.load(json_record)
          expect(result).to eq(record)
          expect(result.metadata).to eq({some: 'meta'})
        end
      end
    end
  end
end
