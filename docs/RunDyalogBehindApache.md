# RunDyalogBehindApache

With Dyalog's Conga, [Rumba](https://github.com/aplteam/RumbaLean "Link to the project on GitHub") or [Plodder ](https://github.com/aplteam/Plodder  "Link to the project on GitHub") you might well decide to serve HTTP requests with an application written in Dyalog  APL.

However, if your application serves requests from the Internet (as opposed to an Intranet) then it is strongly recommended to hide your application behind an industrial strength web server like Apache.

This comes not only with benefits in terms of security, and stronger defences against something like DDOS attacks, it also offers an easy way to implement load balancing.

Apache can be used in this way because it can act as a reverse proxy server, sometimes also called a gateway server. 

Let's assume that your application is listening on port 8081.

You need to add the following lines to the configuration file for your specific web site:

```
ProxyPreserveHost on
ProxyPass / http://localhost:8081/
ProxyPassReverse / http://localhost:8081/
```

This file is typically found in `/etc/apache2/sites-available`.

In `/etc/apache2/sites-enabled` there should be just a link pointing to `/etc/apache2/sites-available`.

The `ProxyPass` directive is doing the magic.

The `ProxyPassReverse` directive ensures that the `Location:` headers generated from the backend (your Dyalog application) are modified to point to the reverse proxy instead to itself.

You can chose to proxy specific requests by defining the URI path that should be handled:

```
ProxyPass "/v1"  "http://www.example.com/"
ProxyPassReverse "/v1"  "http://www.example.com/"
```

As a result all requests which start with the `/v1` path will be proxied, everything else will be handled locally.

Note that you can also use Regular Expressions; for that "ProxyPassMatch" must be used, for example:

```
ProxyPassMatch "/v1/(.*)" "http://localhost:9090/v1/$1"
```

You may have several "ProxyPassMatch" statements. The first match wins. If a URL does not match any RegEx then Apache will try to serve the request locally, meaning "documentRoot" in the Apache config files takes over.



For details see the ["Reverse Proxy Guide"](https://httpd.apache.org/docs/2.4/howto/reverse_proxy.html "Link to the Apache documentation") and [Apache Module mod_proxy](https://httpd.apache.org/docs/2.4/mod/mod_proxy.html "Link to the Apache documentation")