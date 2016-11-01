import bigcommerce.api

api = bigcommerce.api.BigcommerceApi(client_id='id', store_hash='hash', access_token='token')

category = api.Categories.update(sort_order=1, search_keywords="tshirt")
