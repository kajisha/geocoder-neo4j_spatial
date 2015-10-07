require 'geocoder/stores/base'

module Geocoder::Store
  module Neo4j
    include Base

    def self.included(base)
      base.class_eval do
        scope :geocoded, -> {
          where_not(base.geocoder_options[:latitude] => nil, base.geocoder_options[:longitude] => nil)
        }

        scope :not_geocoded, -> {
          where(base.geocoder_options[:latitude] => nil, base.geocoder_options[:longitude] => nil)
        }

        scope :near, -> (location:, radius:) {
          coordinates = Geocoder::Calculations.extract_coordinates(location)

          if Geocoder::Calculations.coordinates_present?(*coordinates)
            coordinates << radius

            query_proxy = instance_variable_get(:@query_proxy)
            spatial_match(query_proxy.node_identity, "withinDistance:#{coordinates}")
          else
            []
          end
        }
      end
    end

    def geocode
      do_lookup(false) do |o, rs|
        if r = rs.first
          unless r.latitude.nil? or r.longitude.nil?
            o.__send__  "#{self.class.geocoder_options[:latitude]}=",  r.latitude
            o.__send__  "#{self.class.geocoder_options[:longitude]}=", r.longitude
          end

          r.coordinates
        end
      end
    end

    def reverse_geocode
      do_lookup(true) do |o, rs|
        if r = rs.first
          unless r.address.nil?
            o.__send__ "#{self.class.geocoder_options[:fetched_address]}=", r.address
          end

          r.address
        end
      end
    end
  end
end
