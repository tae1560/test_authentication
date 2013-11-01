# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Authentication::Application.config.secret_key_base = 'f7568c8a8a13eba0ec6c8f85fe5fbf5ab6023c794ee6c7cee62aaa4d2a622453b24319ff312ef0bb30820710761114403d86a32770fa032a02ef229d3651d295'
