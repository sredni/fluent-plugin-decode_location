## Fluent::Plugin::DecodeLoaction, a plugin for [Fluentd](http://fluentd.org)

Fluentd plugin to decode location.

Basic usage
```
<match foo.**>
  type           decode_location
  key            parameters.loc
</match>

input
"test" {
  "parameters":{
    "loc":"2713417160022875720572523180974772929416894547711076940525453875:|WmF3YWR6a2k="
  }
}

output
    "location_decoded.test" {
      "parameters":{
	    "loc":"2713417160022875720572523180974772929416894547711076940525453875:|WmF3YWR6a2k="
	  },
      "lat": "50.6099014282",
      "lng": "18.4776992798",
      "continent": "EU",
      "countryCode": "PL",
      "province": "79",
      "city": "Zawadzki"
    }
```

If you want create key with parsed data.
```
<match foo.**>
  type           decode_location
  key            location.loc
  sub_key        location
</match>

input
"test" {
  "parameters":{
    "loc":"2713417160022875720572523180974772929416894547711076940525453875:|WmF3YWR6a2k="
  }
}

output
    "location_decoded.test" {
      "parameters":{
	    "loc":"2713417160022875720572523180974772929416894547711076940525453875:|WmF3YWR6a2k="
	  },
	  "location": {
        "lat": "50.6099014282",
        "lng": "18.4776992798",
        "continent": "EU",
        "countryCode": "PL",
        "province": "79",
        "city": "Zawadzki"
      }
    }
```

## Option Parameters

### key :String
key is used to point a key thad is cookie.

### tag_prefix :String
Added tag prefix.
Default value is "parsed."

### sub_key :String
You want to put parsed data into separate key.
Default value is false.

## Change log
See [CHANGELOG.md](https://github.com/sredni/fluent-plugin-decode_location/blob/master/CHANGELOG.md) for details.

## Contributing

1. Fork it ( https://github.com/sredni/fluent-plugin-decode_location/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
