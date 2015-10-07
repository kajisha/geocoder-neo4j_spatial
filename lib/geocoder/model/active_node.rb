require 'geocoder/models/base'

module Geocoder
  module Model
    module ActiveNode
      include Base

      def geocoded_by(address_attr, options = {}, &block)
        geocoder_init(
          geocode: true,
          user_address: address_attr,
          latitude: options[:latitude] || :latitude,
          longitude: options[:longitude] || :longitude,
          geocode_block: block,
          units: options[:units],
          method: options[:method],
          lookup: options[:lookup],
          language: options[:language]
        )
      end

      def reverse_geocoded_by(latitude_attr, longitude_attr, options = {}, &block)
        geocoder_init(
          reverse_geocode: true,
          fetched_address: options[:address] || :address,
          latitude: latitude_attr,
          longitude: longitude_attr,
          geocode_block: block,
          units: options[:units],
          method: options[:method],
          lookup: options[:lookup],
          language: options[:language]
        )
      end

      def geocoder_init(options)
        unless defined?(@geocoder_options)
          @geocoder_options = {}

          require 'geocoder/stores/neo4j'
          include Geocoder::Store::Neo4j
        end

        @geocoder_options = options
      end
    end
  end
end
