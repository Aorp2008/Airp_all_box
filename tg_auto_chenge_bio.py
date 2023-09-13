from pyrogram import Client
import requests

api_id = ''  # app_id
api_hash = ''  # app_hash



with Client("my_account", api_id, api_hash) as app:
    bio_text = requests.get('https://api.oddfar.com/yl/q.php?c=2009&encode=text').text
    app.update_profile(bio=bio_text)
    print(f'已更新简介{bio_text}')
