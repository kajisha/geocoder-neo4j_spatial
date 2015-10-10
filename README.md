# Geocoder::Neo4jSpatial

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'geocoder-neo4j_spatial'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install geocoder-neo4j_spatial

## Usage

```ruby
class Restaurant
  extend Geocoder::Model::ActiveNode

  include Neo4j::ActiveNode
  include Neo4j::ActiveNode::Spatial

  property :address
  property :latitude
  property :longitude

  geocoded_by :address
  after_validation :address, if: :address_changed?

  spatial_index :restaurants
end
```

* Query within distance

```ruby
Restaurant.near(location: 'Eiffel Tower', radius: 10.0).to_a
```

or

```ruby
Restaurant.near(location: [48.85837009999999, 2.2944813], radius: 10.0).to_a
```

will generate following query:

```
 CYPHER 9ms START result_restaurant = node:restaurants({spatial_params}) MATCH (result_restaurant:`Restaurant`) MATCH (result_restaurant:`Restaurant`) RETURN result_restaurant | {:spatial_params=>"withinDistance:[48.85837009999999, 2.2944813, 10.0]"}
```

* not implemented yet
- within_bounding_box

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kajisha/geocoder-neo4j_spatial.

