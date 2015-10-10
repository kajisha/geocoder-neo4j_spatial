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
          if location.is_a?(Array)
            coordinates = location << radius.to_f

            base.within(coordinates)
          else
            coordinates = Geocoder::Calculations.extract_coordinates(location)

            if Geocoder::Calculations.coordinates_present?(*coordinates)
              coordinates << radius.to_f

              base.within(coordinates)
            else
              []
            end
          end
        }

        scope :within, -> (coordinates) {
          query_proxy = instance_variable_get(:@query_proxy)
          spatial_match(query_proxy.node_identity, "withinDistance:#{coordinates}")
        }
      end
    end

    def geocode
      do_lookup(false) do |o, rs|
        if r = rs.first
          unless r.latitude.nil? or r.longitude.nil?
            o.__send__ "#{self.class.geocoder_options[:latitude]}=",  r.latitude
            o.__send__ "#{self.class.geocoder_options[:longitude]}=", r.longitude

            o.add_to_spatial_index o.class.spatial_index_name
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

    def nearbys(radius = 20)
      return nil unless geocoded?

      self.class.near(location: to_coordinates, radius: radius)
    end
  end
end
