import bigcommerce.api

api = bigcommerce.api.BigcommerceApi(client_id='id', store_hash='hash', access_token='token')

custom = api.ProductCustomFields.update(products[0].id, name="Manufactured in", text="USA")