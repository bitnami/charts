# Function to get price of Cryptocurrencies

```
kubeless function deploy crypto --from-file crypto.py --handler crypto.handler --runtime python2.7 --trigger-http --dependencies requirements.txt
```

Then call the function, specifying with crypto currency you want to get the price of:

```
kubeless function call crypto --data '{"crypto": "bitcoin"}'
Connecting to function...
Forwarding from 127.0.0.1:30000 -> 8080
Forwarding from [::1]:30000 -> 8080
Handling connection for 30000
10074.8
```


