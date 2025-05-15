class Money
  module RatesStore
    # See https://github.com/RubyMoney/money/#exchange-rate-stores
    class Redis
      INDEX_KEY_SEPARATOR = "_TO_".freeze

      REDIS_STORE_KEY = "rates".freeze

      def initialize(connection_params)
        @connection = ::Redis.new(connection_params)
      end

      def add_rate(iso_from, iso_to, rate)
        connection.hdel(REDIS_STORE_KEY, rate_key_for(iso_from, iso_to)) && return if rate.nil?

        connection.hset(REDIS_STORE_KEY, rate_key_for(iso_from, iso_to), rate.to_f)
      end

      def get_rate(iso_from, iso_to)
        connection.hget(REDIS_STORE_KEY, rate_key_for(iso_from, iso_to))&.to_f
      end

      def each_rate
        rates = connection.hgetall(REDIS_STORE_KEY)
        rates.each do |key, rate|
          iso_from, iso_to = key.split(INDEX_KEY_SEPARATOR)
          yield iso_from, iso_to, rate
        end
      end

      def transaction(&)
        connection.multi(&)
      end

      private

      attr_reader :connection

      def rate_key_for(iso_from, iso_to)
        [iso_from, iso_to].join(INDEX_KEY_SEPARATOR).upcase
      end
    end
  end
end
