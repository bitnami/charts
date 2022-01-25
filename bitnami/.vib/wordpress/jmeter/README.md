# JMeter sources

This folder contians a JMeter test plan file to load test a wordpress instace. The project simulates a 5 seconds ramp up of 10 user creating post every 5 seconds. At the same time, 10 user are quering the main page to read these posts in a ramp up of 5 second as well.

# Requirements

- You must have a local installations of [JMeter](https://jmeter.apache.org/usermanual/)
- At least, a remote instace of wordpress ready to be tested. You can also prepare a local instance.
- Optionally an installation of [`jq`](https://stedolan.github.io/jq/) would be useful

# Quick start

Install a local instance of wordpress and forward a port to your local machine.

```
$ helm install wp bitnami/wordpress --wait --set wordpressPassword=pass --set service.type=ClusterIP
$ kubectl port-forward svc/wp-wordpress 8888:80
```

**NOTE:** you can also use a docker-compose installation from [here](https://github.com/bitnami/bitnami-docker-wordpress/blob/master/docker-compose.yml), in this case, you will need to set up the password in the `environments` section.

Then throw the load test over the local instance

```
$ rm -rf dist && mkdir -p dist
$ HEAP="-Xms1g -Xmx1g -XX:MaxMetaspaceSize=256m" jmeter -n \
    -t wordpress.jmx \
    -l dist/wordpress.results.xml \
    -j dist/jmeter.log \
    -Jjmeter.save.saveservice.output_format=xml \
    -Jhttp.schema=http \
    -Jhost=localhost \
    -Jport=8888 \
    -Jwordpress.username=user \
    -Jwordpress.password=pass
```

You will see load test results in the `dist/` directory.

# Development

**See report form the execution graph**

```
$ mkdir -p dist
$ curl http://localhost:8080/v1/execution-graphs/25dc2da8-bbe3-4998-8ed1-c18982844584 | jq -r '.tasks[] | select(.action_id == "jmeter") | .result.raw_reports[0].raw_report' | base64 --decode > dist/jmeter.results.jtl.xml
```
