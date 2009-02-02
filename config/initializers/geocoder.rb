Geocode.geocoder = Graticule.service(:multi).new(
  Graticule.service(:google).new('ABQIAAAAOkkjGnUViOlSTqNrxWlUORSup9HLPBLhPrxlcb6YbN6eSslq5BSI3irb2g6UceymFXlAH8Rs526GrQ'),
  Graticule.service(:yahoo).new("api_key")
)