# -*- coding: utf-8 -*-
require 'sinatra'
require 'json'
require 'time'
require 'net/http'
require 'uri'

get '/' do
  erb :index
end

get '/a1728yn' do
  erb :a1728yn
end

get '/to_unixtime/:yyyymmdd' do
  yyyymmdd  = params['yyyymmdd']
  unixtime = Time.parse(yyyymmdd).to_i
  "#{unixtime}"
end

get '/kuroki' do
  erb :kuroki
end

post '/kurokiresult' do
  @network = params[:network]
  @wariai = params[:wariai]
  erb :kurokiresult
end

get '/nakanishi' do
  erb :nakanishi
end

get '/postcode' do
  @postcode = params[:postcode]
  show(@postcode)
  erb :address
end

def show(postcode)
    # hash形式でパラメタ文字列を指定し、URL形式にエンコード
    params = URI.encode_www_form({zipcode: "#{postcode}"})
    # URIを解析し、hostやportをバラバラに取得できるようにする
    uri = URI.parse("http://zipcloud.ibsnet.co.jp/api/search?#{params}")
    # リクエストパラメタを、インスタンス変数に格納
    @query = uri.query

    # 新しくHTTPセッションを開始し、結果をresponseへ格納
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      # 接続時に待つ最大秒数を設定
      http.open_timeout = 5
      # 読み込み一回でブロックして良い最大秒数を設定
      http.read_timeout = 10
      # ここでWebAPIを叩いている
      # Net::HTTPResponseのインスタンスが返ってくる
      http.get(uri.request_uri)
    end
    # 例外処理の開始
    begin
      # responseの値に応じて処理を分ける
      case response
      # 成功した場合
      when Net::HTTPSuccess
        # responseのbody要素をJSON形式で解釈し、hashに変換
        @result = JSON.parse(response.body)
        # 表示用の変数に結果を格納
#        @zipcode = @result["results"][0]["zipcode"]
        @address1 = @result["results"][0]["address1"]
        @address2 = @result["results"][0]["address2"]
        @address3 = @result["results"][0]["address3"]
      # 別のURLに飛ばされた場合
      when Net::HTTPRedirection
        @message = "Redirection: code=#{response.code} message=#{response.message}"
      # その他エラー
      else
        @message = "HTTP ERROR: code=#{response.code} message=#{response.message}"
      end
    # エラー時処理
    rescue IOError => e
      @message = "e.message"
    rescue TimeoutError => e
      @message = "e.message"
    rescue JSON::ParserError => e
      @message = "e.message"
    rescue => e
      @message = "e.message"
    end
  end

