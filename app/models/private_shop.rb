class PrivateShop < ApplicationRecord
  attr_encrypted :api_key, key: :encryption_key
  attr_encrypted :password, key: :encryption_key
  attr_encrypted :shared_secret, key: :encryption_key

  def get_products(limit=nil)
    base_site ="https://#{api_key}:#{password}@#{shopify_domain}/admin/api/2022-04/products.json"
    base_site = base_site + "?limit=#{limit}" unless limit.nil? 
    token = {'X-Shopify-Access-Token' => shared_secret}
    begin
      res = RestClient.get(base_site, token)
    rescue RestClient::ExceptionWithResponse, RestClient::Unauthorized, RestClient::Forbidden => err
      err.response
    else
      res.body
    end
  end

  def create_products(product_params)
    base_site = "https://#{api_key}:#{password}@#{shopify_domain}/admin/api/2022-04/products.json"
    token = {'X-Shopify-Access-Token' => shared_secret}
    params = {"product"=> product_params}
    begin
      res = RestClient.post(base_site, params, token)
    rescue RestClient::ExceptionWithResponse, RestClient::Unauthorized, RestClient::Forbidden => err
      err.response
    else
      res.body
    end
  end

  def encryption_key
    key = "j\xCCY\xEC\v\xC0\xCC}\xC3~c\xE6\xD5i&,\xD7T\xD6\xD5\xFF\xCE\xB1s\xE3\xBAqW\xE2\xC7\x98\x9A"
    iv = "[\xE1\x9C^\xCB\xAD\xFF8\x8AC\x90\xC5\x17`\xDA\xB4\xDC\a\xCE\xD8r\xC5\xC0V\xD7\x01\xCF\x1F\xDF\xC0b\xDD"
  end
end
