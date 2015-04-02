require 'helper'
require 'rr'
require 'timecop'
require 'pry-byebug'
require 'fluent/plugin/out_decode_location'

class DecodeLoactionOutputTest < Test::Unit::TestCase

  RECORD = {
    "remote":"93.97.192.253",
    "host":"-",
    "user":"-",
    "datetime":"02/Apr/2015:10:05:49 +0200",
    "method":"GET",
    "path":"/widget/core.js?key=D111-96FC-CF47-5B47-1WKpvg&type=2&domain=zmianynaziemi.pl&loc=2713417160022875720572523180974772929416894547711076940525453875:|WmF3YWR6a2k=&url=http%3A%2F%2Fzmianynaziemi.pl%2Fwiadomosc%2Fdoradca-putina-wysmial-publicznie-wiare-ze-brzoza-spowodowala-katastrofe-w-smolensku&is_mobile=false&lang=&cnt=2&ts=1427961948895&referer=http%3A%2F%2Fwww.google.co.uk%2Furl%3Fsa%3Dt%26rct%3Dj%26q%3D%26esrc%3Ds%26source%3Dweb%26cd%3D20%26ved%3D0CHMQFjAJOAo%26url%3Dhttp%253A%252F%252Fzmianynaziemi.pl%252Fwiadomosc%252Fdoradca-putina-wysmial-publicznie-wiare-ze-brzoza-spowodowala-katastrofe-w-smolensku%26ei%3DWvccVf3LAdPSaOKFgYAK%26usg%3DAFQjCNGh8yfYXkXFOEYt4UucoG6uO1H1VQ%26bvm%3Dbv.89744112%2Cd.d2s&status=0&live_preview_hash=&",
    "code":"200",
    "size":"2195",
    "referer":"http://zmianynaziemi.pl/wiadomosc/doradca-putina-wysmial-publicznie-wiare-ze-brzoza-spowodowala-katastrofe-w-smolensku",
    "agent":"Mozilla/5.0 (Windows NT 6.1; WOW64; rv:36.0) Gecko/20100101 Firefox/36.0",
    "parameters":{
      "key":"D111-96FC-CF47-5B47-1WKpvg",
      "type":"2",
      "domain":
      "zmianynaziemi.pl",
      "loc":"2713417160022875720572523180974772929416894547711076940525453875:|WmF3YWR6a2k=",
      "url":"http://zmianynaziemi.pl/wiadomosc/doradca-putina-wysmial-publicznie-wiare-ze-brzoza-spowodowala-katastrofe-w-smolensku",
      "is_mobile":"false",
      "lang":"",
      "cnt":"2",
      "ts":"1427961948895",
      "referer":"http://www.google.co.uk/url?sa=t&rct=j&q=&esrc=s&source=web&cd=20&ved=0CHMQFjAJOAo&url=http%3A%2F%2Fzmianynaziemi.pl%2Fwiadomosc%2Fdoradca-putina-wysmial-publicznie-wiare-ze-brzoza-spowodowala-katastrofe-w-smolensku&ei=WvccVf3LAdPSaOKFgYAK&usg=AFQjCNGh8yfYXkXFOEYt4UucoG6uO1H1VQ&bvm=bv.89744112,d.d2s",
      "status":"0",
      "live_preview_hash":""
    },
    "cookie":{
      "__nc_ms":"c9f833a16d69432eb5f6f538883b026a"
    }
  }

  def setup
    Fluent::Test.setup
    Timecop.freeze(@time)
  end

  teardown do
    Timecop.return
  end

  def create_driver(conf, tag)
    Fluent::Test::OutputTestDriver.new(
      Fluent::DecodeLocationOutput, tag
    ).configure(conf)
  end

  def emit(conf, record, tag='test')
    d = create_driver(conf, tag)
    d.run {d.emit(record)}
    emits = d.emits
  end

  def test_configure
    d = create_driver(%[
      key                test
    ], "test")

    assert_equal 'test',    d.instance.key
    assert_equal 'location_decoded.', d.instance.tag_prefix
  end

  def test_decode
    conf = %[
      
    ]

    record = RECORD.dup

    emits = emit(conf, record)

    emits.each_with_index do |(tag, time, record), i|
      assert_equal 'location_decoded.test', tag
      assert_equal '50.6099014282',  record['lat']
      assert_equal '18.4776992798',  record['lng']
      assert_equal 'EU',             record['continent']
      assert_equal 'PL',             record['countryCode']
      assert_equal '79',             record['province']
      assert_equal 'Zawadzki',       record['city']
    end
  end

  def test_sub_key
    conf = %[
      sub_key  location
    ]

    record = RECORD.dup

    emits = emit(conf, record)

    emits.each_with_index do |(tag, time, record), i|
      assert_equal 'location_decoded.test', tag
      assert_equal '50.6099014282',  record['location']['lat']
      assert_equal '18.4776992798',  record['location']['lng']
      assert_equal 'EU',             record['location']['continent']
      assert_equal 'PL',             record['location']['countryCode']
      assert_equal '79',             record['location']['province']
      assert_equal 'Zawadzki',       record['location']['city']
    end
  end
end
