require 'mapstraction_plugin/mapping'
require 'mapstraction_plugin/mapstraction'
require 'mapstraction_plugin/overlay'
require 'mapstraction_plugin/helper'

module Ym4r
  module MapstractionPlugin
    class GMapsAPIKeyConfigFileNotFoundException < StandardError
    end

    unless File.exist?(Rails.root.join('config/gmaps_api_key.yml'))
      raise GMapsAPIKeyConfigFileNotFoundException.new("File #{Rails.root.join("config/gmaps_api_key.yml")} not found")
    else
      GMAPS_API_KEY = YAML.load_file(Rails.root.join('config/gmaps_api_key.yml'))[ENV['RAILS_ENV']]
    end
  end
end

include Ym4r::MapstractionPlugin
