import bigcommerce.api

api = bigcommerce.api.BigcommerceApi(client_id='id', store_hash='hash', access_token='token')

rules = api.ProductRules.get(1)
