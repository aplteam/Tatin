
# Dyalog Docker Container

## Running
To use this image, you simply need to run
`docker run -it dyalog/dyalog`

You can mount a workspace directory in to /app, If there is a single workspace `.dws` or `.dyapp` file in this directory Dyalog will automatically load it in to the session.

`docker run -it -v /path/to/ws:/app dyalog/dyalog`

## Ride

If you wish to connect RIDE to the Dyalog running inside the container you have 2 options.

1) Run Dyalog with RIDE Protocol and connect stand alone ride:
  * Run: `docker run -it -v /path/to/ws:/app -e RIDE_INIT=serve:*:4502 -p 4502:4502 dyalog/dyalog`
  * Connect RIDE to localhost on port 4502.


2) Run RIDE integrated and connect with a web browser:
 * Run: `docker run -it -v /path/to/ws:/app -e RIDE_INIT=http:*:4502 -p 4502:4502 dyalog/dyalog`
 * Connect to http://localhost:4502 in your browser


## Licence
 * Dyalog is free for non-commercial use but is not free software.  Please see [here](https://www.dyalog.com/prices-and-licences.htm)  for our Licence Agreement and full Terms and Conditions.

 * You may not distribute software that includes Dyalog unless you have obtained an appropriate [Run Time Licence](https://www.dyalog.com/prices-and-licences.htm#runtimelic) from us but you can share your work with others who have their own Dyalog licence.  Note that we offer Run Time Licences suitable for non-commercial distribution.