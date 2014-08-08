# load './db/scripts/parse.rb'
require "net/http"
require "uri"

url = "http://maps.yandex.ru" #"http://localhost:3000/api/v1/t_category"#"http://google.com/"
uri = URI.parse(url)
headers = {
    #"User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36",
    "User-Agent" => "User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:2.0.1) Gecko/20100101 Firefox/4.0.1",
    "Accept" => "*/*",
    "Accept-Language"=>"en-US,en;q=0.8,ru;q=0.6",
    "Accept-Encoding"=>"gzip,deflate,sdch",
    "Connection"=>"keep-alive",
    #"Content-Type"=>"content=application/json; charset=cp-1251;",
}

http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)

response = http.request(request)

keys = response.body.scan(/'(secret-key)':'(\w+\d+)'/) #scan("/'secret-key':'(.+)'/Ui")
key = keys[0][1] if !keys.blank?

puts "response code:" + response.code             # => 301
puts "body:" + response.body             # => The body (HTML, XML, blob, whatever)
# Headers are lowercased
puts "cache:" + response["cache-control"] # => public, max-age=2592000
puts "keys: #{keys}"
puts "key: #{key}"

@cookie = response.response['set-cookie']
puts "cookie: #{@cookie}"

if (!key.blank?)
puts "\n\n--parsing--\n"
key_word = URI.escape("Кинотеатры")
url = "http://maps.yandex.ru/?text=#{key_word}&sll=44.680171999999985,43.01867800002452&sspn=1.0848999023437322,0.16951489115989204&source=catalog&key=#{key}&output=json"
uri = URI.parse(url)
http = Net::HTTP.new(uri.host, uri.port)
json_headers = {
    "Content-Type"=>"application/json; charset=utf-8",
    "Cookie" => @cookie
}
request = Net::HTTP::Get.new(uri.request_uri, json_headers)
response = http.request(request)
document_encoding = response['content-type']


puts "body:" + response.body             # => The body (HTML, XML, blob, whatever)
# Headers are lowercased
puts "cache:" + response["cache-control"] # => public, max-age=2592000
puts "document_encoding:" + document_encoding
puts "url:" + url
puts "response code:" + response.code             # => 301
#resp, data = conn.send_request('GET', uri.request_uri)
#response, data = http.get(url, {
#    #"User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36",
#    "User-Agent" => "User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:2.0.1) Gecko/20100101 Firefox/4.0.1",
#    "Accept" => "*/*",
#    "Accept-Language"=>"en-US,en;q=0.8,ru;q=0.6",
#    "Accept-Encoding"=>"gzip,deflate,sdch",
#    "Connection"=>"keep-alive",
#    #"Content-Type"=>"content=application/json; charset=cp-1251;",
#    "Cookie" => @cookie
#})
end